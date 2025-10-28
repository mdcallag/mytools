set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db maria
dbset bm TPC-C
 
jobs profileid 6
giset commandline keepalive_margin 1200
giset timeprofile xt_gather_timeout 1200
 
diset connection maria_host 127.0.0.1
diset connection maria_port 3306
diset connection maria_socket /tmp/mariadb.sock
#
diset tpcc maria_user root
diset tpcc maria_pass maria
diset tpcc maria_dbase tpcc
diset tpcc maria_driver timed
diset tpcc maria_rampup 2
diset tpcc maria_duration 5
diset tpcc maria_allwarehouse false
diset tpcc maria_timeprofile false
diset tpcc maria_no_stored_procs false
diset tpcc maria_allwarehouse false
diset tpcc maria_timeprofile false
diset tpcc maria_purge true
puts "TEST STARTED"
foreach z { 1 16 32 48 64 80 96 112 128 } {
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
