In function ‘read’,
    inlined from ‘my_read’ at /home/mdcallag/b/mysql-8.0.28/mysys/my_read.cc:87:57,
    inlined from ‘inline_mysql_file_read’ at /home/mdcallag/b/mysql-8.0.28/include/mysql/psi/mysql_file.h:1041:21,
    inlined from ‘mi_open_share.constprop’ at /home/mdcallag/b/mysql-8.0.28/storage/myisam/mi_open.cc:174:9:
/usr/include/x86_64-linux-gnu/bits/unistd.h:38:10: warning: ‘__read_alias’ writing 24 bytes into a region of size 4 overflows the destination [-Wstringop-overflow=]
   38 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^
/usr/include/x86_64-linux-gnu/bits/unistd.h: In function ‘mi_open_share.constprop’:
/home/mdcallag/b/mysql-8.0.28/storage/myisam/myisamdef.h:69:11: note: destination object ‘file_version’ of size 4
   69 |     uchar file_version[4];
      |           ^
/usr/include/x86_64-linux-gnu/bits/unistd.h:26:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   26 | extern ssize_t __REDIRECT (__read_alias, (int __fd, void *__buf,
      |                ^
In function ‘read’,
    inlined from ‘my_read’ at /home/mdcallag/b/mysql-8.0.28/mysys/my_read.cc:87:57,
    inlined from ‘inline_mysql_file_read’ at /home/mdcallag/b/mysql-8.0.28/include/mysql/psi/mysql_file.h:1041:21,
    inlined from ‘mi_open_share.constprop’ at /home/mdcallag/b/mysql-8.0.28/storage/myisam/mi_open.cc:174:9:
/usr/include/x86_64-linux-gnu/bits/unistd.h:38:10: warning: ‘__read_alias’ writing 24 bytes into a region of size 4 overflows the destination [-Wstringop-overflow=]
   38 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^
/usr/include/x86_64-linux-gnu/bits/unistd.h: In function ‘mi_open_share.constprop’:
/home/mdcallag/b/mysql-8.0.28/storage/myisam/myisamdef.h:69:11: note: destination object ‘file_version’ of size 4
   69 |     uchar file_version[4];
      |           ^
/usr/include/x86_64-linux-gnu/bits/unistd.h:26:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   26 | extern ssize_t __REDIRECT (__read_alias, (int __fd, void *__buf,
      |                ^
In function ‘read’,
    inlined from ‘my_read’ at /home/mdcallag/b/mysql-8.0.28/mysys/my_read.cc:87:57,
    inlined from ‘inline_mysql_file_read’ at /home/mdcallag/b/mysql-8.0.28/include/mysql/psi/mysql_file.h:1041:21,
    inlined from ‘mi_open_share.constprop’ at /home/mdcallag/b/mysql-8.0.28/storage/myisam/mi_open.cc:174:9:
/usr/include/x86_64-linux-gnu/bits/unistd.h:38:10: warning: ‘__read_alias’ writing 24 bytes into a region of size 4 overflows the destination [-Wstringop-overflow=]
   38 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^
/usr/include/x86_64-linux-gnu/bits/unistd.h: In function ‘mi_open_share.constprop’:
/home/mdcallag/b/mysql-8.0.28/storage/myisam/myisamdef.h:69:11: note: destination object ‘file_version’ of size 4
   69 |     uchar file_version[4];
      |           ^
/usr/include/x86_64-linux-gnu/bits/unistd.h:26:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   26 | extern ssize_t __REDIRECT (__read_alias, (int __fd, void *__buf,
      |                ^
In function ‘strncat’,
    inlined from ‘my_crypt_genhash’ at /home/mdcallag/b/mysql-8.0.28/mysys/crypt_genhash_impl.cc:383:16,
    inlined from ‘my_make_scrambled_password’ at /home/mdcallag/b/mysql-8.0.28/sql/auth/password.cc:188:19:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:138:34: warning: ‘__builtin_strncat’ output may be truncated copying between 0 and 20 bytes from a string of length 20 [-Wstringop-truncation]
  138 |   return __builtin___strncat_chk (__dest, __src, __len,
      |                                  ^
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_yacc.cc: In function ‘int MYSQLparse(THD*, Parse_tree_root**)’:
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_yacc.cc:46159:1: warning: label ‘yyexhaustedlab’ defined but not used [-Wunused-label]
46159 | yyexhaustedlab:
      | ^~~~~~~~~~~~~~
/home/mdcallag/b/mysql-8.0.28/sql/parser_yystype.h:341:7: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
  341 | union YYSTYPE {
      |       ^
/home/mdcallag/b/mysql-8.0.28/storage/innobase/include/fts0pars.h:50: note: a different type is defined in another translation unit
   50 | typedef union YYSTYPE
      | 
/home/mdcallag/b/mysql-8.0.28/sql/parser_yystype.h:342:17: note: the first difference of corresponding definitions is field ‘lexer’
  342 |   Lexer_yystype lexer;  // terminal values from the lexical scanner
      |                 ^
../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_yacc.cc:559: warning: type ‘yysymbol_kind_t’ violates the C++ One Definition Rule [-Wodr]
  559 | enum yysymbol_kind_t
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_hints.yy.cc:136: note: an enum with different value name is defined in another translation unit
  136 | enum yysymbol_kind_t
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_yacc.cc:565: note: name ‘YYSYMBOL_ABORT_SYM’ differs from name ‘YYSYMBOL_MAX_EXECUTION_TIME_HINT’ defined in another translation unit
  565 |   YYSYMBOL_ABORT_SYM = 3,                  /* ABORT_SYM  */
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_hints.yy.cc:142: note: mismatching definition
  142 |   YYSYMBOL_MAX_EXECUTION_TIME_HINT = 3,    /* MAX_EXECUTION_TIME_HINT  */
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_yacc.h:51: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   51 |   enum yytokentype
      | 
/home/mdcallag/b/mysql-8.0.28/storage/innobase/include/pars0grm.h:46: note: an enum with different value name is defined in another translation unit
   46 | enum yytokentype {
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_lto/sql/sql_yacc.h:53: note: name ‘YYEMPTY’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   53 |     YYEMPTY = -2,
      | 
/home/mdcallag/b/mysql-8.0.28/storage/innobase/include/pars0grm.h:47: note: mismatching definition
   47 |   PARS_INT_LIT = 258,
      | 
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1133:3: warning: ‘mrg_info.errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1133 |   if (mrg_info.errkey >= (int)table_share->keys) {
      |   ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.errkey’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1143:36: warning: ‘mrg_info.reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1143 |   stats.mean_rec_length = mrg_info.reclength;
      |                                    ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.reclength’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1176:17: warning: ‘mrg_info.dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1176 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.dupp_key_pos’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1132:26: warning: ‘mrg_info.data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1132 |   stats.data_file_length = mrg_info.data_file_length;
      |                          ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1123:16: note: ‘mrg_info.data_file_length’ was declared here
 1123 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1123:16: warning: ‘mrg_info.deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-8.0.28/storage/myisammrg/ha_myisammrg.cc:1123:16: warning: ‘mrg_info.records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
In function ‘strncpy’,
    inlined from ‘build_name’ at /home/mdcallag/b/mysql-8.0.28/storage/innobase/arch/arch0arch.cc:492:12,
    inlined from ‘get_file_name’ at /home/mdcallag/b/mysql-8.0.28/storage/innobase/include/arch0arch.h:1131:26,
    inlined from ‘get_files’ at /home/mdcallag/b/mysql-8.0.28/storage/innobase/arch/arch0log.cc:151:27:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:95:34: warning: ‘__builtin_strncpy’ specified bound 98 equals destination size [-Wstringop-truncation]
   95 |   return __builtin___strncpy_chk (__dest, __src, __len,
      |                                  ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2216:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1148:73:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:2012:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1150:72:
/home/mdcallag/b/mysql-8.0.28/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2148:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1154:75:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:1960:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1156:74:
/home/mdcallag/b/mysql-8.0.28/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2177:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1160:73:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:1987:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1162:72:
/home/mdcallag/b/mysql-8.0.28/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2198:45,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1166:77:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.h:2071:46: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 2071 |       : Item_func(pos, opt_list), udf(udf_arg) {
      |                                              ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:1923:54,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-8.0.28/sql/item_sum.h:2051:44,
    inlined from ‘create’ at /home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1168:76:
/home/mdcallag/b/mysql-8.0.28/sql/item_sum.cc:430:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  430 |     : Item_func(pos, opt_list), m_window(w) {}
      |                                           ^
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-8.0.28/sql/item_func.cc:329: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  329 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | 
/home/mdcallag/b/mysql-8.0.28/sql/item_create.cc:1143:7: note: ‘pos’ declared here
 1143 |   POS pos;
      |       ^
In function ‘strncpy’,
    inlined from ‘create_and_init_vio’ at /home/mdcallag/b/mysql-8.0.28/sql/conn_handler/socket_connection.cc:220:12:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:95:34: warning: ‘__builtin_strncpy’ writing 255 bytes into a region of size 0 overflows the destination [-Wstringop-overflow=]
   95 |   return __builtin___strncpy_chk (__dest, __src, __len,
      |                                  ^
