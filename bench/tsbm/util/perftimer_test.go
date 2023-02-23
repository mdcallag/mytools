package util

import (
	"fmt"
	"testing"
	"time"
)

func TestPerfTimer(t *testing.T) {
	p := &PerfTimer{}
	p.Start()

	time.Sleep(100 * time.Millisecond)
	p.Report(10)
	p.MarkInterval()
	lr1 := p.LastRate()
	if lr1 < 50.0 || lr1 > 200.0 {
		t.Errorf("LastRate should be ~100 but was %f", lr1)
	}

	time.Sleep(100 * time.Millisecond)
	p.Report(100)
	p.MarkInterval()
	lr2 := p.LastRate()
	if lr2 < 500.0 || lr2 > 2000.0 {
		t.Errorf("LastRate should be ~2000 but was %f", lr2)
	}
	p.MarkInterval()
	lr3 := p.LastRate()
	if lr3 != 0.0 {
		t.Errorf("LastRate should be zero, was %f", lr3)
	}

	tr1 := p.TotalRate(true)
	if tr1 < 250.0 || tr1 > 1100.0 {
		t.Errorf("TotalRate should be ~550 but was %f", tr1)
	}

	tr2 := p.TotalRate(true)
	if tr2 < 250.0 || tr2 > 1100.0 {
		t.Errorf("TotalRate should be ~550 but was %f", tr2)
	}

	secs := p.Seconds()
	if secs < 0.1 || secs > 1.0 {
		t.Errorf("Seconds was %f but should be ~0.2", secs)
	}

	fmt.Printf("Rates were: %f\t%f\t%f\t%f\n", lr1, lr2, tr1, tr2)
}
