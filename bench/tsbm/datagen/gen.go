// Generates data to be inserted
package datagen

/* TODO
   * RNG seed
   * timestamps + partitions
   * timestamps - figure out, SeqGen goes from 1 to N, RandGen goes uses Time.UnixMicro
   * not flat RangeGenerator
*/

import (
	"log"
	"math/rand"
	"strconv"
	"time"
)

type MetricPair struct {
	MetricID    int32
	MetricValue int64
}

type Measurement struct {
	Timestamp int64
	DeviceID  int
	Metrics   []MetricPair
}

type SeqGenerator struct {
	stop		chan bool
	data		chan Measurement
	minDeviceID	int
	nDevices	int
	nMetrics	int
	startTime	time.Time
	nMeasurements	int64
	measurementDur	time.Duration
}

type SeqGeneratorFlat struct {
	stop		chan bool
	data		chan []interface{}
	minDeviceID	int
	nDevices	int
	nMetrics	int
	startTime	time.Time
	nMeasurements	int64
	measurementDur	time.Duration
}

type RandGeneratorFlat struct {
	stop          chan bool
	data          chan []interface{}
	nDevices      int
	nMetrics      int
	batchSize     int
	nBatches      int64
}

type GeneratorChan struct {
	Data <-chan Measurement
	Stop chan<- bool
}

type GeneratorChanFlat struct {
	Data <-chan []interface{}
	Stop chan<- bool
}

func (g *SeqGenerator) getMeasurement(deviceId int, timestamp int64) Measurement {
	pairs := make([]MetricPair, g.nMetrics)
	for x, _ := range pairs {
		pairs[x].MetricID = int32(x)
		pairs[x].MetricValue = rand.Int63()
	}
	return Measurement{timestamp, deviceId, pairs}
}

func (g *SeqGenerator) genData() {

	timestamp := g.startTime

	for nMeasure := int64(0); nMeasure < g.nMeasurements; nMeasure++ {
		for d := 0; d < g.nDevices; d++ {
			m := g.getMeasurement(d + g.minDeviceID, timestamp.UnixMicro())

			select {
			case <-g.stop:
				close(g.data)
				log.Printf("SeqGenerator closed: on request")
				return
			case g.data <- m:
			}
		}
		timestamp = timestamp.Add(g.measurementDur)
	}
	close(g.data)
	// log.Printf("SeqGenerator closed: done")
}

func getOneFlatMeasurement(timestamp int64, deviceId int, nMetrics int, values []interface{}) {
	timestampStr := strconv.FormatInt(timestamp, 10)
	deviceStr := strconv.FormatInt(int64(deviceId), 10)

	for x := 0; x < nMetrics; x++ {
		values[x*4] = timestampStr
		values[(x*4)+1] = deviceStr
		values[(x*4)+2] = strconv.FormatInt(int64(x), 10)
		ri63 := rand.Int63(); // Postgres does not do "bigint unsigned"
		values[(x*4)+3] = strconv.FormatInt(ri63, 10)
	}
}

func (g *SeqGeneratorFlat) getMeasurement(deviceId int, timestamp int64) []interface{} {
	// Ugh - https://stackoverflow.com/questions/57868506/cannot-use-args-type-string-as-type-interface
	values := make([]interface{}, 4 * g.nMetrics)
	getOneFlatMeasurement(timestamp, deviceId, g.nMetrics, values)
	return values
}

func (g *SeqGeneratorFlat) genData() {

	timestamp := g.startTime
	for nMeasure := int64(0); nMeasure < g.nMeasurements; nMeasure++ {
		for d := 0; d < g.nDevices; d++ {
			values := g.getMeasurement(d + g.minDeviceID, timestamp.UnixMicro())

			select {
			case <-g.stop:
				close(g.data)
				log.Printf("SeqGeneratorFlat closed: on request")
				return
			case g.data <- values:
			}
		}
		timestamp = timestamp.Add(g.measurementDur)
	}
	close(g.data)
	log.Printf("SeqGeneratorFlat closed: done")
}

func arrContains(usedIds []int, val int) bool {
	for _, v := range usedIds {
		if v == val {
			return true
		}
	}
	return false
}

func (g *RandGeneratorFlat) getMeasurement(timestamp int64) []interface{} {
	// Ugh - https://stackoverflow.com/questions/57868506/cannot-use-args-type-string-as-type-interface
	values := make([]interface{}, 4 * g.nMetrics * g.batchSize)
	usedIds := make([]int, g.batchSize)

	for b := 0; b < g.batchSize; b++ {
		deviceId := rand.Intn(g.nDevices)
		for arrContains(usedIds, deviceId) {
			deviceId = rand.Intn(g.nDevices)
		}
		usedIds = append(usedIds, deviceId)

		getOneFlatMeasurement(timestamp, deviceId, g.nMetrics, values[b*4*g.nMetrics:])
		// fmt.Printf("batch %d of %d: ts=%d dev=%d nMet=%d\n", b, g.batchSize, timestamp, deviceId, g.nMetrics)
	}
	return values
}

func (g *RandGeneratorFlat) genData() {

	// This runs until receiving from g.stop when nBatches is 0
	
	prevTimestamp := int64(0)

	for x := int64(0); ; x++ {
		if x > 0 && x == g.nBatches {
			break
		}

		/* There is a PK on (timestamp, deviceID, metricID) so make sure that
		   timestamp is not repeated across batches. */

		timestamp := time.Now().UnixMicro()
		for timestamp <= prevTimestamp {
			time.Sleep(1 * time.Microsecond)
			timestamp = time.Now().UnixMicro()
		}
		prevTimestamp = timestamp
		values := g.getMeasurement(timestamp)

		select {
		case <-g.stop:
			close(g.data)
			log.Printf("SeqGeneratorFlat closed: on request")
			return
		case g.data <- values:
		}
	}
	close(g.data)
	// log.Printf("RandGeneratorFlat closed: done")
}

func MakeSeqGenerator(minDeviceID int, nDevices int, nMetrics int, startTime time.Time, nMeasurements int64, measurementDur time.Duration) GeneratorChan {
	stopChan := make(chan bool)
	dataChan := make(chan Measurement)
	sg := SeqGenerator{stopChan, dataChan, minDeviceID, nDevices, nMetrics, startTime, nMeasurements, measurementDur}
	go sg.genData()
	return GeneratorChan{dataChan, stopChan}
}

func MakeSeqGeneratorFlat(minDeviceID int, nDevices int, nMetrics int, startTime time.Time, nMeasurements int64, measurementDur time.Duration) GeneratorChanFlat {
	stopChan := make(chan bool)
        // The consumer, DB prepared statements, needs []interface{} even though all elements are string
	dataChan := make(chan []interface{})
	sg := SeqGeneratorFlat{stopChan, dataChan, minDeviceID, nDevices, nMetrics, startTime, nMeasurements, measurementDur}
	go sg.genData()
	return GeneratorChanFlat{dataChan, stopChan}
}

func MakeRandGeneratorFlat(nDevices, nMetrics, batchSize int, nBatches int64) GeneratorChanFlat {
	stopChan := make(chan bool)
        // The consumer, DB prepared statements, needs []interface{} even though all elements are string
	dataChan := make(chan []interface{})
	rg := RandGeneratorFlat{stopChan, dataChan, nDevices, nMetrics, batchSize, nBatches}
	go rg.genData()
	return GeneratorChanFlat{dataChan, stopChan}
}
