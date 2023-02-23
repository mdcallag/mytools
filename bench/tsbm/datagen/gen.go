// Generates data to be inserted
package datagen

/* TODO
   * RNG seed
   * timestamps + partitions
*/

import (
	"log"
	"math/rand"
	"strconv"
)

type MetricPair struct {
	MetricID    uint32
	MetricValue uint64
}

type Measurement struct {
	Timestamp uint64
	DeviceID  uint64
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

type GeneratorChan struct {
	Data <-chan Measurement
	Stop chan<- bool
}

type GeneratorChanFlat struct {
	Data <-chan []interface{}
	Stop chan<- bool
}

func (g *SeqGenerator) getMeasurement(dID, ts uint64) Measurement {
	pairs := make([]MetricPair, g.nMetrics)
	for x, _ := range pairs {
		pairs[x].MetricID = uint32(x)
		pairs[x].MetricValue = rand.Uint64()
	}
	return Measurement{ts, dID, pairs}
}

func (g *SeqGenerator) genData() {

	for dID := 1; dID <= g.nDevices; dID++ {
		timestamp := uint64(1)
		for nMeasure := 1; nMeasure <= g.nMeasurements; nMeasure++ {
			m := g.getMeasurement(uint64(dID), timestamp)
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

func (g *SeqGeneratorFlat) getMeasurement(dID, ts uint64) []interface{} {
	// Ugh - https://stackoverflow.com/questions/57868506/cannot-use-args-type-string-as-type-interface
	values := make([]interface{}, 4 * g.nMetrics)
	for x := 0; x < g.nMetrics; x++ {
		values[x*4] = strconv.FormatUint(ts, 10)
		values[(x*4)+1] = strconv.FormatUint(dID, 10)
		values[(x*4)+2] = strconv.FormatInt(int64(x), 10)
		// Postgres does do "bigint unsigned"
		ri63 := rand.Int63();
		values[(x*4)+3] = strconv.FormatInt(ri63, 10)
	}
	return values
}

func (g *SeqGeneratorFlat) genData() {

	for dID := 1; dID <= g.nDevices; dID++ {
		timestamp := uint64(1)
		for nMeasure := 1; nMeasure <= g.nMeasurements; nMeasure++ {
			values := g.getMeasurement(uint64(dID), timestamp)
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

func MakeSeqGenerator(nDevices, nMetrics, nMeasurements int) GeneratorChan {
	stopChan := make(chan bool)
	dataChan := make(chan Measurement)
	sg := SeqGenerator{stopChan, dataChan, nDevices, nMetrics, nMeasurements}
	go sg.genData()
	return GeneratorChan{dataChan, stopChan}
}

func MakeSeqGeneratorFlat(nDevices, nMetrics, nMeasurements int) GeneratorChanFlat {
	stopChan := make(chan bool)
	dataChan := make(chan []interface{})
	sg := SeqGeneratorFlat{stopChan, dataChan, nDevices, nMetrics, nMeasurements}
	go sg.genData()
	return GeneratorChanFlat{dataChan, stopChan}
}
