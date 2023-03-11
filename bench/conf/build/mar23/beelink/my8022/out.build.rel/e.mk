/home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/evutil.c:209:21: warning: argument 4 of type ‘int[2]’ with mismatched bound [-Warray-parameter=]
  209 |     evutil_socket_t fd[2])
In file included from /home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/evutil.c:81:
/home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/include/event2/util.h:310:25: note: previously declared as ‘int[]’
  310 | #define evutil_socket_t int
/home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/util-internal.h:311:47: note: in expansion of macro ‘evutil_socket_t’
  311 | int evutil_ersatz_socketpair_(int, int , int, evutil_socket_t[]);
      |                                               ^~~~~~~~~~~~~~~
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/stubs/port.h:39,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/stubs/common.h:46,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.h:45,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.cc:36:
In function ‘void* memcpy(void*, const void*, size_t)’,
    inlined from ‘google::protobuf::uint8* google::protobuf::io::EpsCopyOutputStream::WriteRaw(const void*, int, google::protobuf::uint8*)’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/io/coded_stream.h:700:16,
    inlined from ‘virtual google::protobuf::uint8* google::protobuf::internal::ImplicitWeakMessage::_InternalSerialize(google::protobuf::uint8*, google::protobuf::io::EpsCopyOutputStream*) const’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/implicit_weak_message.h:87:28,
    inlined from ‘bool google::protobuf::MessageLite::SerializePartialToZeroCopyStream(google::protobuf::io::ZeroCopyOutputStream*) const’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.cc:388:30:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:33: warning: ‘void* __builtin___memcpy_chk(void*, const void*, long unsigned int, long unsigned int)’ specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
   30 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
In function ‘const UChar* icu_65::ufmtval_getString_65(const UFormattedValue*, int32_t*, UErrorCode*)’:
cc1plus: warning: function may return address of local variable [-Wreturn-local-addr]
/home/mdcallag/b/mysql-8.0.22/extra/icu/source/i18n/formattedvalue.cpp:205:19: note: declared here
  205 |     UnicodeString readOnlyAlias = impl->fFormattedValue->toTempString(*ec);
      |                   ^~~~~~~~~~~~~
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/stubs/port.h:39,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/stubs/common.h:46,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.h:45,
                 from /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.cc:36:
In function ‘void* memcpy(void*, const void*, size_t)’,
    inlined from ‘google::protobuf::uint8* google::protobuf::io::EpsCopyOutputStream::WriteRaw(const void*, int, google::protobuf::uint8*)’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/io/coded_stream.h:700:16,
    inlined from ‘virtual google::protobuf::uint8* google::protobuf::internal::ImplicitWeakMessage::_InternalSerialize(google::protobuf::uint8*, google::protobuf::io::EpsCopyOutputStream*) const’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/implicit_weak_message.h:87:28,
    inlined from ‘bool google::protobuf::MessageLite::SerializePartialToZeroCopyStream(google::protobuf::io::ZeroCopyOutputStream*) const’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.cc:388:30:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:33: warning: ‘void* __builtin___memcpy_chk(void*, const void*, long unsigned int, long unsigned int)’ specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
   30 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/mysys/thr_lock.cc:103:
In function ‘int inline_mysql_cond_init(PSI_cond_key, mysql_cond_t*, const char*, int)’,
    inlined from ‘void* test_thread(void*)’ at /home/mdcallag/b/mysql-8.0.22/mysys/thr_lock.cc:1198:3:
/home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_cond.h:140:41: warning: ‘COND_thr_lock’ may be used uninitialized [-Wmaybe-uninitialized]
  140 |   that->m_psi = PSI_COND_CALL(init_cond)(key, &that->m_cond);
      |                                         ^
/home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_cond.h: In function ‘void* test_thread(void*)’:
/home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_cond.h:140:41: note: by argument 2 of type ‘const void*’ to ‘PSI_cond*(PSI_cond_key, const void*)’ {aka ‘PSI_cond*(unsigned int, const void*)’}
/home/mdcallag/b/mysql-8.0.22/mysys/thr_lock.cc:1195:16: note: ‘COND_thr_lock’ declared here
 1195 |   mysql_cond_t COND_thr_lock;
      |                ^~~~~~~~~~~~~
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/b/mysql-8.0.22/include/m_string.h:37,
                 from /home/mdcallag/b/mysql-8.0.22/client/client_priv.h:33,
                 from /home/mdcallag/b/mysql-8.0.22/client/mysqldump.cc:39:
In function ‘char* stpncpy(char*, const char*, size_t)’,
    inlined from ‘char* my_stpncpy(char*, const char*, size_t)’ at /home/mdcallag/b/mysql-8.0.22/include/m_string.h:196:17,
    inlined from ‘char* cover_definer_clause(char*, size_t, const char*, size_t, const char*, size_t, const char*, size_t)’ at /home/mdcallag/b/mysql-8.0.22/client/mysqldump.cc:1395:25:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:104:34: warning: ‘char* __builtin_stpncpy(char*, const char*, long unsigned int)’ output truncated before terminating nul copying 6 bytes from a string of the same length [-Wstringop-truncation]
  104 |   return __builtin___stpncpy_chk (__dest, __src, __n,
      |          ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
  105 |                                   __glibc_objsize (__dest));
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~
In function ‘char* stpncpy(char*, const char*, size_t)’,
    inlined from ‘char* my_stpncpy(char*, const char*, size_t)’ at /home/mdcallag/b/mysql-8.0.22/include/m_string.h:196:17,
    inlined from ‘char* cover_definer_clause(char*, size_t, const char*, size_t, const char*, size_t, const char*, size_t)’ at /home/mdcallag/b/mysql-8.0.22/client/mysqldump.cc:1399:25:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:104:34: warning: ‘char* __builtin_stpncpy(char*, const char*, long unsigned int)’ output truncated before terminating nul copying 6 bytes from a string of the same length [-Wstringop-truncation]
  104 |   return __builtin___stpncpy_chk (__dest, __src, __n,
      |          ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
  105 |                                   __glibc_objsize (__dest));
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/boost/boost_1_73_0/boost/bind.hpp:30,
                 from /home/mdcallag/b/mysql-8.0.22/client/dump/abstract_mysql_chain_element_extension.cc:29:
/home/mdcallag/b/mysql-8.0.22/boost/boost_1_73_0/boost/bind.hpp:36:1: note: ‘#pragma message: The practice of declaring the Bind placeholders (_1, _2, ...) in the global namespace is deprecated. Please use <boost/bind/bind.hpp> + using namespace boost::placeholders, or define BOOST_BIND_GLOBAL_PLACEHOLDERS to retain the current behavior.’
   36 | BOOST_PRAGMA_MESSAGE(
      | ^~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/b/mysql-8.0.22/include/my_dbug.h:37,
                 from /home/mdcallag/b/mysql-8.0.22/sql/stateless_allocator.h:32,
                 from /home/mdcallag/b/mysql-8.0.22/sql/dd/string_type.h:31,
                 from /home/mdcallag/b/mysql-8.0.22/sql/dd/dd_table.h:32,
                 from /home/mdcallag/b/mysql-8.0.22/sql/dd/dd_table.cc:23:
In function ‘char* stpncpy(char*, const char*, size_t)’,
    inlined from ‘char* my_stpncpy(char*, const char*, size_t)’ at /home/mdcallag/b/mysql-8.0.22/include/m_string.h:196:17,
    inlined from ‘bool dd::rename_foreign_keys(THD*, const char*, const char*, handlerton*, const char*, dd::Table*)’ at /home/mdcallag/b/mysql-8.0.22/sql/dd/dd_table.cc:2491:17:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:104:34: warning: ‘char* __builtin_stpncpy(char*, const char*, long unsigned int)’ specified bound 193 equals destination size [-Wstringop-truncation]
  104 |   return __builtin___stpncpy_chk (__dest, __src, __n,
      |          ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
  105 |                                   __glibc_objsize (__dest));
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/c++/11/ios:40,
                 from /usr/include/c++/11/istream:38,
                 from /usr/include/c++/11/sstream:38,
                 from /home/mdcallag/b/mysql-8.0.22/sql/dd/string_type.h:27,
                 from /home/mdcallag/b/mysql-8.0.22/sql/dd/impl/upgrade/dd.h:28,
                 from /home/mdcallag/b/mysql-8.0.22/sql/dd/impl/upgrade/dd.cc:23:
In static member function ‘static std::char_traits<char>::char_type* std::char_traits<char>::copy(std::char_traits<char>::char_type*, const char_type*, std::size_t)’,
    inlined from ‘static void std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::_S_copy(_CharT*, const _CharT*, std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::size_type) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:359:21,
    inlined from ‘std::__cxx11::basic_string<_CharT, _Traits, _Alloc>& std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::operator=(std::__cxx11::basic_string<_CharT, _Traits, _Alloc>&&) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:740:18,
    inlined from ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’ at /home/mdcallag/b/mysql-8.0.22/sql/dd/impl/upgrade/dd.cc:938:48:
/usr/include/c++/11/bits/char_traits.h:437:56: warning: ‘void* __builtin_memcpy(void*, const void*, long unsigned int)’ reading 18 bytes from a region of size 16 [-Wstringop-overread]
  437 |         return static_cast<char_type*>(__builtin_memcpy(__s1, __s2, __n));
      |                                        ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/dd/impl/upgrade/dd.cc: In function ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’:
/home/mdcallag/b/mysql-8.0.22/sql/dd/impl/upgrade/dd.cc:938:48: note: at offset 16 into source object ‘<anonymous>’ of size 32
  938 |       hidden = String_type(", hidden= 'System'");
      |                                                ^
In file included from /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc.h:45,
                 from /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc_internal.h:47,
                 from /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc_internal.cc:23:
In constructor ‘Item_result_field::Item_result_field(const POS&)’,
    inlined from ‘Item_func::Item_func(const POS&, Item*, Item*)’ at /home/mdcallag/b/mysql-8.0.22/sql/item_func.h:305:69,
    inlined from ‘Item_str_func::Item_str_func(const POS&, Item*, Item*)’ at /home/mdcallag/b/mysql-8.0.22/sql/item_strfunc.h:88:72,
    inlined from ‘Item_geometry_func::Item_geometry_func(const POS&, Item*, Item*)’ at /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc.h:198:32,
    inlined from ‘Item_func_spatial_operation::Item_func_spatial_operation(const POS&, Item*, Item*, Item_func_spatial_operation::op_type)’ at /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc.h:1280:58,
    inlined from ‘Item_func_st_union::Item_func_st_union(const POS&, Item*, Item*)’ at /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc.h:1368:56,
    inlined from ‘void BG_geometry_collection::merge_components(bool*) [with Coordsys = boost::geometry::cs::cartesian]’ at /home/mdcallag/b/mysql-8.0.22/sql/item_geofunc_internal.cc:115:22:
/home/mdcallag/b/mysql-8.0.22/sql/item.h:5300:56: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 5300 |   explicit Item_result_field(const POS &pos) : Item(pos) {}
      |                                                        ^
/home/mdcallag/b/mysql-8.0.22/sql/item.h: In member function ‘void BG_geometry_collection::merge_components(bool*) [with Coordsys = boost::geometry::cs::cartesian]’:
/home/mdcallag/b/mysql-8.0.22/sql/item.h:1023:12: note: by argument 2 of type ‘const POS&’ {aka ‘const YYLTYPE&’} to ‘Item::Item(const POS&)’ declared here
 1023 |   explicit Item(const POS &);
      |            ^~~~
/home/mdcallag/b/mysql-8.0.22/sql/item_geofunc_internal.cc:114:7: note: ‘pos’ declared here
  114 |   POS pos;
      |       ^~~
/home/mdcallag/b/mysql-8.0.22/build.rel/sql/sql_yacc.cc: In function ‘int MYSQLparse(THD*, Parse_tree_root**)’:
/home/mdcallag/b/mysql-8.0.22/build.rel/sql/sql_yacc.cc:44486:1: warning: label ‘yyexhaustedlab’ defined but not used [-Wunused-label]
44486 | yyexhaustedlab:
      | ^~~~~~~~~~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc: In function ‘void append_range_all_keyparts(Opt_trace_array*, String*, String*, SEL_ROOT*, const KEY_PART_INFO*, bool)’:
/home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:15516:27: warning: ‘this’ pointer is null [-Wnonnull]
15516 |       range_string->append(STRING_WITH_LEN("..."));
      |       ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/sql/sql_error.h:40,
                 from /home/mdcallag/b/mysql-8.0.22/sql/field.h:57,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.h:44,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:118:
/home/mdcallag/b/mysql-8.0.22/include/sql_string.h:500:8: note: in a call to non-static member function ‘bool String::append(const char*, size_t)’
  500 |   bool append(const char *s, size_t arg_length);
      |        ^~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:15565:31: warning: ‘this’ pointer is null [-Wnonnull]
15565 |           range_string->append(STRING_WITH_LEN("("));
      |           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/sql/sql_error.h:40,
                 from /home/mdcallag/b/mysql-8.0.22/sql/field.h:57,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.h:44,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:118:
/home/mdcallag/b/mysql-8.0.22/include/sql_string.h:500:8: note: in a call to non-static member function ‘bool String::append(const char*, size_t)’
  500 |   bool append(const char *s, size_t arg_length);
      |        ^~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:15567:31: warning: ‘this’ pointer is null [-Wnonnull]
15567 |           range_string->append(STRING_WITH_LEN(" OR ("));
      |           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/sql/sql_error.h:40,
                 from /home/mdcallag/b/mysql-8.0.22/sql/field.h:57,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.h:44,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:118:
/home/mdcallag/b/mysql-8.0.22/include/sql_string.h:500:8: note: in a call to non-static member function ‘bool String::append(const char*, size_t)’
  500 |   bool append(const char *s, size_t arg_length);
      |        ^~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:15569:29: warning: ‘this’ pointer is null [-Wnonnull]
15569 |         range_string->append(range_so_far->ptr(), range_so_far->length());
      |         ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/sql/sql_error.h:40,
                 from /home/mdcallag/b/mysql-8.0.22/sql/field.h:57,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.h:44,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:118:
/home/mdcallag/b/mysql-8.0.22/include/sql_string.h:500:8: note: in a call to non-static member function ‘bool String::append(const char*, size_t)’
  500 |   bool append(const char *s, size_t arg_length);
      |        ^~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:15570:29: warning: ‘this’ pointer is null [-Wnonnull]
15570 |         range_string->append(STRING_WITH_LEN(")"));
      |         ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
In file included from /home/mdcallag/b/mysql-8.0.22/sql/sql_error.h:40,
                 from /home/mdcallag/b/mysql-8.0.22/sql/field.h:57,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.h:44,
                 from /home/mdcallag/b/mysql-8.0.22/sql/opt_range.cc:118:
/home/mdcallag/b/mysql-8.0.22/include/sql_string.h:500:8: note: in a call to non-static member function ‘bool String::append(const char*, size_t)’
  500 |   bool append(const char *s, size_t arg_length);
      |        ^~~~~~
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:27,
                 from /home/mdcallag/b/mysql-8.0.22/sql/spatial.cc:24:
In function ‘void* memset(void*, int, size_t)’,
    inlined from ‘Geometry::Flags_t::Flags_t()’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:748:13,
    inlined from ‘Geometry::Geometry(const void*, size_t, const Geometry::Flags_t&, gis::srid_t)’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:792:30,
    inlined from ‘Gis_point::Gis_point(bool)’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:1209:65,
    inlined from ‘objtype* Inplace_vector<objtype, array_size>::append_object() [with objtype = Gis_point; long unsigned int array_size = 16]’ at /home/mdcallag/b/mysql-8.0.22/sql/inplace_vector.h:144:12,
    inlined from ‘void Gis_wkb_vector<T>::shallow_push(const Geometry*) [with T = Gis_point]’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.cc:4582:52:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:59:33: warning: ‘void* __builtin_memset(void*, int, long unsigned int)’ offset [0, 7] is out of the bounds [0, 0] [-Warray-bounds]
   59 |   return __builtin___memset_chk (__dest, __ch, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
   60 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
In function ‘void* memset(void*, int, size_t)’,
    inlined from ‘Geometry::Flags_t::Flags_t()’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:748:13,
    inlined from ‘Geometry::Geometry(const void*, size_t, const Geometry::Flags_t&, gis::srid_t)’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:792:30,
    inlined from ‘Gis_polygon::Gis_polygon(bool)’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.h:2259:77,
    inlined from ‘objtype* Inplace_vector<objtype, array_size>::append_object() [with objtype = Gis_polygon; long unsigned int array_size = 16]’ at /home/mdcallag/b/mysql-8.0.22/sql/inplace_vector.h:144:12,
    inlined from ‘void Gis_wkb_vector<T>::shallow_push(const Geometry*) [with T = Gis_polygon]’ at /home/mdcallag/b/mysql-8.0.22/sql/spatial.cc:4582:52:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:59:33: warning: ‘void* __builtin_memset(void*, int, long unsigned int)’ offset [0, 7] is out of the bounds [0, 0] [-Warray-bounds]
   59 |   return __builtin___memset_chk (__dest, __ch, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
   60 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
