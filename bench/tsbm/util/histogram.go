package util

/*
  TODO
  * consider using binary search
*/

import (
	"fmt"
	"log"
	"strings"
	"sync"
)

type Histogram struct {
	mu       sync.Mutex
	count    []int64
	minValue []int64
	max      int64
}

func MakeHistogram(minValues []int64) *Histogram {
	if len(minValues) == 0 {
		log.Printf("MakeHistogram: len(minValues) must be > 0")
		return nil
	}

	h := Histogram{}

	for x, v := range minValues {
		if v < 0 {
			log.Printf("MakeHistogram: minValues[0] must be >= 0")
			return nil
		}
		if x > 0 && v <= minValues[x-1] {
			log.Printf("MakeHistogram: minValues[%d]=%d must be larger than minValues[%d]=%d", x, minValues[x], x-1, minValues[x-1])
			return nil
		}
	}

	h.count = make([]int64, len(minValues)+1)
	h.minValue = minValues
	return &h
}

func (h *Histogram) Add(value int64, useMutex bool) bool {
	if value < 0 {
		log.Printf("Histogram.Add called with negative value")
		return false
	}

	if value > h.max {
		h.max = value
	}

	for x := 0; x < len(h.minValue); x++ {
		if value <= h.minValue[x] {
			if useMutex {
				h.mu.Lock()
				defer h.mu.Unlock()
			}
			h.count[x]++
			return true
		}
	}

	if useMutex {
		h.mu.Lock()
		defer h.mu.Unlock()
	}
	h.count[len(h.minValue)]++
	return true
}

func (h *Histogram) GetCounts() []int64 {
	h.mu.Lock()
	defer h.mu.Unlock()
	return h.count
}

func (h *Histogram) GetMinValues() []int64 {
	h.mu.Lock()
	defer h.mu.Unlock()
	return h.minValue
}

func (h *Histogram) Max(useMutex bool) int64 {
	if useMutex {
		h.mu.Lock()
		defer h.mu.Unlock()
	}
	return h.max
}

func (h *Histogram) Summary(onePerLine bool) string {
	h.mu.Lock()
	defer h.mu.Unlock()

	summary := make([]string, len(h.count))

	for x, v := range h.minValue {
		summary[x] = fmt.Sprintf("[%d]=%d", v, h.count[x])
	}
	summary[len(h.minValue)] = fmt.Sprintf("[max]=%d", h.count[len(h.minValue)])

	if onePerLine {
		return strings.Join(summary, "\n")
	} else {
		return strings.Join(summary, ", ")
	}
}

func (h *Histogram) Merge(from *Histogram) bool {
	if len(h.count) != len(from.count) {
		log.Printf("Can't merge: lengths not equal: %d vs %d", len(h.count), len(from.count))
		return false
	}
	for x, v := range h.minValue {
		if v != from.minValue[x] {
			log.Printf("Can't merge: minValue not equal at index %d: %d vs %d", x, v, from.minValue[x])
			return false
		}
		h.count[x] += from.count[x]
	}
	h.count[len(h.minValue)] += from.count[len(h.minValue)]

	if from.max > h.max {
		h.max = from.max
	}
	return true
}
