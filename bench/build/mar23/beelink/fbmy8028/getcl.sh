
x=$1

grep mysqld\.cc build.${x}/o.mk  | grep c++ > cl.mysqld_cc.build.${x}
cat cl.mysqld_cc.build.${x} | tr ' ' '\n' | sort | uniq | grep -v isystem > cl.mysqld_cc.s.build.${x}
#grep mysqld build.${x}/o.mk | tail -3 | head -1 > cl.mysqld_bin.build.${x}
grep mysqld build.${x}/o.mk |  grep "\-o" | tail -1 > cl.mysqld_bin.build.${x}
cat cl.mysqld_bin.build.${x} | tr ' ' '\n' | sort | uniq > cl.mysqld_bin.s.build.${x}

grep \/db_impl\.cc build.${x}/o.mk | grep -v sst_dump | grep -v ldb | grep c++ > cl.db_impl_cc.build.${x}
cat cl.db_impl_cc.build.${x} | tr ' ' '\n' | sort | uniq | grep -v isystem > cl.db_impl_cc.s.build.${x}
