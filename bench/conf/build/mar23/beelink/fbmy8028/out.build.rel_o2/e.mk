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
In file included from /home/mdcallag/git/fbmysql-56/storage/rocksdb/rdb_cf_options.cc:36:
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_partitioner_factory.h: In function ‘std::string myrocks::get_index_key(myrocks::Index_id)’:
/home/mdcallag/git/fbmysql-56/storage/rocksdb/./rdb_sst_partitioner_factory.h:38:26: warning: type qualifiers ignored on cast result type [-Wignored-qualifiers]
   38 |   rdb_netbuf_store_index((uchar *const)buf.data(), index_id);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~
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
