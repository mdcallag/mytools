In function ‘strncat’,
    inlined from ‘my_crypt_genhash’ at /home/mdcallag/b/mysql-8.0.28/mysys/crypt_genhash_impl.cc:383:16,
    inlined from ‘my_make_scrambled_password’ at /home/mdcallag/b/mysql-8.0.28/sql/auth/password.cc:188:19:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:138:34: warning: ‘__builtin_strncat’ output may be truncated copying between 0 and 20 bytes from a string of length 20 [-Wstringop-truncation]
  138 |   return __builtin___strncat_chk (__dest, __src, __len,
      |                                  ^
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_yacc.cc: In function ‘int MYSQLparse(THD*, Parse_tree_root**)’:
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_yacc.cc:46159:1: warning: label ‘yyexhaustedlab’ defined but not used [-Wunused-label]
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
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_yacc.cc:559: warning: type ‘yysymbol_kind_t’ violates the C++ One Definition Rule [-Wodr]
  559 | enum yysymbol_kind_t
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_hints.yy.cc:136: note: an enum with different value name is defined in another translation unit
  136 | enum yysymbol_kind_t
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_yacc.cc:565: note: name ‘YYSYMBOL_ABORT_SYM’ differs from name ‘YYSYMBOL_MAX_EXECUTION_TIME_HINT’ defined in another translation unit
  565 |   YYSYMBOL_ABORT_SYM = 3,                  /* ABORT_SYM  */
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_hints.yy.cc:142: note: mismatching definition
  142 |   YYSYMBOL_MAX_EXECUTION_TIME_HINT = 3,    /* MAX_EXECUTION_TIME_HINT  */
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_yacc.h:51: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   51 |   enum yytokentype
      | 
/home/mdcallag/b/mysql-8.0.28/storage/innobase/include/pars0grm.h:46: note: an enum with different value name is defined in another translation unit
   46 | enum yytokentype {
      | 
/home/mdcallag/b/mysql-8.0.28/build.rel_o2_lto/sql/sql_yacc.h:53: note: name ‘YYEMPTY’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   53 |     YYEMPTY = -2,
      | 
/home/mdcallag/b/mysql-8.0.28/storage/innobase/include/pars0grm.h:47: note: mismatching definition
   47 |   PARS_INT_LIT = 258,
      | 
