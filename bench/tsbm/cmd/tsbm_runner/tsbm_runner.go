package main

/* TODO
 * reduce frequency at which PerfTimer updated
 * responseUsecs configurable
 * split timers for insert vs delete
 * time transactions in addition to inserts and deletes
 * RNG seed
 * create table, load then create index
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

/*
   See description in tsbm_loader
*/
var nDevices = flag.Int("devices", 100, "Number of devices per table")
var nMetrics = flag.Int("metrics", 10, "Number of metrics per device")

/*
   When fixedSize is true this should be the same as the value used during the load to maintain the same
   density of measurements/second/device. When fixedSize is false then use whatever you want.
*/
var nMetricsPerSec = flag.Int("metrics_per_sec", 1000,
	"Number of metrics to insert per second, when == 0 there is no rate limit.")

var nMeasurementsPerBatch = flag.Int("batch_size", 1, "Number of measurements per insert batch (per commit)")

var nTables = flag.Int("tables", 1, "Number of tables")
var nWritersPerTable = flag.Int("writers_per_table", 1, "Number of writers per table")
var nReadersPerTable = flag.Int("readers_per_table", 1, "Number of readers per table")

var fixedSize = flag.Bool("fixed", true,
	"When true delete oldest measurement when inserting a new measurement so that the table has a fixed size.")

var dataDur = flag.Duration("data_duration", 3600 * time.Second,
	"Duration for which data was loaded, latest timestamp - oldest timestamp. Value of 'measurement_duration' printed by tsbm_loader.")

var runDur = flag.Duration("run_duration", 60 * time.Second, "Duration for which this test runs.")

func main() {

	// Computed values
	var nMeasurementsPerSec int
	var nMeasurementsPerSecPerWriter int
	var nMeasurementsPerDev int64
	// All devices insert one measurement per measurementDur units of time
	var measurementDur time.Duration
	var nReaders int
	var nWriters int
	var devicesPerWriter int
	var devicesPerTable int
	var now time.Time

	// Other values
	var startTime time.Time

	flag.Parse()

	const startTimePattern = "2006-01-02 15:04:05 MST"
	const startTimeStr = "2000-01-01 12:00:00 PST"
	startTime, e := time.Parse(startTimePattern, startTimeStr)
	// fmt.Printf("Parsed time is :: %v ::\n", startTime)
	if e != nil {
		log.Fatalf("Cannot parse start_time: error is %v", e)
	}

	if *nDevices < 1 {
		log.Fatalf("--devices was %d, must be >= 1", *nDevices)
	}
	if *nMetrics < 1 {
		log.Fatalf("--metrics was %d, must be >= 1", *nMetrics)
	}
	if *nMetricsPerSec < 0 {
		log.Fatalf("--metrics_per_sec was %d, must be >= 1", *nMetricsPerSec)
	}
	if *nTables < 1 {
		log.Fatalf("--tables was %d, must be >= 1", *nTables)
	}
	if *nWritersPerTable < 1 {
		log.Fatalf("--writers_per_table was %d, must be >= 1", *nWritersPerTable)
	}
	if *nReadersPerTable < 1 {
		log.Fatalf("--readers_per_table was %d, must be >= 1", *nWritersPerTable)
	}
	if *nMeasurementsPerBatch < 1 {
		log.Fatalf("--batch_size was %d, must be >= 1", *nMeasurementsPerBatch)
	}

	nSeconds := runDur.Nanoseconds() / int64(time.Second)
	if (nSeconds * int64(time.Second)) != runDur.Nanoseconds() {
		log.Fatalf("run_duration must be a whole number of seconds")
	}

	// Computed values
	nReaders = *nTables * *nReadersPerTable
	nWriters = *nTables * *nWritersPerTable

        nMeasurementsPerSec = *nMetricsPerSec / *nMetrics
        if (nMeasurementsPerSec * (*nMetrics)) != *nMetricsPerSec {
                log.Fatalf("Remainder for nMetricsPerSec / nMetrics must be zero")
        }

	nMeasurementsPerSecPerWriter = nMeasurementsPerSec / nWriters
	if (nMeasurementsPerSecPerWriter * nWriters) != nMeasurementsPerSec {
		log.Fatalf("Remainder for nMeasurementsPerSec / nWriters must be zero")
	}

	batchesPerSecond := nMeasurementsPerSecPerWriter / *nMeasurementsPerBatch
	if (batchesPerSecond * (*nMeasurementsPerBatch)) != nMeasurementsPerSecPerWriter {
		log.Fatalf("Remainder for nMeasurementsPerSecPerWriter / nMeasurements must be zero")
	}

        devicesPerTable = *nDevices / *nTables
        if (devicesPerTable * *nTables) != *nDevices {
                log.Fatalf("Remainder for nDevices / nTables must be zero")
        }
        devicesPerWriter = devicesPerTable / *nWritersPerTable
        if (devicesPerWriter * *nWritersPerTable) != devicesPerTable {
                log.Fatalf("Remainder for devicesPerTable / nWritersPerTable must be zero")
        }

	nMeasurementsPerDev = int64(nMeasurementsPerSec) * int64(runDur.Seconds())

	nBatches := nMeasurementsPerDev / int64(*nMeasurementsPerBatch)
	if (nBatches * int64(*nMeasurementsPerBatch)) != nMeasurementsPerDev {
		log.Fatalf("Remainder for nMeasurementsPerDev / nMeasurementsPerBatch must be zero")
	}	

	measurementDur = time.Duration(float64(int64(*nDevices) * int64(time.Second)) / float64(nMeasurementsPerSec))

	now = startTime.Add(*dataDur).Add(1 * time.Second)

        fmt.Printf("devices: %d total, %d per-writer, %d per-table\n", *nDevices, devicesPerWriter, devicesPerTable)
        fmt.Printf("metrics: %d\n", *nMetrics)
        fmt.Printf("metrics_per_sec: %d\n", *nMetricsPerSec)
	fmt.Printf("measurements_per_dev: %d\n", nMeasurementsPerDev)
	fmt.Printf("measurements_per_sec: %d\n", nMeasurementsPerSec)
	fmt.Printf("measurements_per_sec_per_writer: %d\n", nMeasurementsPerSecPerWriter)
	fmt.Printf("measurement_duration: %v or %.3f seconds\n", measurementDur, measurementDur.Seconds())
	fmt.Printf("now: %v\n", now)
        fmt.Printf("run_duration: %v\n", *runDur)
        fmt.Printf("tables: %d\n", *nTables)
	fmt.Printf("writers: %d\n", nWriters)
	fmt.Printf("readers: %d\n", nReaders)

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

	writeTimers := make([]*util.PerfTimer, nWriters)

	insertHistograms := make([]*util.Histogram, nWriters)
	deleteHistograms := make([]*util.Histogram, nWriters)

	writeResponseUsecs := []int64{256, 512, 1024, 2048, 4096, 8192, 16384, 32768}

	myID := 0
	for t := 0; t < *nTables; t++ {
		minDeviceID := 0
		for w := 0; w < *nWritersPerTable; w++ {
			wg.Add(1)
			writeTimers[myID] = &util.PerfTimer{}
			insertHistograms[myID] = util.MakeHistogram(writeResponseUsecs)
			deleteHistograms[myID] = util.MakeHistogram(writeResponseUsecs)
			go doWrites(t, w, myID, &wg, db, writeTimers[myID], insertHistograms[myID], deleteHistograms[myID], now,
				nMeasurementsPerDev, measurementDur, minDeviceID, devicesPerWriter, *nMeasurementsPerBatch,
				nMeasurementsPerSecPerWriter)
			myID++
			minDeviceID += devicesPerWriter
		}
	}

	watcherCancel := make(chan bool)
	go util.PerfWatcher(writeTimers, 1*time.Second, watcherCancel)

	fmt.Println("main wait")
	wg.Wait()
	watcherCancel <- true
	<-watcherCancel

	insertHistSum := util.MakeHistogram(writeResponseUsecs)
	for x, h := range insertHistograms {
		fmt.Printf("Inserts(%d) %s\n", x, h.Summary(false))
		insertHistSum.Merge(h)
	}
	fmt.Printf("Inserts(all) %s\n", insertHistSum.Summary(false))

	deleteHistSum := util.MakeHistogram(writeResponseUsecs)
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

func doWrites(tableID int, writerID int, myID int, wg *sync.WaitGroup, db *sql.DB, writeTimer *util.PerfTimer,
	insertHistogram *util.Histogram, deleteHistogram *util.Histogram, now time.Time,
	nMeasurementsPerDev int64, measurementDur time.Duration,
	minDeviceID int, devicesPerWriter int, nMeasurementsPerBatch int, nMeasurementsPerSecPerWriter int) {

	defer wg.Done()
	dgen := datagen.MakeSeqGeneratorFlat(minDeviceID, devicesPerWriter, *nMetrics, now, nMeasurementsPerDev, measurementDur)
	nInserted := 0
	nDeleted := 0
	rowsPerBatch := (*nMetrics) * nMeasurementsPerBatch

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
	if nMeasurementsPerSecPerWriter > 0 {
		batchesPerSecond := nMeasurementsPerSecPerWriter / nMeasurementsPerBatch
		durPerBatch = time.Duration(time.Second.Nanoseconds() / int64(batchesPerSecond))
		fmt.Printf("durPerBatch = %v, batchesPerSecond = %v\n", durPerBatch, batchesPerSecond)
	}

	nBatches := nMeasurementsPerDev / int64(nMeasurementsPerBatch)

	var adjustInterval int64 = 0
	var adjustNsecs int64 = 0
	var adjustAmount float64 = 0.0
	var adjustFraction float64 = 0.95
	adjustStart := time.Now()

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
		// fmt.Printf("Inserted %d rows, but RowsAffected=%d: tableID=%d, params=%v\n", rowsPerBatch, rowCnt, tableID, m)
		nInserted += rowsPerBatch

		var deleteDur time.Duration = 0
		if *fixedSize {
			stepFrom := 4 * (*nMetrics)
			for xFrom := 1; xFrom <= (rowsPerBatch * 4); xFrom += stepFrom {
				deviceId := (m[xFrom]).(string)
				// fmt.Printf("DELETE deviceId = %s from %d of %d\n", deviceId, xFrom, rowsPerBatch*4)

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
			if sleepDur.Nanoseconds() > adjustNsecs {
				sleepDur = time.Duration(sleepDur.Nanoseconds() - adjustNsecs)
			}
			if adjustInterval == 99 {
				//fmt.Printf("Sleeping %v microseconds with iDur, dDur = (%v, %v)\n",
				//	sleepDur.Microseconds(), insertDur.Microseconds(), deleteDur.Microseconds())
			}
			time.Sleep(sleepDur)
		} else {
			fmt.Printf("No sleep, over by %v microseconds\n", (durPerBatch - (insertDur + deleteDur)).Microseconds())
		}

		if err = tx.Commit(); err != nil {
			log.Fatalf("Transaction commit failed: %s\n", err)
		}
		// log.Printf("Commit done\n")

		writeTimer.Report(int64(rowsPerBatch))

		loop++

		adjustInterval++
		if adjustInterval == 100 {
			expectedNsecs := adjustInterval * durPerBatch.Nanoseconds()
			now = time.Now()
			actualNsecs := now.Sub(adjustStart).Nanoseconds()
			deltaNsecs := (expectedNsecs - actualNsecs) / adjustInterval
			adjustAmount = (adjustFraction * adjustAmount) + ((1.0-adjustFraction) * float64(deltaNsecs))
			adjustInterval = 0
			adjustStart = now
			if adjustAmount < 0 {
				adjustNsecs = int64(-adjustAmount)
			} else {
				adjustNsecs = 0
			}
			//log.Printf("usecs (expected, actual, diff_per_batch) = (%v, %v, %v) and adjust=%v\n",
			//		expectedNsecs/1000, actualNsecs/1000, deltaNsecs/1000, int64(adjustAmount)/1000)
									
		}

		// log.Printf("Inserted %d rows with %s\n", rowsPerBatch, m)
	}
	if int64(loop) != nBatches {
		log.Fatalf("Expected %d batches but did %d\n", nBatches, loop)
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
