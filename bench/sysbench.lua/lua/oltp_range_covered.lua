#!/usr/bin/env sysbench
-- This test is designed for testing MariaDB's key_cache_segments for MyISAM,
-- and should work with other storage engines as well.
--
-- For details about key_cache_segments please refer to:
-- http://kb.askmonty.org/v/segmented-key-cache
--

require("oltp_common")

-- Test specific options
sysbench.cmdline.options.random_points =
   {"Number of random points in the IN() clause in generated SELECTs", 10}
sysbench.cmdline.options.on_id =
   {"If true then use id column, otherwise use k column", true}
sysbench.cmdline.options.covered =
   {"If true then limit query to indexed columns", true}

function thread_init()
   drv = sysbench.sql.driver()
   con = drv:connect()

   stmt = {}
   params = {}

   for t = 1, sysbench.opt.tables do
      stmt[t] = {}
      params[t] = {}
   end
   
   for t = 1, sysbench.opt.tables do
      if sysbench.opt.on_id then
         if sysbench.opt.covered then
            stmt[t] = con:prepare(string.format([[
               SELECT id FROM sbtest%d WHERE id BETWEEN ? AND ? ]], t))
	 else
            stmt[t] = con:prepare(string.format([[
               SELECT id, c FROM sbtest%d WHERE id BETWEEN ? AND ? ]], t))
         end
      else
         if sysbench.opt.covered then
            stmt[t] = con:prepare(string.format([[
               SELECT k FROM sbtest%d WHERE k BETWEEN ? AND ? ]], t))
	 else
            stmt[t] = con:prepare(string.format([[
               SELECT k, c FROM sbtest%d WHERE k BETWEEN ? AND ? ]], t))
         end
      end

      params[t][1] = stmt[t]:bind_create(sysbench.sql.type.INT)
      params[t][2] = stmt[t]:bind_create(sysbench.sql.type.INT)
      stmt[t]:bind_param(unpack(params[t]))
   end
end

function thread_done()
   for t = 1, sysbench.opt.tables do
      stmt[t]:close()
   end
   con:disconnect()
end

function event()
   local tnum = sysbench.rand.uniform(1, sysbench.opt.tables)
   local min_id = sysbench.rand.default(1, sysbench.opt.table_size)

   params[tnum][1]:set(min_id)
   params[tnum][2]:set(min_id + sysbench.opt.random_points)

   stmt[tnum]:execute()
end

