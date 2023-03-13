CMake Warning at cmake/sasl.cmake:264 (MESSAGE):
  Could not find SASL
Call Stack (most recent call first):
  CMakeLists.txt:1701 (MYSQL_CHECK_SASL)


CMake Warning at cmake/ldap.cmake:158 (MESSAGE):
  Could not find LDAP
Call Stack (most recent call first):
  CMakeLists.txt:1705 (MYSQL_CHECK_LDAP)


CMake Warning at cmake/fido2.cmake:53 (MESSAGE):
  Cannot find development libraries.  You need to install the required
  packages:

    Debian/Ubuntu:              apt install libudev-dev
    RedHat/Fedora/Oracle Linux: yum install libudev-devel
    SuSE:                       zypper install libudev-devel

Call Stack (most recent call first):
  CMakeLists.txt:1899 (WARN_MISSING_SYSTEM_UDEV)


/home/mdcallag/git/fbmysql-56/storage/rocksdb/get_rocksdb_files.sh: line 33: ROCKSDB_PLUGIN_BUILTINS: command not found
/home/mdcallag/git/fbmysql-56/storage/rocksdb/get_rocksdb_files.sh: line 33: ROCKSDB_PLUGIN_EXTERNS: command not found
In function ‘strncat’,
    inlined from ‘my_crypt_genhash’ at /home/mdcallag/git/fbmysql-56/mysys/crypt_genhash_impl.cc:383:16,
    inlined from ‘my_make_scrambled_password’ at /home/mdcallag/git/fbmysql-56/sql/auth/password.cc:188:19:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:138:34: warning: ‘__builtin_strncat’ output may be truncated copying between 0 and 20 bytes from a string of length 20 [-Wstringop-truncation]
  138 |   return __builtin___strncat_chk (__dest, __src, __len,
      |                                  ^
/home/mdcallag/git/fbmysql-56/client/mysqlbinlog.cc: In function ‘start_gtid_dump’:
/home/mdcallag/git/fbmysql-56/sql/rpl_gtid_set.cc:717:10: warning: ‘gtid.gno’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  717 |     else if (gno < iv->end)
      |          ^
/home/mdcallag/git/fbmysql-56/client/mysqlbinlog.cc:3921:8: note: ‘gtid.gno’ was declared here
 3921 |   Gtid gtid;
      |        ^
/home/mdcallag/git/fbmysql-56/sql/find_gtid_impl.cc:57:53: warning: ‘gtid.sidno’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   57 |       if (gtid_ev->get_sidno(sid_map) == gtid.sidno &&
      |                                                     ^
/home/mdcallag/git/fbmysql-56/client/mysqlbinlog.cc:3921:8: note: ‘gtid.sidno’ was declared here
 3921 |   Gtid gtid;
      |        ^
In file included from /home/mdcallag/git/fbmysql-56/include/my_checksum.h:39,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:32,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/ha_rocksdb.cc:24:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/my_checksum.h:39,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:32,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_datadic.h:35,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_datadic.cc:23:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/m_string.h:43,
                 from /home/mdcallag/git/fbmysql-56/sql/debug_sync.h:35,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_iterator.h:22,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_iterator.cc:17:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/storage/rocksdb/ha_rocksdb.cc:100:
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_partitioner_factory.h: In function ‘std::string myrocks::get_index_key(myrocks::Index_id)’:
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_partitioner_factory.h:38:26: warning: type qualifiers ignored on cast result type [-Wignored-qualifiers]
   38 |   rdb_netbuf_store_index((uchar *const)buf.data(), index_id);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/m_ctype.h:37,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_cf_options.h:24,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_cf_options.cc:22:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/./m_ctype.h:37,
                 from /home/mdcallag/git/fbmysql-56/include/./sql_string.h:40,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_converter.h:24,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_converter.cc:18:
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/my_checksum.h:39,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:32,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./properties_collector.h:29,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/properties_collector.cc:18:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/././ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_cf_options.cc:36:
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_partitioner_factory.h: In function ‘std::string myrocks::get_index_key(myrocks::Index_id)’:
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_partitioner_factory.h:38:26: warning: type qualifiers ignored on cast result type [-Wignored-qualifiers]
   38 |   rdb_netbuf_store_index((uchar *const)buf.data(), index_id);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/m_string.h:43,
                 from /home/mdcallag/git/fbmysql-56/sql/debug_sync.h:35,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_cf_manager.cc:22:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./././ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./././ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/./m_ctype.h:37,
                 from /home/mdcallag/git/fbmysql-56/include/./sql_string.h:40,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/././rdb_global.h:31,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./event_listener.h:22,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/event_listener.cc:18:
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/my_alloc.h:42,
                 from /home/mdcallag/git/fbmysql-56/sql/sql_plugin_ref.h:27,
                 from /home/mdcallag/git/fbmysql-56/sql/sql_plugin.h:35,
                 from /home/mdcallag/git/fbmysql-56/include/mysql/plugin.h:36,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_i_s.cc:26:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/my_alloc.h:42,
                 from /home/mdcallag/git/fbmysql-56/sql/sql_plugin_ref.h:27,
                 from /home/mdcallag/git/fbmysql-56/sql/sql_plugin.h:35,
                 from /home/mdcallag/git/fbmysql-56/include/mysql/plugin.h:36,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_index_merge.h:20,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_index_merge.cc:18:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/m_ctype.h:37,
                 from /home/mdcallag/git/fbmysql-56/include/ft_global.h:37,
                 from /home/mdcallag/git/fbmysql-56/sql/handler.h:48,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_perf_context.h:25,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_perf_context.cc:19:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/./m_string.h:43,
                 from /home/mdcallag/git/fbmysql-56/include/./my_sys.h:56,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_mutex_wrapper.h:27,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_mutex_wrapper.cc:18:
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/./my_stacktrace.h:37,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/././rdb_utils.h:24,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_info.h:35,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_sst_info.cc:18:
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/./my_stacktrace.h:37,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_utils.h:24,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_utils.cc:18:
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/./my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/m_ctype.h:37,
                 from /home/mdcallag/git/fbmysql-56/sql/item.h:42,
                 from /home/mdcallag/git/fbmysql-56/sql/partitioning/partition_base.h:20,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/ha_rockspart.h:18,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/ha_rockspart.cc:16:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
In file included from /home/mdcallag/git/fbmysql-56/include/m_ctype.h:37,
                 from /home/mdcallag/git/fbmysql-56/include/sql_string.h:40,
                 from /home/mdcallag/git/fbmysql-56/sql/protocol.h:32,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/./nosql_access.h:30,
                 from /home/mdcallag/git/fbmysql-56/storage/rocksdb/nosql_access.cc:20:
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:495:43: note: in expansion of macro ‘MY_ATTRIBUTE’
  495 |   int rename_table(const char *const from MY_ATTRIBUTE((__nonnull__)),
      |                                           ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/include/my_compiler.h:100:40: warning: ‘nonnull’ attribute only applies to function types [-Wattributes]
  100 | #define MY_ATTRIBUTE(A) __attribute__(A)
      |                                        ^
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./ha_rocksdb.h:496:41: note: in expansion of macro ‘MY_ATTRIBUTE’
  496 |                    const char *const to MY_ATTRIBUTE((__nonnull__)),
      |                                         ^~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/sql/parser_yystype.h:341: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
  341 | union YYSTYPE {
      | 
/home/mdcallag/git/fbmysql-56/storage/innobase/include/fts0pars.h:50: note: a different type is defined in another translation unit
   50 | typedef union YYSTYPE
      | 
/home/mdcallag/git/fbmysql-56/sql/parser_yystype.h:342: note: the first difference of corresponding definitions is field ‘lexer’
  342 |   Lexer_yystype lexer;  // terminal values from the lexical scanner
      | 
../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
/home/mdcallag/git/fbmysql-56/build.rel_native_lto/sql/sql_yacc.cc:567: warning: type ‘yysymbol_kind_t’ violates the C++ One Definition Rule [-Wodr]
  567 | enum yysymbol_kind_t
      | 
/home/mdcallag/git/fbmysql-56/build.rel_native_lto/sql/sql_hints.yy.cc:136: note: an enum with different value name is defined in another translation unit
  136 | enum yysymbol_kind_t
      | 
/home/mdcallag/git/fbmysql-56/build.rel_native_lto/sql/sql_yacc.cc:573: note: name ‘YYSYMBOL_ABORT_SYM’ differs from name ‘YYSYMBOL_MAX_EXECUTION_TIME_HINT’ defined in another translation unit
  573 |   YYSYMBOL_ABORT_SYM = 3,                  /* ABORT_SYM  */
      | 
/home/mdcallag/git/fbmysql-56/build.rel_native_lto/sql/sql_hints.yy.cc:142: note: mismatching definition
  142 |   YYSYMBOL_MAX_EXECUTION_TIME_HINT = 3,    /* MAX_EXECUTION_TIME_HINT  */
      | 
/home/mdcallag/git/fbmysql-56/build.rel_native_lto/sql/sql_yacc.h:51: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   51 |   enum yytokentype
      | 
/home/mdcallag/git/fbmysql-56/storage/innobase/include/pars0grm.h:46: note: an enum with different value name is defined in another translation unit
   46 | enum yytokentype {
      | 
/home/mdcallag/git/fbmysql-56/build.rel_native_lto/sql/sql_yacc.h:53: note: name ‘YYEMPTY’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   53 |     YYEMPTY = -2,
      | 
/home/mdcallag/git/fbmysql-56/storage/innobase/include/pars0grm.h:47: note: mismatching definition
   47 |   PARS_INT_LIT = 258,
      | 
/home/mdcallag/git/fbmysql-56/sql/rpl_handler.cc: In function ‘update_sys_var.constprop’:
/home/mdcallag/git/fbmysql-56/sql/set_var.cc:1018:37: warning: ‘tmp.str’ may be used uninitialized [-Wmaybe-uninitialized]
 1018 |     : var(var_arg), type(type_arg), base(base_name_arg), var_tracker(var_arg) {
      |                                     ^
/home/mdcallag/git/fbmysql-56/sql/rpl_handler.cc:1647:17: note: ‘tmp.str’ was declared here
 1647 |     LEX_CSTRING tmp;
      |                 ^
/home/mdcallag/git/fbmysql-56/sql/set_var.cc:1018:37: warning: ‘tmp.length’ may be used uninitialized [-Wmaybe-uninitialized]
 1018 |     : var(var_arg), type(type_arg), base(base_name_arg), var_tracker(var_arg) {
      |                                     ^
/home/mdcallag/git/fbmysql-56/sql/rpl_handler.cc:1647:17: note: ‘tmp.length’ was declared here
 1647 |     LEX_CSTRING tmp;
      |                 ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1133:3: warning: ‘mrg_info.errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1133 |   if (mrg_info.errkey >= (int)table_share->keys) {
      |   ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.errkey’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1143:36: warning: ‘mrg_info.reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1143 |   stats.mean_rec_length = mrg_info.reclength;
      |                                    ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.reclength’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1176:17: warning: ‘mrg_info.dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1176 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.dupp_key_pos’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1132:26: warning: ‘mrg_info.data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1132 |   stats.data_file_length = mrg_info.data_file_length;
      |                          ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.data_file_length’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1123:16: warning: ‘mrg_info.deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/git/fbmysql-56/storage/myisammrg/ha_myisammrg.cc:1123:16: warning: ‘mrg_info.records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
In function ‘strncpy’,
    inlined from ‘build_name’ at /home/mdcallag/git/fbmysql-56/storage/innobase/arch/arch0arch.cc:494:12,
    inlined from ‘get_file_name’ at /home/mdcallag/git/fbmysql-56/storage/innobase/include/arch0arch.h:1131:26,
    inlined from ‘get_files’ at /home/mdcallag/git/fbmysql-56/storage/innobase/arch/arch0log.cc:151:27:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:95:34: warning: ‘__builtin_strncpy’ specified bound 98 equals destination size [-Wstringop-truncation]
   95 |   return __builtin___strncpy_chk (__dest, __src, __len,
      |                                  ^
In function ‘strncpy’,
    inlined from ‘create_and_init_vio’ at /home/mdcallag/git/fbmysql-56/sql/conn_handler/socket_connection.cc:220:12:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:95:34: warning: ‘__builtin_strncpy’ writing 255 bytes into a region of size 0 overflows the destination [-Wstringop-overflow=]
   95 |   return __builtin___strncpy_chk (__dest, __src, __len,
      |                                  ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_func.h:2216:45,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1148:73:
/home/mdcallag/git/fbmysql-56/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:2012:44,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1150:72:
/home/mdcallag/git/fbmysql-56/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_func.h:2148:45,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1154:75:
/home/mdcallag/git/fbmysql-56/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:1960:44,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1156:74:
/home/mdcallag/git/fbmysql-56/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_func.h:2177:45,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1160:73:
/home/mdcallag/git/fbmysql-56/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:1987:44,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1162:72:
/home/mdcallag/git/fbmysql-56/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_func.h:2198:45,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1166:77:
/home/mdcallag/git/fbmysql-56/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/git/fbmysql-56/sql/item_sum.h:2051:44,
    inlined from ‘create’ at /home/mdcallag/git/fbmysql-56/sql/item_create.cc:1168:76:
/home/mdcallag/git/fbmysql-56/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/git/fbmysql-56/sql/item_func.cc:331:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  331 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/git/fbmysql-56/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
