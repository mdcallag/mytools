set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db pg
dbset bm TPC-C
 
jobs profileid 11 
giset commandline keepalive_margin 1200
giset timeprofile xt_gather_timeout 1200

diset connection pg_host localhost
diset connection pg_port 5432
diset connection pg_sslmode prefer

diset tpcc pg_superuser storagereview
diset tpcc pg_superuserpass postgres
diset tpcc pg_defaultdbase postgres
diset tpcc pg_user tpcc
diset tpcc pg_pass tpcc
diset tpcc pg_dbase tpcc
diset tpcc pg_driver timed
diset tpcc pg_total_iterations 10000000
diset tpcc pg_rampup 2
diset tpcc pg_duration 5
diset tpcc pg_vacuum true
diset tpcc pg_storedprocs true
diset tpcc pg_timeprofile false
diset tpcc pg_allwarehouse false
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
