#!/bin/tclsh
# maintainer: Pooja Jain

puts "SETTING CONFIGURATION"
dbset db pg
dbset bm TPC-C

diset connection pg_host localhost
diset connection pg_port 5432
diset connection pg_sslmode prefer

set vu $::env(HAMMER_BUILD_VU)
puts "vu: $vu"

set warehouse $::env(HAMMER_WAREHOUSE)
puts "warehouse: $warehouse"

diset tpcc pg_count_ware $warehouse
diset tpcc pg_num_vu $vu
diset tpcc pg_superuser root
diset tpcc pg_superuserpass pw
diset tpcc pg_defaultdbase postgres
diset tpcc pg_user tpcc
diset tpcc pg_pass pw
diset tpcc pg_dbase tpcc
diset tpcc pg_tspace pg_default
diset tpcc pg_storedprocs true
if { $warehouse >= 200 } { 
diset tpcc pg_partition true 
	} else {
diset tpcc pg_partition false 
	}

puts "SCHEMA BUILD STARTED"
buildschema
puts "SCHEMA BUILD COMPLETED"

