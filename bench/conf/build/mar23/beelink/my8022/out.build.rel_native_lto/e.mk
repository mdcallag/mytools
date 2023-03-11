/home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/evutil.c:209:21: warning: argument 4 of type ‘int[2]’ with mismatched bound [-Warray-parameter=]
  209 |     evutil_socket_t fd[2])
In file included from /home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/evutil.c:81:
/home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/include/event2/util.h:310:25: note: previously declared as ‘int[]’
  310 | #define evutil_socket_t int
/home/mdcallag/b/mysql-8.0.22/extra/libevent/libevent-2.1.11-stable/util-internal.h:311:47: note: in expansion of macro ‘evutil_socket_t’
  311 | int evutil_ersatz_socketpair_(int, int , int, evutil_socket_t[]);
      |                                               ^~~~~~~~~~~~~~~
In function ‘const UChar* icu_65::ufmtval_getString_65(const UFormattedValue*, int32_t*, UErrorCode*)’:
cc1plus: warning: function may return address of local variable [-Wreturn-local-addr]
/home/mdcallag/b/mysql-8.0.22/extra/icu/source/i18n/formattedvalue.cpp:205:19: note: declared here
  205 |     UnicodeString readOnlyAlias = impl->fFormattedValue->toTempString(*ec);
      |                   ^~~~~~~~~~~~~
In function ‘memcpy’,
    inlined from ‘WriteRaw’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/io/coded_stream.h:700:16,
    inlined from ‘_InternalSerialize’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/implicit_weak_message.h:87:28,
    inlined from ‘SerializePartialToZeroCopyStream’ at /home/mdcallag/b/mysql-8.0.22/extra/protobuf/protobuf-3.11.4/src/google/protobuf/message_lite.cc:388:30:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:33: warning: ‘__builtin___memcpy_chk’ specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |                                 ^
In function ‘inline_mysql_cond_init’,
    inlined from ‘test_thread’ at /home/mdcallag/b/mysql-8.0.22/mysys/thr_lock.cc:1198:3:
/home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_cond.h:140:41: warning: ‘COND_thr_lock’ may be used uninitialized [-Wmaybe-uninitialized]
  140 |   that->m_psi = PSI_COND_CALL(init_cond)(key, &that->m_cond);
      |                                         ^
/home/mdcallag/b/mysql-8.0.22/mysys/thr_lock.cc: In function ‘test_thread’:
/home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_cond.h:140:41: note: by argument 2 of type ‘const void *’ to ‘struct PSI_cond * <T741> (PSI_cond_key, const void *)’
/home/mdcallag/b/mysql-8.0.22/mysys/thr_lock.cc:1195:16: note: ‘COND_thr_lock’ declared here
 1195 |   mysql_cond_t COND_thr_lock;
      |                ^
In function ‘read’,
    inlined from ‘my_read’ at /home/mdcallag/b/mysql-8.0.22/mysys/my_read.cc:87:57,
    inlined from ‘inline_mysql_file_read’ at /home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_file.h:1034:21,
    inlined from ‘mi_open_share.constprop’ at /home/mdcallag/b/mysql-8.0.22/storage/myisam/mi_open.cc:174:9:
/usr/include/x86_64-linux-gnu/bits/unistd.h:38:10: warning: ‘__read_alias’ writing 24 bytes into a region of size 4 overflows the destination [-Wstringop-overflow=]
   38 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^
/usr/include/x86_64-linux-gnu/bits/unistd.h: In function ‘mi_open_share.constprop’:
/home/mdcallag/b/mysql-8.0.22/storage/myisam/myisamdef.h:68:11: note: destination object ‘file_version’ of size 4
   68 |     uchar file_version[4];
      |           ^
/usr/include/x86_64-linux-gnu/bits/unistd.h:26:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   26 | extern ssize_t __REDIRECT (__read_alias, (int __fd, void *__buf,
      |                ^
In function ‘read’,
    inlined from ‘my_read’ at /home/mdcallag/b/mysql-8.0.22/mysys/my_read.cc:87:57,
    inlined from ‘inline_mysql_file_read’ at /home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_file.h:1034:21,
    inlined from ‘mi_open_share.constprop’ at /home/mdcallag/b/mysql-8.0.22/storage/myisam/mi_open.cc:174:9:
/usr/include/x86_64-linux-gnu/bits/unistd.h:38:10: warning: ‘__read_alias’ writing 24 bytes into a region of size 4 overflows the destination [-Wstringop-overflow=]
   38 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^
/usr/include/x86_64-linux-gnu/bits/unistd.h: In function ‘mi_open_share.constprop’:
/home/mdcallag/b/mysql-8.0.22/storage/myisam/myisamdef.h:68:11: note: destination object ‘file_version’ of size 4
   68 |     uchar file_version[4];
      |           ^
/usr/include/x86_64-linux-gnu/bits/unistd.h:26:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   26 | extern ssize_t __REDIRECT (__read_alias, (int __fd, void *__buf,
      |                ^
In function ‘read’,
    inlined from ‘my_read’ at /home/mdcallag/b/mysql-8.0.22/mysys/my_read.cc:87:57,
    inlined from ‘inline_mysql_file_read’ at /home/mdcallag/b/mysql-8.0.22/include/mysql/psi/mysql_file.h:1034:21,
    inlined from ‘mi_open_share.constprop’ at /home/mdcallag/b/mysql-8.0.22/storage/myisam/mi_open.cc:174:9:
/usr/include/x86_64-linux-gnu/bits/unistd.h:38:10: warning: ‘__read_alias’ writing 24 bytes into a region of size 4 overflows the destination [-Wstringop-overflow=]
   38 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^
/usr/include/x86_64-linux-gnu/bits/unistd.h: In function ‘mi_open_share.constprop’:
/home/mdcallag/b/mysql-8.0.22/storage/myisam/myisamdef.h:68:11: note: destination object ‘file_version’ of size 4
   68 |     uchar file_version[4];
      |           ^
/usr/include/x86_64-linux-gnu/bits/unistd.h:26:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   26 | extern ssize_t __REDIRECT (__read_alias, (int __fd, void *__buf,
      |                ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘stpncpy’,
    inlined from ‘my_stpncpy’ at /home/mdcallag/b/mysql-8.0.22/include/m_string.h:196:17,
    inlined from ‘cover_definer_clause.constprop’ at /home/mdcallag/b/mysql-8.0.22/client/mysqldump.cc:1395:25:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:104:34: warning: ‘__builtin_stpncpy’ output truncated before terminating nul copying 6 bytes from a string of the same length [-Wstringop-truncation]
  104 |   return __builtin___stpncpy_chk (__dest, __src, __n,
      |                                  ^
In function ‘stpncpy’,
    inlined from ‘my_stpncpy’ at /home/mdcallag/b/mysql-8.0.22/include/m_string.h:196:17,
    inlined from ‘cover_definer_clause.constprop’ at /home/mdcallag/b/mysql-8.0.22/client/mysqldump.cc:1399:25:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:104:34: warning: ‘__builtin_stpncpy’ output truncated before terminating nul copying 6 bytes from a string of the same length [-Wstringop-truncation]
  104 |   return __builtin___stpncpy_chk (__dest, __src, __n,
      |                                  ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In file included from /home/mdcallag/b/mysql-8.0.22/boost/boost_1_73_0/boost/bind.hpp:30,
                 from /home/mdcallag/b/mysql-8.0.22/client/dump/abstract_mysql_chain_element_extension.cc:29:
/home/mdcallag/b/mysql-8.0.22/boost/boost_1_73_0/boost/bind.hpp:36:1: note: ‘#pragma message: The practice of declaring the Bind placeholders (_1, _2, ...) in the global namespace is deprecated. Please use <boost/bind/bind.hpp> + using namespace boost::placeholders, or define BOOST_BIND_GLOBAL_PLACEHOLDERS to retain the current behavior.’
   36 | BOOST_PRAGMA_MESSAGE(
      | ^~~~~~~~~~~~~~~~~~~~
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_yacc.cc: In function ‘int MYSQLparse(THD*, Parse_tree_root**)’:
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_yacc.cc:44486:1: warning: label ‘yyexhaustedlab’ defined but not used [-Wunused-label]
44486 | yyexhaustedlab:
      | ^~~~~~~~~~~~~~
/home/mdcallag/b/mysql-8.0.22/sql/parser_yystype.h:338:7: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
  338 | union YYSTYPE {
      |       ^
/home/mdcallag/b/mysql-8.0.22/storage/innobase/include/fts0pars.h:50: note: a different type is defined in another translation unit
   50 | typedef union YYSTYPE
      | 
/home/mdcallag/b/mysql-8.0.22/sql/parser_yystype.h:339:17: note: the first difference of corresponding definitions is field ‘lexer’
  339 |   Lexer_yystype lexer;  // terminal values from the lexical scanner
      |                 ^
../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_yacc.cc:559: warning: type ‘yysymbol_kind_t’ violates the C++ One Definition Rule [-Wodr]
  559 | enum yysymbol_kind_t
      | 
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_hints.yy.cc:135: note: an enum with different value name is defined in another translation unit
  135 | enum yysymbol_kind_t
      | 
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_yacc.cc:565: note: name ‘YYSYMBOL_ABORT_SYM’ differs from name ‘YYSYMBOL_MAX_EXECUTION_TIME_HINT’ defined in another translation unit
  565 |   YYSYMBOL_ABORT_SYM = 3,                  /* ABORT_SYM  */
      | 
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_hints.yy.cc:141: note: mismatching definition
  141 |   YYSYMBOL_MAX_EXECUTION_TIME_HINT = 3,    /* MAX_EXECUTION_TIME_HINT  */
      | 
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_yacc.h:51: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   51 |   enum yytokentype
      | 
/home/mdcallag/b/mysql-8.0.22/storage/innobase/include/pars0grm.h:46: note: an enum with different value name is defined in another translation unit
   46 | enum yytokentype {
      | 
/home/mdcallag/b/mysql-8.0.22/build.rel_native_lto/sql/sql_yacc.h:53: note: name ‘YYEMPTY’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   53 |     YYEMPTY = -2,
      | 
/home/mdcallag/b/mysql-8.0.22/storage/innobase/include/pars0grm.h:47: note: mismatching definition
   47 |   PARS_INT_LIT = 258,
      | 
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1134:3: warning: ‘mrg_info.errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1134 |   if (mrg_info.errkey >= (int)table_share->keys) {
      |   ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1124:16: note: ‘mrg_info.errkey’ was declared here
 1124 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1144:36: warning: ‘mrg_info.reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1144 |   stats.mean_rec_length = mrg_info.reclength;
      |                                    ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1124:16: note: ‘mrg_info.reclength’ was declared here
 1124 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1177:17: warning: ‘mrg_info.dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1177 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1124:16: note: ‘mrg_info.dupp_key_pos’ was declared here
 1124 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1133:26: warning: ‘mrg_info.data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1133 |   stats.data_file_length = mrg_info.data_file_length;
      |                          ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1124:16: note: ‘mrg_info.data_file_length’ was declared here
 1124 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1124:16: warning: ‘mrg_info.deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-8.0.22/storage/myisammrg/ha_myisammrg.cc:1124:16: warning: ‘mrg_info.records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
In function ‘strncpy’,
    inlined from ‘build_name’ at /home/mdcallag/b/mysql-8.0.22/storage/innobase/arch/arch0arch.cc:478:12,
    inlined from ‘get_file_name’ at /home/mdcallag/b/mysql-8.0.22/storage/innobase/include/arch0arch.h:1182:26,
    inlined from ‘get_files’ at /home/mdcallag/b/mysql-8.0.22/storage/innobase/arch/arch0log.cc:151:27:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:95:34: warning: ‘__builtin_strncpy’ specified bound 98 equals destination size [-Wstringop-truncation]
   95 |   return __builtin___strncpy_chk (__dest, __src, __len,
      |                                  ^
In function ‘stpncpy’,
    inlined from ‘my_stpncpy’ at /home/mdcallag/b/mysql-8.0.22/include/m_string.h:196:17,
    inlined from ‘rename_foreign_keys’ at /home/mdcallag/b/mysql-8.0.22/sql/dd/dd_table.cc:2491:17:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:104:34: warning: ‘__builtin_stpncpy’ specified bound 193 equals destination size [-Wstringop-truncation]
  104 |   return __builtin___stpncpy_chk (__dest, __src, __n,
      |                                  ^
In member function ‘parse’,
    inlined from ‘parse’ at /home/mdcallag/b/mysql-8.0.22/sql/rpl_gtid_misc.cc:77:16:
/home/mdcallag/b/mysql-8.0.22/libbinlogevents/src/uuid.cpp:53:15: warning: ‘sid’ may be used uninitialized [-Wmaybe-uninitialized]
   53 |   return parse(string, len, bytes);
      |               ^
/home/mdcallag/b/mysql-8.0.22/sql/rpl_gtid_misc.cc: In member function ‘parse’:
/home/mdcallag/b/mysql-8.0.22/libbinlogevents/src/uuid.cpp:56: note: by argument 3 of type ‘const unsigned char *’ to ‘parse’ declared here
   56 | int Uuid::parse(const char *in_string, size_t len,
      | 
/home/mdcallag/b/mysql-8.0.22/sql/rpl_gtid_misc.cc:71:11: note: ‘sid’ declared here
   71 |   rpl_sid sid;
      |           ^
In member function ‘parse’,
    inlined from ‘init’ at /home/mdcallag/b/mysql-8.0.22/sql/rpl_gtid_state.cc:646:23:
/home/mdcallag/b/mysql-8.0.22/libbinlogevents/src/uuid.cpp:53:15: warning: ‘server_sid’ may be used uninitialized [-Wmaybe-uninitialized]
   53 |   return parse(string, len, bytes);
      |               ^
/home/mdcallag/b/mysql-8.0.22/sql/rpl_gtid_state.cc: In member function ‘init’:
/home/mdcallag/b/mysql-8.0.22/libbinlogevents/src/uuid.cpp:56: note: by argument 3 of type ‘const unsigned char *’ to ‘parse’ declared here
   56 | int Uuid::parse(const char *in_string, size_t len,
      | 
/home/mdcallag/b/mysql-8.0.22/sql/rpl_gtid_state.cc:645:11: note: ‘server_sid’ declared here
  645 |   rpl_sid server_sid;
      |           ^
/home/mdcallag/b/mysql-8.0.22/sql/item_strfunc.cc: In member function ‘val_str’:
/home/mdcallag/b/mysql-8.0.22/include/add_with_saturate.h:41:17: warning: ‘MEM[(unsigned int *)&sortorder + 8B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   41 |   auto result = a + b;
      |                 ^
/home/mdcallag/b/mysql-8.0.22/sql/item_strfunc.cc:3224:17: note: ‘MEM[(unsigned int *)&sortorder + 8B]’ was declared here
 3224 |   st_sort_field sortorder;
      |                 ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2211:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1132:73:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2066:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2066 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.cc:200: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  200 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:2027:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1134:72:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:1938:54: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1938 |       : Item_sum(pos, opt_list, nullptr), udf(udf_arg) {
      |                                                      ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.cc:402: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  402 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list, PT_window *w)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2143:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1138:75:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2066:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2066 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.cc:200: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  200 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:1975:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1140:74:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:1938:54: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1938 |       : Item_sum(pos, opt_list, nullptr), udf(udf_arg) {
      |                                                      ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.cc:402: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  402 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list, PT_window *w)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2172:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1144:73:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2066:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2066 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.cc:200: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  200 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:2002:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1146:72:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:1938:54: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1938 |       : Item_sum(pos, opt_list, nullptr), udf(udf_arg) {
      |                                                      ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.cc:402: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  402 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list, PT_window *w)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2193:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1150:77:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.h:2066:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2066 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_func.cc:200: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  200 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:2066:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1152:76:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.h:1938:54: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1938 |       : Item_sum(pos, opt_list, nullptr), udf(udf_arg) {
      |                                                      ^
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.22/sql/item_sum.cc:402: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  402 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list, PT_window *w)
      | 
/home/mdcallag/b/mysql-8.0.22/sql/item_create.cc:1127:7: note: ‘pos’ declared here
 1127 |   POS pos;
      |       ^
In function ‘strncpy’,
    inlined from ‘create_and_init_vio’ at /home/mdcallag/b/mysql-8.0.22/sql/conn_handler/socket_connection.cc:218:12:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:95:34: warning: ‘__builtin_strncpy’ writing 255 bytes into a region of size 0 overflows the destination [-Wstringop-overflow=]
   95 |   return __builtin___strncpy_chk (__dest, __src, __len,
      |                                  ^
In function ‘xor_string’,
    inlined from ‘sha256_password_auth_client_nonblocking’ at /home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:364:17:
/home/mdcallag/b/mysql-8.0.22/mysys/crypt_genhash_impl.cc:441:21: warning: ‘scramble_pkt’ may be used uninitialized [-Wmaybe-uninitialized]
  441 |     *(to + loop) ^= *(pattern + loop % pattern_len);
      |                     ^
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc: In function ‘sha256_password_auth_client_nonblocking’:
/home/mdcallag/b/mysql-8.0.22/sql-common/client_authentication.cc:271:17: note: ‘scramble_pkt’ declared here
  271 |   unsigned char scramble_pkt[20];
      |                 ^
