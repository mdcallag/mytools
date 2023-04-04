package main

/* TODO
   * reduce frequency at which PerfTimer updated
   * responseUsecs configurable
   * split timers for insert vs delete
   * time transactions in addition to inserts and deletes
   * RNG seed
 */

import (
	"database/sql"
	"flag"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/lib/pq"
	"github.com/mdcallag/mytools/bench/tsbm/datagen"
	"github.com/mdcallag/mytools/bench/tsbm/util"
	"log"
	"math/rand"
	"sync"
	"time"
)

var dbms = flag.String("dbms", "mysql", "Database driver name")

// postgres://root:pw@localhost/tsbm?sslmode=disable
var dbmsConn = flag.String("dbms_conn", "root:pw@tcp(127.0.0.1:3306)/tsbm", "DBMS connection string")
var dbmsTablePrefix = flag.String("dbms_table_prefix", "t", "Prefix for DBMS table names")

var nDevices = flag.Int("devices", 100, "Number of devices per table")
var nTables = flag.Int("tables", 1, "Number of tables")
var nMetrics = flag.Int("metrics", 100, "Number of metrics per device")

var nWriters = flag.Int("writers", 1, "Number of concurrent writers")
var nReaders = flag.Int("readers", 1, "Number of concurrent readers")
var fixedSize = flag.Bool("fixed", true, "When true delete oldest metric when adding a new metric")
var batchSize = flag.Int("batch_size", 2, "Number of devices per insert")
var nBatches = flag.Int64("batches", 5, "Number of batches of inserts")
var insertsPerSecond = flag.Int("inserts_per_second", 0,
                                "Number of rows inserted/second/writer. When <= 0 there is no rate limit.")

func main() {
	flag.Parse()

	if *batchSize > *nDevices {
		log.Fatal("--batch_size must be <= --devices")
	}

	if *nTables < 1 {
		log.Fatal("--tables must be >= 1")
	}

	db, err := sql.Open(*dbms, *dbmsConn)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	fmt.Printf("Ping dbms(%s) at: %s\n", *dbms, *dbmsConn)
	err = db.Ping()
	if err != nil {
		log.Fatalf("Ping failed: %s\n", err)
	}

	wg := sync.WaitGroup{}

	writeTimers := make([]*util.PerfTimer, *nWriters)

	insertHistograms := make([]*util.Histogram, *nWriters)
	deleteHistograms := make([]*util.Histogram, *nWriters)

	responseUsecs := []int64{256, 512, 1024, 2048, 4096, 8192, 16384, 32768}

	for x := 0; x < *nWriters; x++ {
		wg.Add(1)
		writeTimers[x] = &util.PerfTimer{}
		insertHistograms[x] = util.MakeHistogram(responseUsecs)
		deleteHistograms[x] = util.MakeHistogram(responseUsecs)
		go doWrites(x, &wg, db, writeTimers[x], insertHistograms[x], deleteHistograms[x])
	}

	watcherCancel := make(chan bool)
	go util.PerfWatcher(writeTimers, 1 * time.Second, watcherCancel)

	fmt.Println("main wait")
	wg.Wait()
	watcherCancel <- true
	<-watcherCancel

	insertHistSum := util.MakeHistogram(responseUsecs)
	for x, h := range insertHistograms {
		fmt.Printf("Inserts(%d) %s\n", x, h.Summary(false))
		insertHistSum.Merge(h)
	}
	fmt.Printf("Inserts(all) %s\n", insertHistSum.Summary(false))

	deleteHistSum := util.MakeHistogram(responseUsecs)
	for x, h := range deleteHistograms {
		fmt.Printf("Deletes(%d) %s\n", x, h.Summary(false))
		deleteHistSum.Merge(h)
	}
	fmt.Printf("Deletes(all) %s\n", deleteHistSum.Summary(false))
}

func explainSQL(db *sql.DB, sqlText string) {

	fmt.Println(sqlText)

	rows, err := db.Query(sqlText)
	if err != nil {
		log.Fatal(err)
	}

	// ctypes, err := rows.ColumnTypes()
	// for x, ct := range ctypes {
	//	fmt.Printf("[%d] = %s, %s, %s\n", x, ct.Name(), ct.DatabaseTypeName(), ct.ScanType().Name())
	// }

	cNames, err := rows.Columns()
	// fmt.Printf("ncols : %d and %s\n", len(cNames), cNames)
	nCols := len(cNames)
	acols := make([]any, nCols)
	scols := make([]sql.NullString, nCols)
	for x := 0; x < nCols; x++ {
		acols[x] = &scols[x]
	}

	for rows.Next() {
		if err := rows.Scan(acols...); err != nil {
			log.Fatal(err)
		}
		for x, e := range scols {
			if e.Valid {
				fmt.Printf(e.String)
			} else {
				fmt.Printf("NULL")
			}
			if x < (len(scols) - 1) {
				fmt.Printf("\t")
			} else {
				fmt.Printf("\n")
			}
		}
	}
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}    
}

func makeDeleteStmts(myID int, db *sql.DB) []*sql.Stmt {
	deleteStmts := make([]*sql.Stmt, *nTables)
	for nStmt := 0; nStmt < *nTables; nStmt++ {
		deleteSQL := ""
		explainDelete := ""

		if *dbms == "postgres" {
			deleteSQL = fmt.Sprintf("DELETE FROM %s%d WHERE deviceid=%s AND timestamp IN (SELECT MIN(timestamp) FROM %s%d WHERE deviceid=%s)",
					 	*dbmsTablePrefix, nStmt, getPH(*dbms, 1),
					 	*dbmsTablePrefix, nStmt, getPH(*dbms, 2))
			explainDelete = fmt.Sprintf("EXPLAIN DELETE FROM %s%d WHERE deviceid=1 AND timestamp IN (SELECT MIN(timestamp) FROM %s%d WHERE deviceid=1)",
					 	    *dbmsTablePrefix, nStmt, *dbmsTablePrefix, nStmt)
		} else if *dbms == "mysql" {
       	 		// delete from t0 where deviceid = 8081 and timestamp in (select min(timestamp) from t0 where deviceid=8081);
			// deleteSQL = fmt.Sprintf("DELETE FROM %s%d WHERE deviceid=%s AND timestamp IN (SELECT MIN(timestamp) FROM %s%d WHERE deviceid=%s)",
			// deleteSQL = fmt.Sprintf("DELETE FROM %s%d WHERE deviceid=%s AND timestamp = 1", *dbmsTablePrefix, nStmt, getPH(*dbms, 1))
			// Workaround for the dreaded error 1093. Alas, this appears to materialize the subquery which might hurt perf.
			deleteSQL = fmt.Sprintf("DELETE FROM %s%d WHERE deviceid=%s AND timestamp IN (SELECT * FROM (SELECT MIN(timestamp) FROM %s%d WHERE deviceid=%s) as HACK)",
				 		*dbmsTablePrefix, nStmt, getPH(*dbms, 1),
				 		*dbmsTablePrefix, nStmt, getPH(*dbms, 2))
			explainDelete = fmt.Sprintf("EXPLAIN DELETE FROM %s%d WHERE deviceid=1 AND timestamp IN (SELECT * FROM (SELECT MIN(timestamp) FROM %s%d WHERE deviceid=1) as HACK)",
		   	 	    		    *dbmsTablePrefix, nStmt, *dbmsTablePrefix, nStmt)
		} else {
			log.Fatalf("DBMS %s is not known", *dbms)
		}

		if myID == 0 {
			explainSQL(db, explainDelete)
			fmt.Println(deleteSQL)
		}

		deletePS, err := db.Prepare(deleteSQL)
		if err != nil {
			log.Fatalf("Prepare failed for (%s): %v\n", deleteSQL, err)
		}
		deleteStmts[nStmt] = deletePS
	}
	return deleteStmts
}

func makeInsertStmts(myID int, db *sql.DB, rowsPerBatch int) []*sql.Stmt {

	insertStmts := make([]*sql.Stmt, *nTables)
	for nStmt := 0; nStmt < *nTables; nStmt++ {
		insertSQL := fmt.Sprintf("INSERT INTO %s%d(timestamp,deviceID,metricID,metricValue) VALUES ", *dbmsTablePrefix, nStmt)
		for x := 1; x <= rowsPerBatch; x++ {
			phx := (x - 1) * 4
			insertSQL += fmt.Sprintf("(%s,%s,%s,%s)", getPH(*dbms, phx+1), getPH(*dbms, phx+2), getPH(*dbms, phx+3), getPH(*dbms, phx+4))
			if x < rowsPerBatch {
				insertSQL += ", "
			}
		}
		if myID == 0 {
			fmt.Println(insertSQL)
		}
		insertPS, err := db.Prepare(insertSQL)
		if err != nil {
			log.Fatalf("Prepare failed for (%s): %v\n", insertSQL, err)
		}
		insertStmts[nStmt] = insertPS
	}
	return insertStmts
}

func doWrites(myID int, wg *sync.WaitGroup, db *sql.DB, writeTimer *util.PerfTimer, insertHistogram *util.Histogram, deleteHistogram *util.Histogram) {
	defer wg.Done()
	dgen := datagen.MakeRandGeneratorFlat(*nDevices, *nMetrics, *batchSize, *nBatches)
	nInserted := 0
	nDeleted := 0
	rowsPerBatch := (*nMetrics) * (*batchSize)

	var insertStmts []*sql.Stmt = makeInsertStmts(myID, db, rowsPerBatch)
	for _, insertPS := range insertStmts {
		defer insertPS.Close()
	}

	var deleteStmts []*sql.Stmt
	if *fixedSize {
		deleteStmts = makeDeleteStmts(myID, db)
		for _, deletePS := range deleteStmts {
			defer deletePS.Close()
		}
	}

	var durPerBatch time.Duration = 0
	if *insertsPerSecond > 0 {
		batchesPerSecond := *insertsPerSecond / rowsPerBatch
		durPerBatch = time.Duration(int(time.Second) / batchesPerSecond)
		fmt.Printf("durPerBatch = %v, batchesPerSecond = %v\n", durPerBatch, batchesPerSecond)
	}

	writeTimer.Start()
	loop := 0
	for m := range dgen.Data {

		tableID := rand.Intn(*nTables)
	
		tx, err := db.Begin()
		if err != nil {
			log.Fatalf("Transaction begin failed: %s\n", err)
		}

		start := time.Now()
		insertPS := insertStmts[tableID]
		res, err := insertPS.Exec(m...)
		end := time.Now()
		if err != nil {
			log.Fatalf("Insert failed tableID=%d, params=%v: %v\n", tableID, m, err)
		}
		insertDur := end.Sub(start)
		insertHistogram.Add(insertDur.Microseconds(), false)

		rowCnt, err := res.RowsAffected()
		if err != nil {
			log.Fatalf("RowsAffected failed tableID=%d, params=%v: %v\n", tableID, m, err)
		}
		if rowCnt != int64(rowsPerBatch) {
			log.Fatalf("Inserted %d rows, but RowsAffected=%d: tableID=%d, params=%v\n", rowsPerBatch, rowCnt, tableID, m)
		}
		nInserted += rowsPerBatch

		var deleteDur time.Duration = 0
		if *fixedSize {
			stepFrom := 4 * (*nMetrics)
			for xFrom := 1; xFrom <= (rowsPerBatch*4); xFrom += stepFrom { 
				deviceId := (m[xFrom]).(string)
				// fmt.Printf("deviceId = %s from %d of %d\n", deviceId, xFrom, rowsPerBatch*4)

				start := time.Now()
				// res, err := deletePS.Exec(deviceId) -- TODO hack for debugging mysql perf
				deletePS := deleteStmts[tableID]
				res, err := deletePS.Exec(deviceId, deviceId)
				end := time.Now()

				if err != nil {
					log.Fatalf("Delete failed tableID=%d, params=%v: %v\n", tableID, deviceId, err)
				}
				deleteDur = end.Sub(start)
				deleteHistogram.Add(deleteDur.Microseconds(), false)
				rowCnt, err := res.RowsAffected()
				if err != nil {
					log.Fatalf("RowsAffected failed tableID=%d, params=%v: %v\n", tableID, deviceId, err)
				}
				// if rowCnt > int64(*nMetrics) {  -- TODO hack for debugging mysql perf
				if rowCnt != int64(*nMetrics) {
					log.Fatalf("Delete expected %d rows, but RowsAffected=%d: tableID=%d, params=%v\n", *nMetrics, rowCnt, tableID, deviceId)
				}
			}
			nDeleted += rowsPerBatch
		}
		if (insertDur + deleteDur) < durPerBatch {
			sleepDur := durPerBatch - (insertDur + deleteDur)
			// fmt.Printf("Sleeping %v microseconds\n", sleepDur.Microseconds())
			time.Sleep(sleepDur)
		}

		if err = tx.Commit(); err != nil {
			log.Fatalf("Transaction commit failed: %s\n", err)
		}
		// log.Printf("Commit done\n")

		writeTimer.Report(int64(rowsPerBatch))

		loop++
		// log.Printf("Inserted %d rows with %s\n", rowsPerBatch, m)
	}
	if int64(loop) != *nBatches {
		log.Fatalf("Expected %s batches but did %s\n", *nBatches, loop)
	}
}

func getPH(dbms string, n int) string {
	switch dbms {
	case "mysql":
		return "?"
	case "postgres":
		return fmt.Sprintf("$%d", n)
	default:
		log.Fatalf("DBMS(%s) not supported\n", dbms)
		return ""
	}
}

