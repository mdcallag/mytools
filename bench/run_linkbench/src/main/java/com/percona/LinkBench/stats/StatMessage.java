package com.percona.LinkBench.stats;

import com.facebook.LinkBench.LinkBenchOp;

/** Statistic message passed from Requester thread to GlobalStats */
public class StatMessage {
	public long execTime = 0;
	public int concurrency = 0;
	public LinkBenchOp type;
	public long timeInQueue_us; // time request spent in queue waiting 
	public long queueSize; // size of queue at the moment of the message

	public StatMessage(long eTime, int conc, LinkBenchOp optype, long timeInQueue_us, long queueSize) {
		execTime = eTime;
		concurrency = conc;
		type = optype;
		this.timeInQueue_us = timeInQueue_us;
		this.queueSize = queueSize;
	}
}
