package datagen

import (
	"fmt"
	"testing"
)

func tloop(t *testing.T, nMeasures int, nMetrics int) int {
	chans := MakeSeqGenerator(1, nMetrics, nMeasures)
        x := 0
	for m := range chans.Data {
		fmt.Println(m)
		if len(m.Metrics) != nMetrics {
			t.Errorf("Expected %d metrics, got %d\n", nMetrics, len(m.Metrics))			
		}
		x++
	}
	return x
}

func TestLoop1(t *testing.T) {
        nMeasures := 1
	nMetrics := 3
	if got := tloop(t, nMeasures, nMetrics); got != nMeasures {
		t.Errorf("Expected %d, got %d\n", nMeasures, got)
	}
}

func TestLoop9(t *testing.T) {
        nMeasures := 9
	nMetrics := 1
	if got := tloop(t, nMeasures, nMetrics); got != nMeasures {
		t.Errorf("Expected %d, got %d\n", nMeasures, got)
	}
}

func TestLoop10(t *testing.T) {
        nMeasures := 10
	nMetrics := 2
	if got := tloop(t, nMeasures, nMetrics); got != nMeasures {
		t.Errorf("Expected %d, got %d\n", nMeasures, got)
	}
}

func TestLoop11(t *testing.T) {
        nMeasures := 11
	nMetrics := 4
	if got := tloop(t, nMeasures, nMetrics); got != nMeasures {
		t.Errorf("Expected %d, got %d\n", nMeasures, got)
	}
}
