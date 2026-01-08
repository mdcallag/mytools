#set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db maria
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
 
diset connection maria_host 127.0.0.1
diset connection maria_port 3306
diset connection maria_socket /tmp/mysql.sock
#
diset tpcc maria_user root
diset tpcc maria_pass pw
diset tpcc maria_dbase tpcc
diset tpcc maria_driver timed
diset tpcc maria_rampup $rampup
diset tpcc maria_duration $duration
diset tpcc maria_no_stored_procs false
diset tpcc maria_allwarehouse true
diset tpcc maria_timeprofile true
diset tpcc maria_purge true
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
