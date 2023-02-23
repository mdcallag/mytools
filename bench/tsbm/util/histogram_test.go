package util

/*
  TODO
  * consider using binary search
*/

import (
	"strings"
	"testing"
)

func TestHistogramFail(t *testing.T) {
	if MakeHistogram(nil) != nil {
		t.Errorf("Make nil must return nil")
	}

	if MakeHistogram(make([]int64, 0)) != nil {
		t.Errorf("Make len 0 must return nil")
	}

	mv := []int64{-1}
	if MakeHistogram(mv) != nil {
		t.Errorf("bucket 0 must be >= 0")
	}

	mv = []int64{5, 10, 9}
	if MakeHistogram(mv) != nil {
		t.Errorf("bucket 2 must be > bucket 1")
	}

	mv = []int64{2, 10, 10}
	if MakeHistogram(mv) != nil {
		t.Errorf("bucket 2 must be > bucket 1")
	}
}

func TestHistogramOne(t *testing.T) {
	h := MakeHistogram([]int64{1})
	h.Add(0, true)
	h.Add(1, false)
	c := h.GetCounts()
	mv := h.GetMinValues()
	if len(c) != 2 || len(mv) != 1 {
		t.Errorf("Array lengths must be 2 and 1")
	}
	if c[0] != 2 {
		t.Errorf("Count should be 2, was %d", c[0])
	}
	if c[1] != 0 {
		t.Errorf("Count should be 0, was %d", c[0])
	}
	if mv[0] != 1 {
		t.Errorf("MinValue[0] should be 0, was %d", mv[0])
	}

	e := []string{"[1]=2", "[max]=0"}

	expect := strings.Join(e, "\n")
	summary := h.Summary(true)
	if summary != expect {
		t.Errorf("Summary(true) should be ::%s:: was ::%s::", expect, summary)
	}

	expect = strings.Join(e, ", ")
	summary = h.Summary(false)
	if summary != expect {
		t.Errorf("Summary(true) should be ::%s:: was ::%s::", expect, summary)
	}
}

func makeAndFill(minVals, responses []int64) *Histogram {
	h := MakeHistogram(minVals)
	for _, r := range responses {
		h.Add(r, false)
	}
	return h
}

func TestHistogramMany(t *testing.T) {
	minVals := []int64{256, 512, 1024}
	responses := []int64{0, 254, 255, 513, 1023, 1024, 1025}
	h := makeAndFill(minVals, responses)

	counts := []string{"[256]=3", "[512]=0", "[1024]=3", "[max]=1"}

	expect := strings.Join(counts, "\n")
	summary := h.Summary(true)
	if summary != expect {
		t.Errorf("Summary(true) should be ::%s:: was ::%s::", expect, summary)
	}

	expect = strings.Join(counts, ", ")
	summary = h.Summary(false)
	if summary != expect {
		t.Errorf("Summary(false) should be ::[0]=2:: was ::%s::", summary)
	}
}

func TestHistogramBadMerge(t *testing.T) {
	minVals1 := []int64{256, 512, 1024}
	responses1 := []int64{0, 254, 255, 512, 1023, 1024, 1025}
	h1 := makeAndFill(minVals1, responses1)

	minVals2 := []int64{256, 512, 1023}
	responses2 := []int64{0, 254, 255, 512, 1023, 1024, 1025}
	h2 := makeAndFill(minVals2, responses2)

	if h1.Merge(h2) {
		t.Errorf("Merge should fail, minValues not equal")
	}

	minVals3 := []int64{256, 512}
	responses3 := []int64{0, 254, 255, 512, 1023, 1024, 1025}
	h3 := makeAndFill(minVals3, responses3)

	if h1.Merge(h3) {
		t.Errorf("Merge should fail, minValues length not equal")
	}
}

func TestHistogramGoodMerge(t *testing.T) {
	minVals := []int64{256, 512, 1024, 2048}
	responses1 := []int64{0, 254, 255, 513, 1023, 1024, 1025}
	h1 := makeAndFill(minVals, responses1)
	if h1.Max(false) != 1025 {
		t.Errorf("Max: expected 1025, got %d", h1.Max(false))
	}

	responses2 := []int64{1, 256, 1027, 2049}
	h2 := makeAndFill(minVals, responses2)
	if h2.Max(false) != 2049 {
		t.Errorf("Max: expected 2049, got %d", h1.Max(false))
	}

	if !h1.Merge(h2) {
		t.Errorf("Merge should succeed")
	}
	if h1.Max(false) != 2049 {
		t.Errorf("Max: expected 2049, got %d", h1.Max(false))
	}

	expected := []int64{5, 0, 3, 2, 1}
	for x, c := range h1.count {
		if c != expected[x] {
			t.Errorf("Merge at %d expected %d, got %d", x, expected[x], h1.count[x])
		}
	}
}
