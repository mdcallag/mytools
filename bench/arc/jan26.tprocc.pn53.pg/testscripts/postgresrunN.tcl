#set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db pg
dbset bm TPC-C

set vu_in $::env(HAMMER_RUN_VU)
puts "vu to use: $vu_in"

set vuList [split $vu_in ","]
foreach entry $vuList {
  puts "vu: $entry"
}

set warehouse $::env(HAMMER_WAREHOUSE)
puts "warehouse: $warehouse"

set rampup $::env(HAMMER_RAMPUP)
puts "rampup: $rampup"

set duration $::env(HAMMER_DURATION)
puts "duration: $duration"

jobs profileid 0
giset commandline keepalive_margin 1200
giset timeprofile xt_gather_timeout 1200

diset connection pg_host localhost
diset connection pg_port 5432
diset connection pg_sslmode prefer

diset tpcc pg_superuser root
diset tpcc pg_superuserpass pw
diset tpcc pg_defaultdbase postgres
diset tpcc pg_user tpcc
diset tpcc pg_pass pw
diset tpcc pg_dbase tpcc
diset tpcc pg_driver timed
diset tpcc pg_total_iterations 10000000
diset tpcc pg_rampup $rampup
diset tpcc pg_duration $duration
diset tpcc pg_vacuum true
diset tpcc pg_storedprocs true
diset tpcc pg_timeprofile false
diset tpcc pg_allwarehouse true
puts "TEST STARTED"
foreach z $vuList {
puts "run for VU $z"
loadscript
vuset vu $z
vuset logtotemp 1
vucreate
tcstart
tcstatus
vurun
tcstop
vudestroy
}
puts "TEST COMPLETE"
