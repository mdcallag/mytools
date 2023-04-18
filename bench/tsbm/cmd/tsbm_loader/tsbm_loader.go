package main

/* TODO
 * batchSize for inserts
 * reduce frequency at which PerfTimer updated
 * responseUsecs configurable
 * option to insert metrics X measurements, today just does metrics
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

var dbms = flag.String("dbms", "mysql", "Database driver name")

// postgres://root:pw@localhost/tsbm?sslmode=disable
var dbmsConn = flag.String("dbms_conn", "root:pw@tcp(127.0.0.1:3306)/tsbm", "DBMS connection string")
var dbmsTablePrefix = flag.String("dbms_table_prefix", "t", "Prefix for DBMS table names")

/*
  A measurement is all metrics for one device from one point in time. It is inserted in one transaction.

  Configuration:
    * Database size -> nRows = nDevices * nMeasurementsPerDev * nMetrics
    * nMetricsPerSec = nMeasurementsPerSec * nMetrics
    * Data is inserted for time range (startTime, endTime)

  Some of these values are set by the user while others are computed.
    * nMetricsPerSec is the insert rate assuming there is a row per metric
    * User provides values for nRows, nDevices and nMetrics while nMeasurementsPerDev is computed.
	nMeasurementsPerDev = nRows / (nDevices * nMetrics)
    * User provides values for nMetricsPerSec, nDevices and nMetrics while nMeasurementsPerSec is computed.
	nMeasurementsPerSec = nMetricsPerSec / nMetrics
    * startTime is fixed while endTime is computed.
	endTime = startTime + ((nMeasurementsPerDev * nDevices) / nMeasurementsPerSec) seconds
    * all devices report one measurement every measurementDur units of time
        measurementDur = (nDevices / nMeasurementsPerSec) * time.Second
*/
var nRows = flag.Int64("rows", 1000000, "Number of rows to load")
var nDevices = flag.Int("devices", 100, "Number of devices per table")
var nMetrics = flag.Int("metrics", 10, "Number of metrics per device")

/*
   This is the insert rate that should be sustained in normal operation (after the load is done).
   But it also determines the rate at which devices must report measurements during the load so
   that the density of data (number of metric/second/device) in the loaded data matches
   the density after the load (assuming that the post-load insert rate can be sustained).

   By density of data during the load I don't mean the insert rate during the load. I do mean
   the measurements per second if you did something like:
     select count(*), as_second(timestamp), deviceID from Table group by 2, 3
*/
var nMetricsPerSec = flag.Int("metrics_per_sec", 1000, "Number of metrics to insert per second")

var nTables = flag.Int("tables", 1, "Number of tables. Data is evenly split across tables.")
var nWritersPerTable = flag.Int("writers_per_table", 1, "Number of writers per table")

func main() {
	// Computed values
	var nMeasurementsPerDev int64
	var nMeasurementsPerSec int
	var endTime time.Time
	// dataDur = endTime - startTime
	var dataDur time.Duration
	// All devices insert one measurement per measurementDur units of time
	var measurementDur time.Duration

	// Parsed values
	// TODO

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

	if *nRows < 1 {
		log.Fatalf("--rows was %d, must be >= 1", *nRows)
	}
	if *nDevices < 1 {
		log.Fatalf("--devices was %d, must be >= 1", *nDevices)
	}
	if *nMetrics < 1 {
		log.Fatalf("--metrics was %d, must be >= 1", *nMetrics)
	}
	if *nMetricsPerSec < 1 {
		log.Fatalf("--metrics_per_sec was %d, must be >= 1", *nMetricsPerSec)
	}
	if *nTables < 1 {
		log.Fatalf("--tables was %d, must be >= 1", *nTables)
	}
	if *nWritersPerTable < 1 {
		log.Fatalf("--writers_per_table was %d, must be >= 1", *nWritersPerTable)
	}

	// Computed values

	nMeasurementsPerDev = *nRows / (int64(*nDevices) * int64(*nMetrics))
	if nMeasurementsPerDev < 10 {
		log.Fatalf("measurements per device, rows/(devices*metrics), must be >= 10, was %d", nMeasurementsPerDev)
	}
	if (nMeasurementsPerDev * int64(*nDevices) * int64(*nMetrics)) != *nRows {
		log.Fatalf("Remainder for nRows / (nDevices * nMetrics) must be zero")
	}

	nMeasurementsPerSec = *nMetricsPerSec / *nMetrics
	if (nMeasurementsPerSec * (*nMetrics)) != *nMetricsPerSec {
		log.Fatalf("Remainder for nMetricsPerSec / nMetrics must be zero")
	}

	measurementDur = time.Duration(float64(int64(*nDevices) * int64(time.Second)) / float64(nMeasurementsPerSec))

	// dataDur is endTime - startTime
	dataDur = time.Duration((float64(nMeasurementsPerDev * int64(*nDevices)) / float64(nMeasurementsPerSec))) * time.Second
	endTime = startTime.Add(dataDur)

	nWriters := *nTables * *nWritersPerTable

	devicesPerTable := *nDevices / *nTables
	if (devicesPerTable * *nTables) != *nDevices {
		log.Fatalf("Remainder for nDevices / nTables must be zero")
	}
	devicesPerWriter := devicesPerTable / *nWritersPerTable
	if (devicesPerWriter * *nWritersPerTable) != devicesPerTable {
		log.Fatalf("Remainder for devicesPerTable / nWritersPerTable must be zero")
	}

	// Print
	fmt.Printf("rows: %d\n", *nRows)
	fmt.Printf("devices: %d total, %d per-writer, %d per-table\n", *nDevices, devicesPerWriter, devicesPerTable)
	fmt.Printf("metrics: %d\n", *nMetrics)
	fmt.Printf("metrics_per_sec: %d\n", *nMetricsPerSec)
	fmt.Printf("measurements_per_device: %d\n", nMeasurementsPerDev)
	fmt.Printf("measurements_per_sec: %d\n", nMeasurementsPerSec)
	fmt.Printf("measurement_duration: %v or %.3f seconds\n", measurementDur, measurementDur.Seconds())
	fmt.Printf("start_time: %v\n", startTime)
	fmt.Printf("end_time: %v\n", endTime)
	fmt.Printf("data_duration: %v\n", dataDur)
	fmt.Printf("tables: %d\n", *nTables)
	fmt.Printf("writers: %d\n", nWriters)

	if dataDur < (1 * time.Second) {
		log.Fatalf("end_time - start_time is %v, must be >= 1 seconds", dataDur)
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

	timers := make([]*util.PerfTimer, nWriters)
	histograms := make([]*util.Histogram, nWriters)
	responseUsecs := []int64{256, 512, 1024, 2048, 4096, 8192, 16384, 32768}

	myID := 0
	for t := 0; t < *nTables; t++ {
		minDeviceID := 0
		for w := 0; w < *nWritersPerTable; w++ {
			wg.Add(1)
			timers[myID] = &util.PerfTimer{}
			histograms[myID] = util.MakeHistogram(responseUsecs)
			go doLoad(t, w, myID, &wg, db, timers[myID], histograms[myID], startTime,
				nMeasurementsPerDev, measurementDur, minDeviceID, devicesPerWriter)
			myID++
			minDeviceID += devicesPerWriter
		}
	}

	watcherCancel := make(chan bool)
	go util.PerfWatcher(timers, 1*time.Second, watcherCancel)

	fmt.Println("main wait")
	wg.Wait()
	watcherCancel <- true
	<-watcherCancel

	hSum := util.MakeHistogram(responseUsecs)
	for x, h := range histograms {
		fmt.Printf("Response time(usecs) for table %d: %s\n", x, h.Summary(false))
		hSum.Merge(h)
	}
	fmt.Printf("Response time(usecs) for all tables: %s\n", hSum.Summary(false))
}

func doLoad(tableID int, writerID int, myID int, wg *sync.WaitGroup, db *sql.DB, timer *util.PerfTimer,
	histogram *util.Histogram, startTime time.Time,
	nMeasurementsPerDev int64, measurementDur time.Duration,
	minDeviceID int, devicesPerWriter int) {

	defer wg.Done()
	dgen := datagen.MakeSeqGeneratorFlat(minDeviceID, devicesPerWriter, *nMetrics, startTime, nMeasurementsPerDev, measurementDur)
	nInserted := 0

	ps := fmt.Sprintf("INSERT INTO %s%d(timestamp,deviceID,metricID,metricValue) VALUES ", *dbmsTablePrefix, tableID)

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
		// fmt.Printf("try insert %d : %d : %d : %v\n", tableID, writerID, myID, m)
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
			log.Fatalf("Inserted %d rows, but RowsAffected=%d: sql=%s params=%v\n", nMeasurementsPerDev, rowCnt, ps, m)
		}
		nInserted += *nMetrics
		timer.Report(int64(*nMetrics))
	}

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
