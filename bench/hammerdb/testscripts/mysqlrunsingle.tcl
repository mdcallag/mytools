set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db mysql
dbset bm TPC-C
 
jobs profileid 0
giset commandline keepalive_margin 1200
giset timeprofile xt_gather_timeout 1200
 
diset connection mysql_host 127.0.0.1
diset connection mysql_port 3306
diset connection mysql_socket /tmp/mysql.sock
#
diset tpcc mysql_user root
diset tpcc mysql_pass mysql
diset tpcc mysql_dbase tpcc
diset tpcc mysql_driver timed
diset tpcc mysql_rampup 2
diset tpcc mysql_duration 5
diset tpcc mysql_allwarehouse false
diset tpcc mysql_timeprofile true
diset tpcc mysql_no_stored_procs false
puts "TEST STARTED"
foreach z { 96 } {
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
