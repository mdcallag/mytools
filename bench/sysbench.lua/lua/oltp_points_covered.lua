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

   local points = string.rep("?, ", sysbench.opt.random_points - 1) .. "?"

   local sql_prefix = ""

   for t = 1, sysbench.opt.tables do
      if sysbench.opt.on_id then
         if sysbench.opt.covered then
            stmt[t] = con:prepare(string.format([[
               SELECT id FROM sbtest%d WHERE id IN (%s) ]], t, points))
            sql_prefix = "explain SELECT id FROM sbtest%d WHERE id IN "
	 else
            stmt[t] = con:prepare(string.format([[
               SELECT id, c FROM sbtest%d WHERE id IN (%s) ]], t, points))
            sql_prefix = "explain SELECT id, c FROM sbtest%d WHERE id IN "
         end
      else
         if sysbench.opt.covered then
            stmt[t] = con:prepare(string.format([[
               SELECT k FROM sbtest%d WHERE k IN (%s) ]], t, points))
	    sql_prefix = "explain SELECT k FROM sbtest%d WHERE k IN "
	 else
            stmt[t] = con:prepare(string.format([[
               SELECT k, c FROM sbtest%d WHERE k IN (%s) ]], t, points))
	    sql_prefix = "explain SELECT k, c FROM sbtest%d WHERE k IN "
         end
      end

      for j = 1, sysbench.opt.random_points do
         params[t][j] = stmt[t]:bind_create(sysbench.sql.type.INT)
      end

      stmt[t]:bind_param(unpack(params[t]))
   end

   if sysbench.opt.explain_plans then
      local inlist = "( " .. get_id()
      for x = 2, sysbench.opt.random_points do
         inlist = inlist .. ", " .. get_id()
      end
      inlist = inlist .. ")"

      explain_table(sql_prefix .. inlist, "for points-covered")
   end

   log_id_if_pgsql()
end

function thread_done()
   for t = 1, sysbench.opt.tables do
      stmt[t]:close()
   end
   con:disconnect()
end

function event()
   local tnum = sysbench.rand.uniform(1, sysbench.opt.tables)

   for i = 1, sysbench.opt.random_points do
      params[tnum][i]:set(sysbench.rand.default(1, sysbench.opt.table_size))
   end

   stmt[tnum]:execute()
end
