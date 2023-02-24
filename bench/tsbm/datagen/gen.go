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
	DeviceID  int64
	Metrics   []MetricPair
}

type SeqGenerator struct {
	stop          chan bool
	data          chan Measurement
	nDevices      int
	nMetrics      int
	nMeasurements int
}

type SeqGeneratorFlat struct {
	stop          chan bool
	data          chan []interface{}
	nDevices      int
	nMetrics      int
	nMeasurements int
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

func (g *SeqGenerator) getMeasurement(deviceId, timestamp int64) Measurement {
	pairs := make([]MetricPair, g.nMetrics)
	for x, _ := range pairs {
		pairs[x].MetricID = int32(x)
		pairs[x].MetricValue = rand.Int63()
	}
	return Measurement{timestamp, deviceId, pairs}
}

func (g *SeqGenerator) genData() {

	for dID := 1; dID <= g.nDevices; dID++ {
		timestamp := int64(1)
		for nMeasure := 1; nMeasure <= g.nMeasurements; nMeasure++ {
			m := g.getMeasurement(int64(dID), timestamp)
			timestamp++

			select {
			case <-g.stop:
				close(g.data)
				log.Printf("SeqGenerator closed: on request")
				return
			case g.data <- m:
			}
		}
	}
	close(g.data)
	// log.Printf("SeqGenerator closed: done")
}

func getOneFlatMeasurement(timestamp int64, deviceId int64, nMetrics int, values []interface{}) {
	timestampStr := strconv.FormatInt(timestamp, 10)
	deviceStr := strconv.FormatInt(deviceId, 10)

	for x := 0; x < nMetrics; x++ {
		values[x*4] = timestampStr
		values[(x*4)+1] = deviceStr
		values[(x*4)+2] = strconv.FormatInt(int64(x), 10)
		ri63 := rand.Int63(); // Postgres does not do "bigint unsigned"
		values[(x*4)+3] = strconv.FormatInt(ri63, 10)
	}
}

func (g *SeqGeneratorFlat) getMeasurement(deviceId, timestamp int64) []interface{} {
	// Ugh - https://stackoverflow.com/questions/57868506/cannot-use-args-type-string-as-type-interface
	values := make([]interface{}, 4 * g.nMetrics)
	getOneFlatMeasurement(timestamp, deviceId, g.nMetrics, values)
	return values
}

func (g *SeqGeneratorFlat) genData() {

	for deviceId := 1; deviceId <= g.nDevices; deviceId++ {
		timestamp := int64(1)
		for nMeasure := 1; nMeasure <= g.nMeasurements; nMeasure++ {
			values := g.getMeasurement(int64(deviceId), timestamp)
			timestamp++

			select {
			case <-g.stop:
				close(g.data)
				log.Printf("SeqGeneratorFlat closed: on request")
				return
			case g.data <- values:
			}
		}
	}
	close(g.data)
	// log.Printf("SeqGeneratorFlat closed: done")
}

func arrContains(usedIds []int64, val int64) bool {
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
	usedIds := make([]int64, g.batchSize)

	for b := 0; b < g.batchSize; b++ {
		deviceId := int64(rand.Intn(g.nDevices))
		for arrContains(usedIds, deviceId) {
			deviceId = int64(rand.Intn(g.nDevices))
		}
		usedIds = append(usedIds, deviceId)

		getOneFlatMeasurement(timestamp, deviceId, g.nMetrics, values[b*4*g.nMetrics:])
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

func MakeSeqGenerator(nDevices, nMetrics, nMeasurements int) GeneratorChan {
	stopChan := make(chan bool)
	dataChan := make(chan Measurement)
	sg := SeqGenerator{stopChan, dataChan, nDevices, nMetrics, nMeasurements}
	go sg.genData()
	return GeneratorChan{dataChan, stopChan}
}

func MakeSeqGeneratorFlat(nDevices, nMetrics, nMeasurements int) GeneratorChanFlat {
	stopChan := make(chan bool)
        // The consumer, DB prepared statements, needs []interface{} even though all elements are string
	dataChan := make(chan []interface{})
	sg := SeqGeneratorFlat{stopChan, dataChan, nDevices, nMetrics, nMeasurements}
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
