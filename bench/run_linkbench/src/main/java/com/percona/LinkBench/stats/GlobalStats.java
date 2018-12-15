/*
 * Copyright 2012, Facebook, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.percona.LinkBench.stats;


import java.io.PrintStream;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Random;
import java.util.ArrayList;
import java.util.Properties;

import java.lang.Math;

import org.apache.log4j.Logger;

import com.facebook.LinkBench.ConfigUtil;
import com.facebook.LinkBench.Config;
import com.facebook.LinkBench.LinkBenchOp;
import com.facebook.LinkBench.LinkStore;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ArrayBlockingQueue;

import com.percona.LinkBench.stats.StatMessage;
import java.util.Collections;

import com.umbrant.quantile.QuantileEstimationGK;




/**
 * This class is used to keep track of statistics.  It collects a sample of the
 * total data (controlled by maxsamples) and can then compute statistics based
 * on that sample.
 *
 * The overall idea is to compute reasonably accurate statistics using bounded
 * space.
 *
 * Currently the class is used to print out stats at given intervals, with the
 * sample taken over a given time interval and printed at the end of the interval.
 */
public class GlobalStats implements Runnable  {

private class MinMaxStat {
	public long minValue = java.lang.Long.MAX_VALUE;
	public long maxValue = 0;
	public long count = 0;
   
    public MinMaxStat() {
	}

	public void AddStat(long v) {
		minValue = Math.min(v, minValue);	
		maxValue = Math.max(v, maxValue);
		count++;
	}

	public void Reset() {
		minValue = java.lang.Long.MAX_VALUE;
		maxValue = 0;
		count = 0;
	}
}

  private class LongArrayList extends ArrayList<Long>{}

// samples for various optypes
  private ArrayList<Long>[] samples;


  // quantile estimation for ADD_LINK op
  private QuantileEstimationGK qADDLINK;

  private MinMaxStat qSizeStat = new MinMaxStat();
  private MinMaxStat timeInQueueStat = new MinMaxStat();

  // Concurrency metrcis
  private MinMaxStat concStat = new MinMaxStat();
 
  private final Logger logger = Logger.getLogger(ConfigUtil.LINKBENCH_LOGGER);

  /** Stream to write csv output to ( null if no csv output ) */
  private final PrintStream csvOutput;

  /** Random number generator used to decide which to include in sample */
  private Random rng;

  /** this is mutex */
  private Object lockQueue = new Object();

  /** Queue we use to get messages from Request thread */
  private BlockingQueue<StatMessage> statsQueue;

  /** time period to print current results */
  long displayFreq_ms;

  /** initial timestamp when printer thread starts */
  long initTimestamp = 0;
  long prevTimestamp = 0;

  long opsFromStart = 0;

  Properties props;

  public GlobalStats(BlockingQueue<StatMessage> statsQ, Properties props, PrintStream csvOutput) {

    this.csvOutput = csvOutput;
    this.statsQueue = statsQ;
    this.props = props;

    /* create quantile estimation with 0.5% accuracy */
    qADDLINK = new QuantileEstimationGK(0.005, 500);

    samples = new LongArrayList[LinkStore.MAX_OPTYPES];
    for (LinkBenchOp type: LinkBenchOp.values()) {
      samples[type.ordinal()] = new LongArrayList();
    }

    rng = new Random();

    displayFreq_ms = ConfigUtil.getLong(props, Config.DISPLAY_FREQ, 60L) * 1000;

  }

  //public void addStats(LinkBenchOp type, long timetaken, boolean error, int conc) {
  public void addStats(StatMessage msg) {
	  synchronized(lockQueue) {

		  /* collect stats only for two operations, save memory and processing time*/
		  if ((msg.type == LinkBenchOp.ADD_LINK) || 
				(msg.type == LinkBenchOp.GET_LINKS_LIST)) {
			  samples[msg.type.ordinal()].add(msg.execTime);
		  }

		  if (msg.type == LinkBenchOp.ADD_LINK) {
			  qADDLINK.insert(msg.execTime);
		  }

		  concStat.AddStat(msg.concurrency);
		  qSizeStat.AddStat(msg.queueSize);
		  timeInQueueStat.AddStat(msg.timeInQueue_us);
	  }
  }

  /**
   * Write a header with column names for a csv file showing progress
   * @param out
   */
  public static void writeCSVHeader(PrintStream out) {
    out.println("timestamp,totalops,op,ops,concurrency,queue_size," +
            "max_us,p95_us,p99_us");
  }

  private void printStats() {

      long timestamp = System.currentTimeMillis() / 1000 - initTimestamp;

	  synchronized(lockQueue) {

		  long maxConc = concStat.maxValue;
		  long minConc = concStat.minValue;

		  logger.info("Events: " + concStat.count+ ", concurrency (min-max): "+minConc+"-"+maxConc+", throughput: "+
				concStat.count/(timestamp-prevTimestamp)+" ops/sec");
		  logger.info("Queue: size min-max: " + qSizeStat.minValue+"-"+qSizeStat.maxValue+
					", time min-max (us): " + timeInQueueStat.minValue + "-" +timeInQueueStat.maxValue);

		  opsFromStart += concStat.count;
		  concStat.Reset();

		  for (LinkBenchOp type: Arrays.asList(LinkBenchOp.ADD_LINK,LinkBenchOp.GET_LINKS_LIST)) {

			  Collections.sort(samples[type.ordinal()]);
			  long maxTime=0;
			  long tm95th = 0;
			  long tm99th = 0;
			  int sz = samples[type.ordinal()].size();
			  if (sz > 0 ) {
				  maxTime = samples[type.ordinal()].get(sz-1);
				  tm95th = samples[type.ordinal()].get(Math.max(sz*95/100,1)-1);
				  tm99th = samples[type.ordinal()].get(Math.max(sz*99/100,1)-1);
			  }
				  logger.info("Type: " + type.name() + 
						", count: " + samples[type.ordinal()].size()+
						", conc: "+maxConc+
						", qsize: "+qSizeStat.maxValue+
						", Time(us) max: "+maxTime+
						", 95th: "+ tm95th +
						", 99th: "+tm99th);

				  if (csvOutput != null) {
					  csvOutput.println(timestamp + 
							  "," + opsFromStart +
							  "," + type.name() +
							  "," + samples[type.ordinal()].size() + "," + maxConc +
							  "," + qSizeStat.maxValue +
							  "," + maxTime + "," + tm95th +
							  "," + tm99th);
				  }
			  samples[type.ordinal()].clear();

		  }
		  qSizeStat.Reset();
		  timeInQueueStat.Reset();
	  }
	  prevTimestamp = timestamp;

  }

  public void printQuantileStats() {

	  double[] quantiles = { 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99, 1.0 };
	  logger.info("Quantiles for ADD_LINK op:");
	  for (double q : quantiles) {
		  long estimate = qADDLINK.query(q);
		  logger.info("Quantile[" + q +"]="+estimate); 
	  }
	  logger.info("Quantiles size= "+qADDLINK.size()); 

  }

  @Override
  public void run() {
    logger.info("Global stats thread started");
    // logger.debug("Requester thread #" + requesterID + " first random number "
    //              + rng.nextLong());

    /* Start subthread that prints stats */ 
    Thread threadPrinter = new Thread("Printer Thread") {
	    public void run(){
			
			long t1 = 0;
			long t2 = 0;
			if (initTimestamp == 0) {
				initTimestamp = System.currentTimeMillis() / 1000;
				prevTimestamp = 0;
			}
		    try {	
			    while ( true ) {
					if (displayFreq_ms > (t2 - t1)) {
						// sleep only interval bigger than time correction
						Thread.sleep(displayFreq_ms-(t2-t1));
					}
					t1 = System.currentTimeMillis();
					printStats();
				    /* t2-t1 should contain time correction */
					t2 = System.currentTimeMillis();
					
			    }
		    } catch (InterruptedException e) {
				printStats();
				logger.info("Thread Interrupted");
		    }
	    }

    };

    threadPrinter.start();
    
	while ( true ) {
		// wait on incoming message
		try {
			StatMessage timeRequest = statsQueue.take();
			if (timeRequest == null ) {
				continue;
			}
			addStats(timeRequest);
			//logger.info("Received message: " + timeRequest.type.displayName() + ", time: " 
			// 		+ timeRequest.execTime);
		} catch (InterruptedException e) {
			logger.info("Thread Interrupted");
			break;
		}
	}
	threadPrinter.interrupt();
	try {
		threadPrinter.join();
	} catch (InterruptedException e) {
	}
  }

}

