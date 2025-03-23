#!/usr/bin/env sysbench
-- Copyright (C) 2006-2017 Alexey Kopytov <akopytov@gmail.com>

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

-- ----------------------------------------------------------------------
-- Scans the table but filters all rows to avoid stressing client/server network
-- ----------------------------------------------------------------------

require("oltp_common")
require("os")

function prepare_statements()
   -- We do not use prepared statements here, but oltp_common.sh expects this
   -- function to be defined

   if sysbench.opt.explain_plans then
      explain_table("explain SELECT * from sbtest%d WHERE LENGTH(c) < 0", "for scan")
   end
end

function event()
   local table_num = (sysbench.tid % sysbench.opt.tables) + 1
   local table_name = "sbtest" .. table_num
   -- local start_secs = os.time()
   -- local stop_secs = start_secs

   -- while ((stop_secs - start_secs) < sysbench.opt.run_seconds) do
   check_reconnect()
   con:query(string.format("SELECT * from %s WHERE LENGTH(c) < 0", table_name))
   -- stop_secs = os.time()      
   -- end
end
