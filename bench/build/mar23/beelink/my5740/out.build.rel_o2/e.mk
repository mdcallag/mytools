/home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/evutil.c:209:21: warning: argument 4 of type ‘int[2]’ with mismatched bound [-Warray-parameter=]
  209 |     evutil_socket_t fd[2])
In file included from /home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/evutil.c:81:
/home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/include/event2/util.h:310:25: note: previously declared as ‘int[]’
  310 | #define evutil_socket_t int
/home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/util-internal.h:311:47: note: in expansion of macro ‘evutil_socket_t’
  311 | int evutil_ersatz_socketpair_(int, int , int, evutil_socket_t[]);
      |                                               ^~~~~~~~~~~~~~~
