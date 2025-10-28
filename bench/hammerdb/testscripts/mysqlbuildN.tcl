puts "SETTING CONFIGURATION"
dbset db mysql
dbset bm TPC-C
 
diset connection mysql_host localhost
diset connection mysql_port 3306
diset connection mysql_socket $::env(HAMMER_MYSOCK)

set vu $::env(HAMMER_BUILD_VU)
puts "vu: $vu"

set warehouse $::env(HAMMER_WAREHOUSE)
puts "warehouse: $warehouse"

diset tpcc mysql_count_ware $warehouse
diset tpcc mysql_num_vu $vu
diset tpcc mysql_user root
diset tpcc mysql_pass pw
diset tpcc mysql_dbase tpcc
diset tpcc mysql_storage_engine innodb
if { $warehouse >= 200 } {
diset tpcc mysql_partition true
        } else {
diset tpcc mysql_partition false
        }
puts "SCHEMA BUILD STARTED"
buildschema
puts "SCHEMA BUILD COMPLETED"
