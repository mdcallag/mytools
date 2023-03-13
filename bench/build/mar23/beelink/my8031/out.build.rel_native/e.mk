CMake Warning at cmake/sasl.cmake:264 (MESSAGE):
  Could not find SASL
Call Stack (most recent call first):
  CMakeLists.txt:1785 (MYSQL_CHECK_SASL)


CMake Warning at cmake/ldap.cmake:158 (MESSAGE):
  Could not find LDAP
Call Stack (most recent call first):
  CMakeLists.txt:1789 (MYSQL_CHECK_LDAP)


CMake Warning at cmake/fido2.cmake:70 (MESSAGE):
  Cannot find development libraries.  You need to install the required
  packages:

    Debian/Ubuntu:              apt install libudev-dev
    RedHat/Fedora/Oracle Linux: yum install libudev-devel
    SuSE:                       zypper install libudev-devel

Call Stack (most recent call first):
  CMakeLists.txt:2039 (WARN_MISSING_SYSTEM_UDEV)


In file included from /usr/include/c++/11/ios:40,
                 from /usr/include/c++/11/istream:38,
                 from /usr/include/c++/11/sstream:38,
                 from /home/mdcallag/b/mysql-8.0.31/sql/dd/string_type.h:27,
                 from /home/mdcallag/b/mysql-8.0.31/sql/dd/impl/upgrade/dd.h:28,
                 from /home/mdcallag/b/mysql-8.0.31/sql/dd/impl/upgrade/dd.cc:23:
In static member function ‘static std::char_traits<char>::char_type* std::char_traits<char>::copy(std::char_traits<char>::char_type*, const char_type*, std::size_t)’,
    inlined from ‘static void std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::_S_copy(_CharT*, const _CharT*, std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::size_type) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:359:21,
    inlined from ‘std::__cxx11::basic_string<_CharT, _Traits, _Alloc>& std::__cxx11::basic_string<_CharT, _Traits, _Alloc>::operator=(std::__cxx11::basic_string<_CharT, _Traits, _Alloc>&&) [with _CharT = char; _Traits = std::char_traits<char>; _Alloc = Stateless_allocator<char, dd::String_type_alloc>]’ at /usr/include/c++/11/bits/basic_string.h:740:18,
    inlined from ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’ at /home/mdcallag/b/mysql-8.0.31/sql/dd/impl/upgrade/dd.cc:938:48:
/usr/include/c++/11/bits/char_traits.h:437:56: warning: ‘void* __builtin_memcpy(void*, const void*, long unsigned int)’ reading 18 bytes from a region of size 16 [-Wstringop-overread]
  437 |         return static_cast<char_type*>(__builtin_memcpy(__s1, __s2, __n));
      |                                        ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
/home/mdcallag/b/mysql-8.0.31/sql/dd/impl/upgrade/dd.cc: In function ‘bool dd::{anonymous}::update_object_ids(THD*, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, const std::set<std::__cxx11::basic_string<char, std::char_traits<char>, Stateless_allocator<char, dd::String_type_alloc> > >&, dd::Object_id, dd::Object_id, const String_type&, dd::Object_id)’:
/home/mdcallag/b/mysql-8.0.31/sql/dd/impl/upgrade/dd.cc:938:48: note: at offset 16 into source object ‘<anonymous>’ of size 32
  938 |       hidden = String_type(", hidden= 'System'");
      |                                                ^
