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
-- Delete-Only OLTP benchmark
-- ----------------------------------------------------------------------

require("oltp_common")

function prepare_statements()
   prepare_deletes()
end

function event()
   local tnum = sysbench.rand.uniform(1, sysbench.opt.tables)
   local id = sysbench.rand.default(1, sysbench.opt.table_size)

   param[tnum].deletes[1]:set(id)
   stmt[tnum].deletes:execute()

   check_reconnect()
end
