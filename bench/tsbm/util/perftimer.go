package util

import (
	"fmt"
	"log"
	"strconv"
	"strings"
	"sync"
	"time"
)

type PerfTimer struct {
	mu       sync.Mutex
	startTS  time.Time
	prevTS   time.Time
	lastTS   time.Time
	totalOps int64
	lastOps  int64
	prevOps  int64
	updated  bool
}

func (p *PerfTimer) checkStarted() {
	if p.startTS.IsZero() {
		log.Fatalf("Must call Start before calling Report")
		return
	}
}

func (p *PerfTimer) Start() {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.startTS = time.Now()
	p.prevTS = p.startTS
	p.lastTS = p.startTS
}

func (p *PerfTimer) Seconds() float64 {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.checkStarted()
	now := time.Now()
	return now.Sub(p.startTS).Seconds()
}

func (p *PerfTimer) MarkInterval() {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.checkStarted()

	p.updated = false
	p.prevTS = p.lastTS
	p.lastTS = time.Now()

	p.prevOps = p.lastOps
	p.lastOps = p.totalOps
}

func (p *PerfTimer) Report(numOps int64) {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.checkStarted()
	p.totalOps += numOps
	p.updated = true
}

func (p *PerfTimer) TotalRate(fromNow bool) float64 {
	p.mu.Lock()
	defer p.mu.Unlock()

	if p.lastTS.IsZero() {
		return -1.0
	}

	var when time.Time
	if fromNow {
		when = time.Now()
	} else {
		when = p.lastTS
	}
	secs := (when.Sub(p.startTS)).Seconds()
	return float64(p.totalOps) / secs
}

func (p *PerfTimer) LastRate() float64 {
	p.mu.Lock()
	defer p.mu.Unlock()

	if p.lastTS.IsZero() || p.prevTS.IsZero() {
		return -1.0
	}

	secs := (p.lastTS.Sub(p.prevTS)).Seconds()
	return float64(p.lastOps-p.prevOps) / secs
}

func FloatArrayToString(values []float64) string {
	valsAsStr := make([]string, len(values))
	for x, v := range values {
		valsAsStr[x] = strconv.FormatFloat(v, 'f', 1, 64)
	}
	return strings.Join(valsAsStr, ", ")
}

func PerfWatcher(timers []*PerfTimer, updateDuration time.Duration, cancel chan bool) {
	rates := make([]float64, len(timers))

	for {
		time.Sleep(updateDuration)

		select {
		case <-cancel:
			tSum := 0.0
			for x, t := range timers {
				rates[x] = t.TotalRate(false)
				tSum += rates[x]
			}
			fmt.Printf("Final rate: %.1f total : totals per-timer= %s\n", tSum, FloatArrayToString(rates))
			cancel <- true
			return
		default:
		}

		iSum := 0.0
		tSum := 0.0
		for x, t := range timers {
			t.MarkInterval()
			rates[x] = t.LastRate()
			iSum += rates[x]
			tSum += t.TotalRate(false)
		}
		fmt.Printf("Rate: %.1f interval, %.1f total : intervals per-timer= %s\n", iSum, tSum, FloatArrayToString(rates))
	}
}
