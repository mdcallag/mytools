In file included from /usr/include/c++/11/ios:40,
                 from /usr/include/c++/11/istream:38,
                 from /usr/include/c++/11/sstream:38,
                 from /home/mdcallag/b/mysql-8.0.28/sql/dd/string_type.h:27,
                 from /home/mdcallag/b/mysql-8.0.28/sql/dd/impl/upgrade/dd.h:28,
                 from /home/mdcallag/b/mysql-8.0.28/sql/dd/impl/upgrade/dd.cc:23:
In static member function ‘static std::char_traits<char>::char_type* std::char_traits<char>::copy(std::char_traits<char>::char_type*, const char_type*, std::size_t)’,
    inlined from ‘static void std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::_S_copy(_CharT*, const _CharT*, std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::size_type) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:359:21,
    inlined from ‘std::__cxx11::basic_string<_CharT, _Traits, _Alloc>& std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::operator=(std::__cxx11::basic_string<_CharT, _Traits, _Alloc>&&) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:740:18,
    inlined from ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’ at /home/mdcallag/b/mysql-8.0.28/sql/dd/impl/upgrade/dd.cc:938:48:
/usr/include/c++/11/bits/char_traits.h:437:56: warning: ‘void* __builtin_memcpy(void*, const void*, long unsigned int)’ reading 18 bytes from a region of size 16 [-Wstringop-overread]
  437 |         return static_cast<char_type*>(__builtin_memcpy(__s1, __s2, __n));
      |                                        ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
/home/mdcallag/b/mysql-8.0.28/sql/dd/impl/upgrade/dd.cc: In function ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’:
/home/mdcallag/b/mysql-8.0.28/sql/dd/impl/upgrade/dd.cc:938:48: note: at offset 16 into source object ‘<anonymous>’ of size 32
  938 |       hidden = String_type(", hidden= 'System'");
      |                                                ^
/home/mdcallag/b/mysql-8.0.28/build.rel/sql/sql_yacc.cc: In function ‘int MYSQLparse(THD*, Parse_tree_root**)’:
/home/mdcallag/b/mysql-8.0.28/build.rel/sql/sql_yacc.cc:46159:1: warning: label ‘yyexhaustedlab’ defined but not used [-Wunused-label]
46159 | yyexhaustedlab:
      | ^~~~~~~~~~~~~~
In file included from /usr/include/string.h:535,
                 from /home/mdcallag/b/mysql-8.0.28/sql/spatial.h:28,
                 from /home/mdcallag/b/mysql-8.0.28/sql/spatial.cc:24:
In function ‘void* memset(void*, int, size_t)’,
    inlined from ‘Geometry::Flags_t::Flags_t()’ at /home/mdcallag/b/mysql-8.0.28/sql/spatial.h:734:13,
    inlined from ‘Geometry::Geometry(const void*, size_t, const Geometry::Flags_t&, gis::srid_t)’ at /home/mdcallag/b/mysql-8.0.28/sql/spatial.h:778:30,
    inlined from ‘Gis_polygon::Gis_polygon(bool)’ at /home/mdcallag/b/mysql-8.0.28/sql/spatial.h:2241:77,
    inlined from ‘objtype* Inplace_vector<objtype, array_size>::append_object() [with objtype = Gis_polygon; long unsigned int array_size = 16]’ at /home/mdcallag/b/mysql-8.0.28/sql/inplace_vector.h:144:12,
    inlined from ‘void Gis_wkb_vector<T>::shallow_push(const Geometry*) [with T = Gis_polygon]’ at /home/mdcallag/b/mysql-8.0.28/sql/spatial.cc:4578:52:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:59:33: warning: ‘void* __builtin_memset(void*, int, long unsigned int)’ offset [0, 7] is out of the bounds [0, 0] [-Warray-bounds]
   59 |   return __builtin___memset_chk (__dest, __ch, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
   60 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
