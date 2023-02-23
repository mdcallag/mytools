package main

/* TODO
   * batchSize for inserts
   * reduce frequency at which PerfTimer updated
   * responseUsecs configurable
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
	"sync"
	"time"
)

// var batchSize = flag.Int("batch", 1, "Size of an insert batch")
var dbms = flag.String("dbms", "mysql", "Database driver name")

// postgres://root:pw@localhost/tsbm?sslmode=disable
var dbmsConn = flag.String("dbms_conn", "root:pw@tcp(127.0.0.1:3306)/tsbm", "DBMS connection string")
var dbmsTablePrefix = flag.String("dbms_table_prefix", "t", "Prefix for DBMS table names")

var nDevices = flag.Int("devices", 100, "Number of devices per table")
var nTables = flag.Int("tables", 1, "Number of tables")
var nMeasurements = flag.Int("measurements", 5, "Number of measurements per device")
var nMetrics = flag.Int("metrics", 2, "Number of metrics per device")

func main() {
	flag.Parse()

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

	timers := make([]*util.PerfTimer, *nTables)
	histograms := make([]*util.Histogram, *nTables)
	responseUsecs := []int64{256, 512, 1024, 2048, 4096, 8192, 16384, 32768}

	for x := 0; x < *nTables; x++ {
		wg.Add(1)
		timers[x] = &util.PerfTimer{}
		histograms[x] = util.MakeHistogram(responseUsecs)
		go doLoad(x, &wg, db, timers[x], histograms[x])
	}

	watcherCancel := make(chan bool)
	go util.PerfWatcher(timers, 1 * time.Second, watcherCancel)

	fmt.Println("main wait")
	wg.Wait()
	watcherCancel <- true
	<-watcherCancel

	hSum := util.MakeHistogram(responseUsecs)
	for x, h := range histograms {
		fmt.Printf("table %d: %s\n", x, h.Summary(false))
		hSum.Merge(h)
	}
	fmt.Printf("table all: %s\n", hSum.Summary(false))
}

func doLoad(myID int, wg *sync.WaitGroup, db *sql.DB, timer *util.PerfTimer, histogram *util.Histogram) {
	defer wg.Done()
	dgen := datagen.MakeSeqGeneratorFlat(*nDevices, *nMetrics, *nMeasurements)
	nInserted := 0

	ps := fmt.Sprintf("INSERT INTO %s%d(timestamp,deviceID,metricID,metricValue) VALUES ", *dbmsTablePrefix, myID)

	for x := 1; x <= *nMetrics; x++ {
		phx := (x - 1) * 4
		ps += fmt.Sprintf("(%s,%s,%s,%s)", getPH(*dbms, phx+1), getPH(*dbms, phx+2), getPH(*dbms, phx+3), getPH(*dbms, phx+4))
		if x < *nMetrics {
			ps += ", "
		}
	}
	fmt.Println(ps)
	stmt, err := db.Prepare(ps)
	if err != nil {
		log.Fatalf("Prepare failed for (%s): %v\n", ps, err)
	}
	defer stmt.Close()

	timer.Start()
	for m := range dgen.Data {

		start := time.Now()
		res, err := stmt.Exec(m...)
		end := time.Now()
		histogram.Add(end.Sub(start).Microseconds(), false)

		if err != nil {
			log.Fatalf("Insert failed sql=%s params=%v: %v\n", ps, m, err)
		}
		rowCnt, err := res.RowsAffected()
		if err != nil {
			log.Fatalf("RowsAffected failed sql=%s params=%v: %v\n", ps, m, err)
		}
		if rowCnt != int64(*nMetrics) {
			log.Fatalf("Inserted %d rows, but RowsAffected=%d: sql=%s params=%v\n", *nMeasurements, rowCnt, ps, m)
		}
		nInserted += *nMetrics
		timer.Report(int64(*nMetrics))
	}

	/*
		numValues := (*nDevices) * (*nMeasurements)
		xm := 1
		for m := range dgen.Data {
			fmt.Printf("gen[%d] (%d of %d) = %v\n", myID, xm, numValues, m)
			for metric := range m.Metrics {
				stmt.Exec
			}
			xm++
		}
	*/
	// nSecs := timer.Seconds()
	// fmt.Printf("doLoad %d inserted %d rows in %.3f seconds, %.1f rows/sec\n", myID, nInserted, nSecs, float64(nInserted) / nSecs)
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

