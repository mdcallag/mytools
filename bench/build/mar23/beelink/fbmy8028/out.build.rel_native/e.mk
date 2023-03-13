In file included from /usr/include/c++/11/ios:40,
                 from /usr/include/c++/11/istream:38,
                 from /usr/include/c++/11/sstream:38,
                 from /home/mdcallag/git/fbmysql-56/sql/dd/string_type.h:27,
                 from /home/mdcallag/git/fbmysql-56/sql/dd/impl/upgrade/dd.h:28,
                 from /home/mdcallag/git/fbmysql-56/sql/dd/impl/upgrade/dd.cc:23:
In static member function ‘static std::char_traits<char>::char_type* std::char_traits<char>::copy(std::char_traits<char>::char_type*, const char_type*, std::size_t)’,
    inlined from ‘static void std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::_S_copy(_CharT*, const _CharT*, std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::size_type) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:359:21,
    inlined from ‘std::__cxx11::basic_string<_CharT, _Traits, _Alloc>& std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::operator=(std::__cxx11::basic_string<_CharT, _Traits, _Alloc>&&) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:740:18,
    inlined from ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’ at /home/mdcallag/git/fbmysql-56/sql/dd/impl/upgrade/dd.cc:938:48:
/usr/include/c++/11/bits/char_traits.h:437:56: warning: ‘void* __builtin_memcpy(void*, const void*, long unsigned int)’ reading 18 bytes from a region of size 16 [-Wstringop-overread]
  437 |         return static_cast<char_type*>(__builtin_memcpy(__s1, __s2, __n));
      |                                        ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
/home/mdcallag/git/fbmysql-56/sql/dd/impl/upgrade/dd.cc: In function ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’:
/home/mdcallag/git/fbmysql-56/sql/dd/impl/upgrade/dd.cc:938:48: note: at offset 16 into source object ‘<anonymous>’ of size 32
  938 |       hidden = String_type(", hidden= 'System'");
      |                                                ^
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/git/fbmysql-56/sql/spatial.h:28,
                 from /home/mdcallag/git/fbmysql-56/sql/spatial.cc:24:
In function ‘void* memset(void*, int, size_t)’,
    inlined from ‘Geometry::Flags_t::Flags_t()’ at /home/mdcallag/git/fbmysql-56/sql/spatial.h:734:13,
    inlined from ‘Geometry::Geometry(const void*, size_t, const Geometry::Flags_t&, gis::srid_t)’ at /home/mdcallag/git/fbmysql-56/sql/spatial.h:778:30,
    inlined from ‘Gis_polygon::Gis_polygon(bool)’ at /home/mdcallag/git/fbmysql-56/sql/spatial.h:2241:77,
    inlined from ‘objtype* Inplace_vector<objtype, array_size>::append_object() [with objtype = Gis_polygon; long unsigned int array_size = 16]’ at /home/mdcallag/git/fbmysql-56/sql/inplace_vector.h:144:12,
    inlined from ‘void Gis_wkb_vector<T>::shallow_push(const Geometry*) [with T = Gis_polygon]’ at /home/mdcallag/git/fbmysql-56/sql/spatial.cc:4578:52:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:59:33: warning: ‘void* __builtin_memset(void*, int, long unsigned int)’ offset [0, 7] is out of the bounds [0, 0] [-Warray-bounds]
   59 |   return __builtin___memset_chk (__dest, __ch, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
   60 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
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
