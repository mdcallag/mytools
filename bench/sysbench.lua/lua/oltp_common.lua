-- Copyright (C) 2006-2018 Alexey Kopytov <akopytov@gmail.com>

-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

-- -----------------------------------------------------------------------------
-- Common code for OLTP benchmarks.
-- -----------------------------------------------------------------------------

function init()
   assert(event ~= nil,
          "this script is meant to be included by other OLTP scripts and " ..
             "should not be called directly.")
end

if sysbench.cmdline.command == nil then
   error("Command is required. Supported commands: prepare, warmup, run, " ..
            "cleanup, help")
end

-- Command line options
sysbench.cmdline.options = {
   explain_plans =
     {"Explain query plans", true},
   table_size =
      {"Number of rows per table", 10000},
   range_size =
      {"Range size for range SELECT queries", 100},
   tables =
      {"Number of tables", 1},
   point_selects =
      {"Number of point SELECT queries per transaction", 10},
   simple_ranges =
      {"Number of simple range SELECT queries per transaction", 1},
   sum_ranges =
      {"Number of SELECT SUM() queries per transaction", 1},
   order_ranges =
      {"Number of SELECT ORDER BY queries per transaction", 1},
   distinct_ranges =
      {"Number of SELECT DISTINCT queries per transaction", 1},
   count_ranges =
      {"Number of SELECT COUNT queries per transaction", 1},
   index_updates =
      {"Number of UPDATE index queries per transaction", 1},
   non_index_updates =
      {"Number of UPDATE non-index queries per transaction", 1},
   delete_inserts =
      {"Number of DELETE/INSERT combinations per transaction", 1},
   range_selects =
      {"Enable/disable all range SELECT queries", true},
   auto_inc =
   {"Use AUTO_INCREMENT column as Primary Key (for MySQL), " ..
       "or its alternatives in other DBMS. When disabled, use " ..
       "client-generated IDs", true},
   create_table_options =
      {"Extra CREATE TABLE options", ""},
   skip_trx =
      {"Don't start explicit transactions and execute all queries " ..
          "in the AUTOCOMMIT mode", false},
   secondary =
      {"Use a secondary index in place of the PRIMARY KEY", false},
   create_secondary =
      {"Create a secondary index in addition to the PRIMARY KEY", true},
   reconnect =
      {"Reconnect after every N events. The default (0) is to not reconnect",
       0},
   mysql_storage_engine =
      {"Storage engine, if MySQL is used", "innodb"},
   pgsql_conn_id =
     { "Write the Postgres backend process ID for this connection  " ..
          "into a file named o.pgid.$threadID", false },
   pgsql_variant =
      {"Use this PostgreSQL variant when running with the " ..
          "PostgreSQL driver. The only currently supported " ..
          "variant is 'redshift'. When enabled, " ..
          "create_secondary is automatically disabled, and " ..
          "delete_inserts is set to 0"}
}

-- Prepare the dataset. This command supports parallel execution, i.e. will
-- benefit from executing with --threads > 1 as long as --tables > 1
function cmd_prepare()
   local drv = sysbench.sql.driver()
   local con = drv:connect()

   for i = sysbench.tid % sysbench.opt.threads + 1, sysbench.opt.tables,
   sysbench.opt.threads do
     create_table(drv, con, i)
   end
end

-- Preload the dataset into the server cache. This command supports parallel
-- execution, i.e. will benefit from executing with --threads > 1 as long as
-- --tables > 1
--
-- PS. Currently, this command is only meaningful for MySQL/InnoDB benchmarks
function cmd_warmup()
   local drv = sysbench.sql.driver()
   local con = drv:connect()

   assert(drv:name() == "mysql", "warmup is currently MySQL only")

   -- Do not create on disk tables for subsequent queries
   con:query("SET tmp_table_size=2*1024*1024*1024")
   con:query("SET max_heap_table_size=2*1024*1024*1024")

   for i = sysbench.tid % sysbench.opt.threads + 1, sysbench.opt.tables,
   sysbench.opt.threads do
      local t = "sbtest" .. i
      print("Preloading table " .. t)
      con:query("ANALYZE TABLE sbtest" .. i)
      con:query(string.format(
                   "SELECT AVG(id) FROM " ..
                      "(SELECT * FROM %s FORCE KEY (PRIMARY) " ..
                      "LIMIT %u) t",
                   t, sysbench.opt.table_size))
      con:query(string.format(
                   "SELECT COUNT(*) FROM " ..
                      "(SELECT * FROM %s WHERE k LIKE '%%0%%' LIMIT %u) t",
                   t, sysbench.opt.table_size))
   end
end

-- Implement parallel prepare and warmup commands, define 'prewarm' as an alias
-- for 'warmup'
sysbench.cmdline.commands = {
   prepare = {cmd_prepare, sysbench.cmdline.PARALLEL_COMMAND},
   warmup = {cmd_warmup, sysbench.cmdline.PARALLEL_COMMAND},
   prewarm = {cmd_warmup, sysbench.cmdline.PARALLEL_COMMAND}
}


-- Template strings of random digits with 11-digit groups separated by dashes

-- 10 groups, 119 characters
local c_value_template = "###########-###########-###########-" ..
   "###########-###########-###########-" ..
   "###########-###########-###########-" ..
   "###########"

-- 5 groups, 59 characters
local pad_value_template = "###########-###########-###########-" ..
   "###########-###########"

function get_c_value()
   return sysbench.rand.string(c_value_template)
end

function get_pad_value()
   return sysbench.rand.string(pad_value_template)
end

function create_table(drv, con, table_num)
   local id_def
   local engine_def = ""
   local extra_table_options = ""
   local query

   if drv:name() == "mysql"
   then
      if sysbench.opt.auto_inc then
         id_def = "INTEGER NOT NULL AUTO_INCREMENT"
      else
         id_def = "INTEGER NOT NULL"
      end
      engine_def = "/*! ENGINE = " .. sysbench.opt.mysql_storage_engine .. " */"

      print(string.format("Creating table 'sbtest%d'...", table_num))

      if not sysbench.opt.secondary then
        query = string.format([[
CREATE TABLE sbtest%d(
  id %s,
  k INTEGER DEFAULT '0' NOT NULL,
  c CHAR(120) DEFAULT '' NOT NULL,
  pad CHAR(60) DEFAULT '' NOT NULL,
  PRIMARY KEY (id)
) %s %s]],
          table_num, id_def, engine_def, sysbench.opt.create_table_options)
        con:query(query)
      else
        query = string.format([[
CREATE TABLE sbtest%d(
  id %s,
  k INTEGER DEFAULT '0' NOT NULL,
  c CHAR(120) DEFAULT '' NOT NULL,
  pad CHAR(60) DEFAULT '' NOT NULL,
  KEY (id)
) %s %s]],
          table_num, id_def, engine_def, sysbench.opt.create_table_options)
        con:query(query)
      end

   elseif drv:name() == "pgsql"
   then
      if not sysbench.opt.auto_inc then
         id_def = "INTEGER NOT NULL"
      elseif pgsql_variant == 'redshift' then
        id_def = "INTEGER IDENTITY(1,1)"
      else
        id_def = "SERIAL"
      end

      print(string.format("Creating table 'sbtest%d'...", table_num))

      if not sysbench.opt.secondary then
        query = string.format([[
CREATE TABLE sbtest%d(
  id %s,
  k INTEGER DEFAULT '0' NOT NULL,
  c CHAR(120) DEFAULT '' NOT NULL,
  pad CHAR(60) DEFAULT '' NOT NULL,
  PRIMARY KEY (id)
) %s %s]],
          table_num, id_def, engine_def, sysbench.opt.create_table_options)
        con:query(query)
      else
        query = string.format([[
CREATE TABLE sbtest%d(
  id %s,
  k INTEGER DEFAULT '0' NOT NULL,
  c CHAR(120) DEFAULT '' NOT NULL,
  pad CHAR(60) DEFAULT '' NOT NULL
) %s %s]],
          table_num, id_def, engine_def, sysbench.opt.create_table_options)
        con:query(query)

        print(string.format("Creating index for 'sbtest%d'...", table_num))
        query = string.format([[CREATE INDEX xid%d on sbtest%d(id)]],
          table_num, table_num)
        con:query(query)
      end

   else
      error("Unsupported database driver:" .. drv:name())
   end

   if (sysbench.opt.table_size > 0) then
      print(string.format("Inserting %d records into 'sbtest%d'",
                          sysbench.opt.table_size, table_num))
   end

   if sysbench.opt.auto_inc then
      query = "INSERT INTO sbtest" .. table_num .. "(k, c, pad) VALUES"
   else
      query = "INSERT INTO sbtest" .. table_num .. "(id, k, c, pad) VALUES"
   end

   con:bulk_insert_init(query)

   local c_val
   local pad_val

   load_start = os.time()
   for i = 1, sysbench.opt.table_size do

      c_val = get_c_value()
      pad_val = get_pad_value()

      if (sysbench.opt.auto_inc) then
         query = string.format("(%d, '%s', '%s')",
                               sysbench.rand.default(1, sysbench.opt.table_size),
                               c_val, pad_val)
      else
         query = string.format("(%d, %d, '%s', '%s')",
                               i,
                               sysbench.rand.default(1, sysbench.opt.table_size),
                               c_val, pad_val)
      end

      con:bulk_insert_next(query)
   end
   load_finish = os.time()

   con:bulk_insert_done()

   index_start = os.time()
   if sysbench.opt.create_secondary then
      print(string.format("Creating a secondary index on 'sbtest%d'...",
                          table_num))
      con:query(string.format("CREATE INDEX k_%d ON sbtest%d(k)",
                              table_num, table_num))
   end
   index_finish = os.time()
   print(string.format("Seconds for: %d load, %d index",
                       load_finish - load_start,
                       index_finish - index_start))
end

local t = sysbench.sql.type
local stmt_defs = {
   point_selects = {
      "SELECT c FROM sbtest%u WHERE id=?",
      t.INT},
   simple_ranges = {
      "SELECT c FROM sbtest%u WHERE id BETWEEN ? AND ?",
      t.INT, t.INT},
   sum_ranges = {
      "SELECT SUM(k) FROM sbtest%u WHERE id BETWEEN ? AND ?",
       t.INT, t.INT},
   order_ranges = {
      "SELECT c FROM sbtest%u WHERE id BETWEEN ? AND ? ORDER BY c",
       t.INT, t.INT},
   distinct_ranges = {
      "SELECT DISTINCT c FROM sbtest%u WHERE id BETWEEN ? AND ? ORDER BY c",
      t.INT, t.INT},
   count_ranges = {
      "SELECT count(c) FROM sbtest%u WHERE id BETWEEN ? AND ?",
      t.INT, t.INT},
   index_updates = {
      "UPDATE sbtest%u SET k=k+1 WHERE id=?",
      t.INT},
   non_index_updates = {
      "UPDATE sbtest%u SET c=? WHERE id=?",
      {t.CHAR, 120}, t.INT},
   deletes = {
      "DELETE FROM sbtest%u WHERE id=?",
      t.INT},
   inserts = {
      "INSERT INTO sbtest%u (id, k, c, pad) VALUES (?, ?, ?, ?)",
      t.INT, t.INT, {t.CHAR, 120}, {t.CHAR, 60}},
}

function prepare_begin()
   stmt.begin = con:prepare("BEGIN")
end

function prepare_commit()
   stmt.commit = con:prepare("COMMIT")
end

function prepare_for_each_table(key)
   for t = 1, sysbench.opt.tables do
      stmt[t][key] = con:prepare(string.format(stmt_defs[key][1], t))

      local nparam = #stmt_defs[key] - 1

      if nparam > 0 then
         param[t][key] = {}
      end

      for p = 1, nparam do
         local btype = stmt_defs[key][p+1]
         local len

         if type(btype) == "table" then
            len = btype[2]
            btype = btype[1]
         end
         if btype == sysbench.sql.type.VARCHAR or
            btype == sysbench.sql.type.CHAR then
               param[t][key][p] = stmt[t][key]:bind_create(btype, len)
         else
            param[t][key][p] = stmt[t][key]:bind_create(btype)
         end
      end

      if nparam > 0 then
         stmt[t][key]:bind_param(unpack(param[t][key]))
      end
   end
end

local explain_table_id
local explain_ranges
local explain_me

function prepare_point_selects()
   prepare_for_each_table("point_selects")
   if sysbench.opt.explain_plans then
      explain_table_id("explain SELECT c FROM sbtest%u WHERE id=%u", "for point_selects")
   end
end

function prepare_simple_ranges()
   prepare_for_each_table("simple_ranges")
   if sysbench.opt.explain_plans then
      explain_ranges("simple_ranges", "explain SELECT c FROM sbtest%u WHERE id BETWEEN %u AND %u")
   end
end
      
function prepare_sum_ranges()
   prepare_for_each_table("sum_ranges")
   if sysbench.opt.explain_plans then
      explain_ranges("sum_ranges", "explain SELECT SUM(k) FROM sbtest%u WHERE id BETWEEN %u AND %u")
   end
end

function prepare_order_ranges()
   prepare_for_each_table("order_ranges")
   if sysbench.opt.explain_plans then
      explain_ranges("order_ranges", "explain SELECT c FROM sbtest%u WHERE id BETWEEN %u AND %u ORDER BY c")
   end
end

function prepare_distinct_ranges()
   prepare_for_each_table("distinct_ranges")
   if sysbench.opt.explain_plans then
      explain_ranges("distinct_ranges", "explain SELECT DISTINCT c FROM sbtest%u WHERE id BETWEEN %u AND %u ORDER BY c")
   end
end

function prepare_count_ranges()
   prepare_for_each_table("count_ranges")
   if sysbench.opt.explain_plans then
      explain_ranges("count_ranges", "explain SELECT count(c) FROM sbtest%u WHERE id BETWEEN %u AND %u")
   end
end

function prepare_index_updates()
   prepare_for_each_table("index_updates")
   if sysbench.opt.explain_plans then
      explain_table_id("explain UPDATE sbtest%u SET k=k+1 WHERE id=%u", "for index_updates")
   end
end

function prepare_non_index_updates()
   prepare_for_each_table("non_index_updates")
   if sysbench.opt.explain_plans then
      explain_table_id("explain UPDATE sbtest%u SET c='foobar' WHERE id=%u", "for non_index_updates")
   end
end

function prepare_deletes()
   prepare_for_each_table("deletes")
   if sysbench.opt.explain_plans then
      explain_table_id("explain DELETE FROM sbtest%u WHERE id=%u", "for deletes")
   end
end

function prepare_inserts()
   prepare_for_each_table("inserts")
   if sysbench.opt.explain_plans then
      explain_table_id("explain INSERT INTO sbtest%u (id, k, c, pad) VALUES (%u, 13, 'foobar', 'foobar')", "for inserts")
   end
end

function log_id_if_pgsql()
   if sysbench.opt.pgsql_conn_id then
      thread_id = sysbench.tid % sysbench.opt.threads
      pgid = con:query_row("select pg_backend_pid()")
      f = io.open("sb.pgid." .. thread_id, "w")
      f:write("PG_backend: " .. pgid)
      f:close()
   end
end

function thread_init()
   drv = sysbench.sql.driver()
   con = drv:connect()

   -- Create global nested tables for prepared statements and their
   -- parameters. We need a statement and a parameter set for each combination
   -- of connection/table/query
   stmt = {}
   param = {}

   for t = 1, sysbench.opt.tables do
      stmt[t] = {}
      param[t] = {}
   end

   -- This function is a 'callback' defined by individual benchmark scripts
   prepare_statements()

   log_id_if_pgsql()
end

-- Close prepared statements
function close_statements()
   for t = 1, sysbench.opt.tables do
      for k, s in pairs(stmt[t]) do
         stmt[t][k]:close()
      end
   end
   if (stmt.begin ~= nil) then
      stmt.begin:close()
   end
   if (stmt.commit ~= nil) then
      stmt.commit:close()
   end
end

function thread_done()
   close_statements()
   con:disconnect()
end

function cleanup()
   local drv = sysbench.sql.driver()
   local con = drv:connect()

   for i = 1, sysbench.opt.tables do
      print(string.format("Dropping table 'sbtest%d'...", i))
      con:query("DROP TABLE IF EXISTS sbtest" .. i )
   end
end

local function get_table_num()
   return sysbench.rand.uniform(1, sysbench.opt.tables)
end

function get_id()
   return sysbench.rand.default(1, sysbench.opt.table_size)
end

function begin()
   stmt.begin:execute()
end

function commit()
   stmt.commit:execute()
end

function explain_me(sql_post)
   msg = ""
   rs = con:query(sql_post)
   for i = 1, rs.nrows do
      row = rs:fetch_row()
      nfields = 0
      for i, v in pairs(row) do
         nfields = nfields + 1
      end
      for x = 1, nfields do
	 local v = "null"
	 if row[x] ~= nil then
            v = row[x]
         end 
         msg = msg .. "\t" .. v
      end
      msg = msg .. "\n"
   end
   -- msg = msg .. "\n"
   return msg
end

function explain_table(sql_pre, source)
   local t

   print("explain: " .. source .. " :: " .. sql_pre)
   local msg = source
   for t = 1, sysbench.opt.tables do
      local sql_post = string.format(sql_pre, t)
      msg = msg .. "\ntable " .. t .. " : " .. sql_post .. "\n"
      msg = msg .. explain_me(sql_post)
   end
   print(msg)
end

function explain_table_id(sql_pre, source)
   local t

   print("explain: " .. source .. " :: " .. sql_pre)
   local msg = source
   for t = 1, sysbench.opt.tables do
      local sql_post = string.format(sql_pre, t, get_id())
      msg = msg .. "\ntable " .. t .. " : " .. sql_post .. "\n"
      msg = msg .. explain_me(sql_post)
   end
   print(msg)
end

function explain_ranges(source, sql_pre)
   local t

   local msg = "for: " .. source
   for t = 1, sysbench.opt.tables do
      local id = get_id()
      local sql_post = string.format(sql_pre, t, id, id + sysbench.opt.range_size - 1)
      msg = msg .. "\ntable " .. t .. " : " .. sql_post .. "\n"
      msg = msg .. explain_me(sql_post)
   end
   print(msg)
end

function execute_point_selects()
   local tnum = get_table_num()
   local i

   for i = 1, sysbench.opt.point_selects do
      param[tnum].point_selects[1]:set(get_id())

      stmt[tnum].point_selects:execute()
   end
end

local function execute_range(key)
   local tnum = get_table_num()

   for i = 1, sysbench.opt[key] do
      local id = get_id()

      param[tnum][key][1]:set(id)
      param[tnum][key][2]:set(id + sysbench.opt.range_size - 1)

      stmt[tnum][key]:execute()
   end
end

function execute_simple_ranges()
   execute_range("simple_ranges")
end

function execute_sum_ranges()
   execute_range("sum_ranges")
end

function execute_order_ranges()
   execute_range("order_ranges")
end

function execute_distinct_ranges()
   execute_range("distinct_ranges")
end

function execute_count_ranges()
   execute_range("count_ranges")
end

function execute_index_updates()
   local tnum = get_table_num()

   for i = 1, sysbench.opt.index_updates do
      param[tnum].index_updates[1]:set(get_id())

      stmt[tnum].index_updates:execute()
   end
end

function execute_non_index_updates()
   local tnum = get_table_num()

   for i = 1, sysbench.opt.non_index_updates do
      param[tnum].non_index_updates[1]:set_rand_str(c_value_template)
      param[tnum].non_index_updates[2]:set(get_id())

      stmt[tnum].non_index_updates:execute()
   end
end

function execute_delete_inserts()
   local tnum = get_table_num()

   for i = 1, sysbench.opt.delete_inserts do
      local id = get_id()
      local k = get_id()

      param[tnum].deletes[1]:set(id)

      param[tnum].inserts[1]:set(id)
      param[tnum].inserts[2]:set(k)
      param[tnum].inserts[3]:set_rand_str(c_value_template)
      param[tnum].inserts[4]:set_rand_str(pad_value_template)

      stmt[tnum].deletes:execute()
      stmt[tnum].inserts:execute()
   end
end

-- Re-prepare statements if we have reconnected, which is possible when some of
-- the listed error codes are in the --mysql-ignore-errors list
function sysbench.hooks.before_restart_event(errdesc)
   if errdesc.sql_errno == 2013 or -- CR_SERVER_LOST
      errdesc.sql_errno == 2055 or -- CR_SERVER_LOST_EXTENDED
      errdesc.sql_errno == 2006 or -- CR_SERVER_GONE_ERROR
      errdesc.sql_errno == 2011    -- CR_TCP_CONNECTION
   then
      close_statements()
      prepare_statements()
   end
end

function check_reconnect()
   if sysbench.opt.reconnect > 0 then
      transactions = (transactions or 0) + 1
      if transactions % sysbench.opt.reconnect == 0 then
         close_statements()
         con:reconnect()
         prepare_statements()
      end
   end
end
