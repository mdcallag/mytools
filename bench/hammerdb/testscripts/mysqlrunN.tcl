#set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db mysql
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
 
diset connection mysql_host 127.0.0.1
diset connection mysql_port 3306
diset connection mysql_socket $::env(HAMMER_MYSOCK)
#
diset tpcc mysql_user root
diset tpcc mysql_pass pw
diset tpcc mysql_dbase tpcc
diset tpcc mysql_driver timed
diset tpcc mysql_rampup $rampup
diset tpcc mysql_duration $duration
diset tpcc mysql_allwarehouse true
diset tpcc mysql_timeprofile true
diset tpcc mysql_no_stored_procs false
puts "TEST STARTED"
foreach z $vuList {
puts "run for VU $z"
loadscript
vuset vu $z
vuset logtotemp 1
vucreate
metstart
tcstart
tcstatus
vurun
tcstop
metstop
vudestroy
}
puts "TEST COMPLETE"
