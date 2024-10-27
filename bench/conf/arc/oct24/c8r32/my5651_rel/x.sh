
for z in a a1 a2 ; do
  echo 4g $z
  bash ini.sh y10${z}_1g_bee >& /dev/null
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep io_cap
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep flush_met
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep flush_sync
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep use_native
  bash down.sh >& /dev/null
done

for z in a a1 a2 a4 ; do
  echo Full $z
  bash ini.sh y10${z}_bee >& /dev/null
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep io_cap
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep flush_met
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep flush_sync
  bin/mysql -uroot -ppw -e 'show global variables' | grep -i innodb | grep use_native
  bash down.sh >& /dev/null
done
