/home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/evutil.c:209:21: warning: argument 4 of type ‘int[2]’ with mismatched bound [-Warray-parameter=]
  209 |     evutil_socket_t fd[2])
In file included from /home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/evutil.c:81:
/home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/include/event2/util.h:310:25: note: previously declared as ‘int[]’
  310 | #define evutil_socket_t int
/home/mdcallag/b/mysql-5.7.40/extra/libevent/libevent-2.1.11-stable/util-internal.h:311:47: note: in expansion of macro ‘evutil_socket_t’
  311 | int evutil_ersatz_socketpair_(int, int , int, evutil_socket_t[]);
      |                                               ^~~~~~~~~~~~~~~
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:100:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:489:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:100:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:852:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:100:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:1134:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:522:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:507:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:884:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:869:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:188:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:173:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:41:73:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:58:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:59:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:189:56,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:60:35:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:74:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:75:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:189:56,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:76:36:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:91:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:92:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:189:56,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:93:41:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:100:37,
    inlined from ‘protobuf_RegisterTypes’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:105:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_RegisterTypes’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘generated_pool’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:920:23,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:917:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:136:23,
    inlined from ‘Init’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:152:22,
    inlined from ‘GetSourceLocation’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:889:31,
    inlined from ‘GetSourceLocation’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:2128:35:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:915:24: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  915 |   ~FunctionClosure1() {}
      |                        ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h: In member function ‘GetSourceLocation’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:135:38: note: declared here
  135 |     internal::FunctionClosure1<Arg*> func(init_func, false, arg);
      |                                      ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘InternalAddGeneratedFile’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1017:24:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘InternalAddGeneratedFile’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘NewPlaceholderFile’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:3077:52,
    inlined from ‘BuildFile’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:3414:40:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘BuildFile’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘NewPlaceholder’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:2990:52,
    inlined from ‘LookupSymbol’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:2963:28:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘LookupSymbol’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘BuildFieldOrExtension’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:3776:68:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘BuildFieldOrExtension’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:978:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1679:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1021:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1004:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:98:73:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:113:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:114:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:138:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:139:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:160:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:161:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:176:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:177:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:199:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:200:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:216:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:217:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:233:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:234:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:250:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:251:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:267:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:268:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:285:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:286:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:311:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:312:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:330:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:331:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:351:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:352:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:369:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:370:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:385:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:386:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:401:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:402:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:417:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:418:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:438:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:439:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:454:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:455:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:469:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:470:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:487:57:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:488:60:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AssignDesc_google_2fprotobuf_2fdescriptor_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘protobuf_RegisterTypes’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:501:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_RegisterTypes’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1953:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2483:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3200:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3443:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3775:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4106:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4438:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1992:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1976:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3231:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3216:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3809:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3793:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4140:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4124:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4473:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4457:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4848:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:5610:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:5975:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6505:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6834:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7113:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7392:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7671:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7954:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7703:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7688:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4913:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4898:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6035:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6020:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8473:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8903:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:9122:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8507:47,
    inlined from ‘__ct_base ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8492:13:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘__ct_base ’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘GetPrototypeNoLock’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/dynamic_message.cc:550:61:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetPrototypeNoLock’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44,
    inlined from ‘GetPrototypeNoLock’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/dynamic_message.cc:551:45:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetPrototypeNoLock’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘ConstructDefaultOneofInstance’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/dynamic_message.cc:730:66,
    inlined from ‘GetPrototypeNoLock’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/dynamic_message.cc:660:34:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetPrototypeNoLock’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitGeneratedPoolOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:978:37,
    inlined from ‘generated_pool’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:984:24,
    inlined from ‘GetPrototype’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:309:61:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetPrototype’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘InternalRegisterGeneratedFile’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:347:53:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘InternalRegisterGeneratedFile’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘InternalRegisterGeneratedMessage’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:353:53:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘InternalRegisterGeneratedMessage’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitLogSilencerCountOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:138:17,
    inlined from ‘Finish’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:184:29:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘Finish’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitShutdownFunctionsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:356:17,
    inlined from ‘OnShutdown’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:360:28:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘OnShutdown’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1679:33,
    inlined from ‘GetDescriptor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.h:292:63,
    inlined from ‘CollectExtensions.constprop’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/java/java_file.cc:112:77:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘CollectExtensions.constprop’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:496:37,
    inlined from ‘FieldDescriptorProto_Type_descriptor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2494:33,
    inlined from ‘FieldDescriptorProto_Type_Name’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:87:50,
    inlined from ‘SetPrimitiveVariables.isra’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/cpp/cpp_primitive_field.cc:94:88:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘SetPrimitiveVariables.isra’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:874:8,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘NameOfEnum’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:74:37,
    inlined from ‘NameOfEnum’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:72:15,
    inlined from ‘FieldDescriptorProto_Type_Name’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:87:50,
    inlined from ‘SetPrimitiveVariables.isra’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/cpp/cpp_primitive_field.cc:94:88:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘SetPrimitiveVariables.isra’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147:6: warning: type ‘enum_mysql_show_type’ violates the C++ One Definition Rule [-Wodr]
  147 | enum enum_mysql_show_type
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147:6: note: an enum with different number of values is defined in another translation unit
  147 | enum enum_mysql_show_type
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168:6: warning: type ‘enum_mysql_show_scope’ violates the C++ One Definition Rule [-Wodr]
  168 | enum enum_mysql_show_scope
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168:6: note: an enum with different number of values is defined in another translation unit
  168 | enum enum_mysql_show_scope
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147:6: warning: type ‘enum_mysql_show_type’ violates the C++ One Definition Rule [-Wodr]
  147 | enum enum_mysql_show_type
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147:6: note: an enum with different number of values is defined in another translation unit
  147 | enum enum_mysql_show_type
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168:6: warning: type ‘enum_mysql_show_scope’ violates the C++ One Definition Rule [-Wodr]
  168 | enum enum_mysql_show_scope
      |      ^
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168:6: note: an enum with different number of values is defined in another translation unit
  168 | enum enum_mysql_show_scope
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc: In member function ‘SwapOneofField’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.h:1642:28: warning: ‘field1’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1642 |   return kTypeToCppTypeMap[type_];
      |                            ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:430:26: note: ‘field1’ was declared here
  430 |   const FieldDescriptor* field1;
      |                          ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:516:28: warning: ‘temp_message’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  516 |         SetAllocatedMessage(message2, temp_message, field1);
      |                            ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:426:12: note: ‘temp_message’ was declared here
  426 |   Message* temp_message;
      |            ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
In function ‘my_raw_free’,
    inlined from ‘my_free’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_malloc.c:145:3,
    inlined from ‘var_free’ at /home/mdcallag/b/mysql-5.7.40/client/mysqltest.cc:2242:12,
    inlined from ‘do_block.isra’ at /home/mdcallag/b/mysql-5.7.40/client/mysqltest.cc:6465:13:
/home/mdcallag/b/mysql-5.7.40/mysys/my_malloc.c:302:3: warning: ‘free’ called on unallocated object ‘v2’ [-Wfree-nonheap-object]
  302 |   free(ptr);
      |   ^
/home/mdcallag/b/mysql-5.7.40/mysys/my_malloc.c: In function ‘do_block.isra’:
/home/mdcallag/b/mysql-5.7.40/client/mysqltest.cc:6423:9: note: declared here
 6423 |     VAR v2;
      |         ^
In function ‘my_raw_free’,
    inlined from ‘my_free’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_malloc.c:145:3,
    inlined from ‘var_free’ at /home/mdcallag/b/mysql-5.7.40/client/mysqltest.cc:2242:12,
    inlined from ‘do_block.isra’ at /home/mdcallag/b/mysql-5.7.40/client/mysqltest.cc:6505:11:
/home/mdcallag/b/mysql-5.7.40/mysys/my_malloc.c:302:3: warning: ‘free’ called on unallocated object ‘v’ [-Wfree-nonheap-object]
  302 |   free(ptr);
      |   ^
/home/mdcallag/b/mysql-5.7.40/mysys/my_malloc.c: In function ‘do_block.isra’:
/home/mdcallag/b/mysql-5.7.40/client/mysqltest.cc:6324:7: note: declared here
 6324 |   VAR v;
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/client/mysql_config_editor.cc: In function ‘generate_login_key’:
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:55:53: warning: ‘rnd.max_value’ may be used uninitialized [-Wmaybe-uninitialized]
   55 |   rand_st->seed1= (rand_st->seed1*3+rand_st->seed2) % rand_st->max_value;
      |                                                     ^
/home/mdcallag/b/mysql-5.7.40/client/mysql_config_editor.cc:1402:22: note: ‘rnd.max_value’ was declared here
 1402 |   struct rand_struct rnd;
      |                      ^
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:57:61: warning: ‘rnd.max_value_dbl’ may be used uninitialized [-Wmaybe-uninitialized]
   57 |   return (((double) rand_st->seed1) / rand_st->max_value_dbl);
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/client/mysql_config_editor.cc:1402:22: note: ‘rnd.max_value_dbl’ was declared here
 1402 |   struct rand_struct rnd;
      |                      ^
/home/mdcallag/b/mysql-5.7.40/client/mysql_config_editor.cc:1402:22: warning: ‘rnd.seed2’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:55:34: warning: ‘rnd.seed1’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   55 |   rand_st->seed1= (rand_st->seed1*3+rand_st->seed2) % rand_st->max_value;
      |                                  ^
/home/mdcallag/b/mysql-5.7.40/client/mysql_config_editor.cc:1402:22: note: ‘rnd.seed1’ was declared here
 1402 |   struct rand_struct rnd;
      |                      ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/client/mysql_install_db.cc: In function ‘main’:
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:55:53: warning: ‘srnd.max_value’ may be used uninitialized [-Wmaybe-uninitialized]
   55 |   rand_st->seed1= (rand_st->seed1*3+rand_st->seed2) % rand_st->max_value;
      |                                                     ^
/home/mdcallag/b/mysql-5.7.40/client/auth_utils.cc:128:15: note: ‘srnd.max_value’ was declared here
  128 |   rand_struct srnd;
      |               ^
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:57:61: warning: ‘srnd.max_value_dbl’ may be used uninitialized [-Wmaybe-uninitialized]
   57 |   return (((double) rand_st->seed1) / rand_st->max_value_dbl);
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/client/auth_utils.cc:128:15: note: ‘srnd.max_value_dbl’ was declared here
  128 |   rand_struct srnd;
      |               ^
/home/mdcallag/b/mysql-5.7.40/client/auth_utils.cc:128:15: warning: ‘srnd.seed2’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:55:34: warning: ‘srnd.seed1’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   55 |   rand_st->seed1= (rand_st->seed1*3+rand_st->seed2) % rand_st->max_value;
      |                                  ^
/home/mdcallag/b/mysql-5.7.40/client/auth_utils.cc:128:15: note: ‘srnd.seed1’ was declared here
  128 |   rand_struct srnd;
      |               ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:1465:7: warning: type ‘struct THD’ violates the C++ One Definition Rule [-Wodr]
 1465 | class THD :public MDL_context_owner,
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:1465: note: a different type is defined in another translation unit
 1465 | class THD :public MDL_context_owner,
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:1837:14: note: the first difference of corresponding definitions is field ‘m_SSL’
 1837 |   SSL_handle m_SSL;
      |              ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:1837: note: a field of same name but different type is defined in another translation unit
 1837 |   SSL_handle m_SSL;
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:1465:7: note: type ‘struct SSL’ should match type ‘void’
 1465 | class THD :public MDL_context_owner,
      |       ^
/home/mdcallag/b/mysql-5.7.40/include/violite.h:267:8: warning: type ‘struct st_vio’ violates the C++ One Definition Rule [-Wodr]
  267 | struct st_vio
      |        ^
/home/mdcallag/b/mysql-5.7.40/include/violite.h:267: note: a different type is defined in another translation unit
  267 | struct st_vio
      | 
/home/mdcallag/b/mysql-5.7.40/include/violite.h:323:12: note: the first difference of corresponding definitions is field ‘ssl_arg’
  323 |   void    *ssl_arg;
      |            ^
/home/mdcallag/b/mysql-5.7.40/include/violite.h:267: note: a type with different number of fields is defined in another translation unit
  267 | struct st_vio
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1586: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
 1586 | union YYSTYPE {
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/fts0pars.h:56: note: a different type is defined in another translation unit
   56 | typedef union YYSTYPE
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1590: note: the first difference of corresponding definitions is field ‘hint_type’
 1590 |   opt_hints_enum hint_type;
      | 
../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
../storage/innobase/lexyy.cc:198: warning: type ‘struct yy_buffer_state’ violates the C++ One Definition Rule [-Wodr]
../storage/innobase/fts0tlex.cc:211: note: a different type is defined in another translation unit
../storage/innobase/lexyy.cc:213: note: the first difference of corresponding definitions is field ‘yy_n_chars’
../storage/innobase/fts0tlex.cc:226: note: a field of same name but different type is defined in another translation unit
../storage/innobase/lexyy.cc:198: note: type ‘yy_size_t’ should match type ‘int’
/home/mdcallag/b/mysql-5.7.40/storage/innobase/handler/ha_innodb.h:542: warning: ‘thd_charset’ violates the C++ One Definition Rule [-Wodr]
  542 | CHARSET_INFO *thd_charset(MYSQL_THD thd);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844: note: return value type mismatch
 3844 | extern "C" const struct charset_info_st *thd_charset(MYSQL_THD thd)
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844: note: type ‘const struct charset_info_st’ itself violates the C++ One Definition Rule
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844: note: ‘thd_charset’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: warning: type ‘enum_mysql_show_type’ violates the C++ One Definition Rule [-Wodr]
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: note: an enum with different number of values is defined in another translation unit
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: warning: type ‘enum_mysql_show_scope’ violates the C++ One Definition Rule [-Wodr]
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: note: an enum with different number of values is defined in another translation unit
  168 | enum enum_mysql_show_scope
      | 
/var/lib/pb2/sb_1-8235782-1661831589.28/dist_GPL/sql/sql_yacc.cc:533: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:47: note: an enum with different value name is defined in another translation unit
   47 |    enum yytokentype {
      | 
/var/lib/pb2/sb_1-8235782-1661831589.28/dist_GPL/sql/sql_yacc.cc:535: note: name ‘ABORT_SYM’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:48: note: mismatching definition
   48 |      PARS_INT_LIT = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1586:7: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
 1586 | union YYSTYPE {
      |       ^
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/fts0pars.h:56: note: a different type is defined in another translation unit
   56 | typedef union YYSTYPE
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1590:18: note: the first difference of corresponding definitions is field ‘hint_type’
 1590 |   opt_hints_enum hint_type;
      |                  ^
../../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
../../storage/innobase/fts0blex.cc:211: warning: type ‘struct yy_buffer_state’ violates the C++ One Definition Rule [-Wodr]
../../storage/innobase/lexyy.cc:198: note: a different type is defined in another translation unit
../../storage/innobase/fts0blex.cc:226: note: the first difference of corresponding definitions is field ‘yy_n_chars’
../../storage/innobase/lexyy.cc:213: note: a field of same name but different type is defined in another translation unit
../../storage/innobase/fts0blex.cc:211: note: type ‘int’ should match type ‘yy_size_t’
/home/mdcallag/b/mysql-5.7.40/include/mysql/service_thd_engine_lock.h:48: warning: ‘thd_report_row_lock_wait’ violates the C++ One Definition Rule [-Wodr]
   48 |   void thd_report_row_lock_wait(THD* self, THD *wait_for);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:4055:6: note: type mismatch in parameter 2
 4055 | void thd_report_row_lock_wait(THD *thd_wait_for)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:4055:6: note: ‘thd_report_row_lock_wait’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/storage/innobase/handler/ha_innodb.h:542: warning: ‘thd_charset’ violates the C++ One Definition Rule [-Wodr]
  542 | CHARSET_INFO *thd_charset(MYSQL_THD thd);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: return value type mismatch
 3844 | extern "C" const struct charset_info_st *thd_charset(MYSQL_THD thd)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: type ‘const struct charset_info_st’ itself violates the C++ One Definition Rule
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: ‘thd_charset’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: warning: type ‘enum_mysql_show_scope’ violates the C++ One Definition Rule [-Wodr]
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: note: an enum with different number of values is defined in another translation unit
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: warning: type ‘enum_mysql_show_type’ violates the C++ One Definition Rule [-Wodr]
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: note: an enum with different number of values is defined in another translation unit
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_yacc.h:46: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   46 |   enum yytokentype
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:47: note: an enum with different value name is defined in another translation unit
   47 |    enum yytokentype {
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_yacc.h:48: note: name ‘ABORT_SYM’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   48 |     ABORT_SYM = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:48: note: mismatching definition
   48 |      PARS_INT_LIT = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/sql/table.cc: In member function ‘refix_gc_items’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3424:11: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3424 |   mem_root=  set->mem_root;
      |           ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3425:12: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3425 |   free_list= set->free_list;
      |            ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc: In function ‘make_schema_select’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5289:6: warning: ‘MEM[(struct LEX_CSTRING *)&table].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5289 |     :table(table_arg), sel(NULL)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:18: note: ‘MEM[(struct LEX_CSTRING *)&table].length’ was declared here
 8142 |   LEX_STRING db, table;
      |                  ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5294:9: warning: ‘MEM[(struct LEX_CSTRING *)&db].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5294 |       db= db_arg;
      |         ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:14: note: ‘MEM[(struct LEX_CSTRING *)&db].length’ was declared here
 8142 |   LEX_STRING db, table;
      |              ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_tiny’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4394:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 2 bytes from a region of size 1 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_tiny’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4393:8: note: source object ‘v’ of size 1
 4393 |   char v= (char) value;
      |        ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_short’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4403:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 3 bytes from a region of size 2 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_short’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4402:9: note: source object ‘v’ of size 2
 4402 |   int16 v= (int16) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_long’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4412:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_long’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4411:9: note: source object ‘v’ of size 4
 4411 |   int32 v= (int32) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_longlong’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4421:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_longlong’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4420:9: note: source object ‘v’ of size 8
 4420 |   int64 v= (int64) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4495:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4493:34: note: source object ‘value’ of size 4
 4493 | bool Protocol_local::store(float value, uint32 decimals, String *buffer)
      |                                  ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4503:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4501:35: note: source object ‘value’ of size 8
 4501 | bool Protocol_local::store(double value, uint32 decimals, String *buffer)
      |                                   ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc: In function ‘make_schema_select’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5289:6: warning: ‘MEM[(struct LEX_CSTRING *)&table].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5289 |     :table(table_arg), sel(NULL)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:18: note: ‘MEM[(struct LEX_CSTRING *)&table].length’ was declared here
 8142 |   LEX_STRING db, table;
      |                  ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5294:9: warning: ‘MEM[(struct LEX_CSTRING *)&db].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5294 |       db= db_arg;
      |         ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:14: note: ‘MEM[(struct LEX_CSTRING *)&db].length’ was declared here
 8142 |   LEX_STRING db, table;
      |              ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_timer.cc: In function ‘thd_timer_reset’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_timer.cc:218:15: warning: ‘state’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  218 |   int status, state;
      |               ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc: In member function ‘refix_gc_items’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3424:11: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3424 |   mem_root=  set->mem_root;
      |           ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3425:12: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3425 |   free_list= set->free_list;
      |            ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_tiny’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4394:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 2 bytes from a region of size 1 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_tiny’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4393:8: note: source object ‘v’ of size 1
 4393 |   char v= (char) value;
      |        ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_short’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4403:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 3 bytes from a region of size 2 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_short’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4402:9: note: source object ‘v’ of size 2
 4402 |   int16 v= (int16) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_long’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4412:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_long’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4411:9: note: source object ‘v’ of size 4
 4411 |   int32 v= (int32) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_longlong’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4421:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_longlong’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4420:9: note: source object ‘v’ of size 8
 4420 |   int64 v= (int64) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4495:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4493:34: note: source object ‘value’ of size 4
 4493 | bool Protocol_local::store(float value, uint32 decimals, String *buffer)
      |                                  ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4503:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4501:35: note: source object ‘value’ of size 8
 4501 | bool Protocol_local::store(double value, uint32 decimals, String *buffer)
      |                                   ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1586:7: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
 1586 | union YYSTYPE {
      |       ^
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/fts0pars.h:56: note: a different type is defined in another translation unit
   56 | typedef union YYSTYPE
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1590:18: note: the first difference of corresponding definitions is field ‘hint_type’
 1590 |   opt_hints_enum hint_type;
      |                  ^
../../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
../../storage/innobase/fts0blex.cc:211: warning: type ‘struct yy_buffer_state’ violates the C++ One Definition Rule [-Wodr]
../../storage/innobase/lexyy.cc:198: note: a different type is defined in another translation unit
../../storage/innobase/fts0blex.cc:226: note: the first difference of corresponding definitions is field ‘yy_n_chars’
../../storage/innobase/lexyy.cc:213: note: a field of same name but different type is defined in another translation unit
../../storage/innobase/fts0blex.cc:211: note: type ‘int’ should match type ‘yy_size_t’
/home/mdcallag/b/mysql-5.7.40/include/mysql/service_thd_engine_lock.h:48: warning: ‘thd_report_row_lock_wait’ violates the C++ One Definition Rule [-Wodr]
   48 |   void thd_report_row_lock_wait(THD* self, THD *wait_for);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:4055:6: note: type mismatch in parameter 2
 4055 | void thd_report_row_lock_wait(THD *thd_wait_for)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:4055:6: note: ‘thd_report_row_lock_wait’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/storage/innobase/handler/ha_innodb.h:542: warning: ‘thd_charset’ violates the C++ One Definition Rule [-Wodr]
  542 | CHARSET_INFO *thd_charset(MYSQL_THD thd);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: return value type mismatch
 3844 | extern "C" const struct charset_info_st *thd_charset(MYSQL_THD thd)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: type ‘const struct charset_info_st’ itself violates the C++ One Definition Rule
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: ‘thd_charset’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: warning: type ‘enum_mysql_show_scope’ violates the C++ One Definition Rule [-Wodr]
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: note: an enum with different number of values is defined in another translation unit
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: warning: type ‘enum_mysql_show_type’ violates the C++ One Definition Rule [-Wodr]
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: note: an enum with different number of values is defined in another translation unit
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_yacc.h:46: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   46 |   enum yytokentype
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:47: note: an enum with different value name is defined in another translation unit
   47 |    enum yytokentype {
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_yacc.h:48: note: name ‘ABORT_SYM’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   48 |     ABORT_SYM = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:48: note: mismatching definition
   48 |      PARS_INT_LIT = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1586:7: warning: type ‘union YYSTYPE’ violates the C++ One Definition Rule [-Wodr]
 1586 | union YYSTYPE {
      |       ^
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/fts0pars.h:56: note: a different type is defined in another translation unit
   56 | typedef union YYSTYPE
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_lex.h:1590:18: note: the first difference of corresponding definitions is field ‘hint_type’
 1590 |   opt_hints_enum hint_type;
      |                  ^
../../storage/innobase/fts0pars.y:62: note: a field with different name is defined in another translation unit
../../storage/innobase/fts0blex.cc:211: warning: type ‘struct yy_buffer_state’ violates the C++ One Definition Rule [-Wodr]
../../storage/innobase/lexyy.cc:198: note: a different type is defined in another translation unit
../../storage/innobase/fts0blex.cc:226: note: the first difference of corresponding definitions is field ‘yy_n_chars’
../../storage/innobase/lexyy.cc:213: note: a field of same name but different type is defined in another translation unit
../../storage/innobase/fts0blex.cc:211: note: type ‘int’ should match type ‘yy_size_t’
/home/mdcallag/b/mysql-5.7.40/include/mysql/service_thd_engine_lock.h:48: warning: ‘thd_report_row_lock_wait’ violates the C++ One Definition Rule [-Wodr]
   48 |   void thd_report_row_lock_wait(THD* self, THD *wait_for);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:4055:6: note: type mismatch in parameter 2
 4055 | void thd_report_row_lock_wait(THD *thd_wait_for)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:4055:6: note: ‘thd_report_row_lock_wait’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/storage/innobase/handler/ha_innodb.h:542: warning: ‘thd_charset’ violates the C++ One Definition Rule [-Wodr]
  542 | CHARSET_INFO *thd_charset(MYSQL_THD thd);
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: return value type mismatch
 3844 | extern "C" const struct charset_info_st *thd_charset(MYSQL_THD thd)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: type ‘const struct charset_info_st’ itself violates the C++ One Definition Rule
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3844:42: note: ‘thd_charset’ was previously declared here
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: warning: type ‘enum_mysql_show_scope’ violates the C++ One Definition Rule [-Wodr]
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:168: note: an enum with different number of values is defined in another translation unit
  168 | enum enum_mysql_show_scope
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: warning: type ‘enum_mysql_show_type’ violates the C++ One Definition Rule [-Wodr]
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/include/mysql/plugin.h:147: note: an enum with different number of values is defined in another translation unit
  147 | enum enum_mysql_show_type
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_yacc.h:46: warning: type ‘yytokentype’ violates the C++ One Definition Rule [-Wodr]
   46 |   enum yytokentype
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:47: note: an enum with different value name is defined in another translation unit
   47 |    enum yytokentype {
      | 
/home/mdcallag/b/mysql-5.7.40/sql/sql_yacc.h:48: note: name ‘ABORT_SYM’ differs from name ‘PARS_INT_LIT’ defined in another translation unit
   48 |     ABORT_SYM = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/storage/innobase/include/pars0grm.h:48: note: mismatching definition
   48 |      PARS_INT_LIT = 258,
      | 
/home/mdcallag/b/mysql-5.7.40/sql/table.cc: In member function ‘refix_gc_items’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3424:11: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3424 |   mem_root=  set->mem_root;
      |           ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3425:12: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3425 |   free_list= set->free_list;
      |            ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc: In function ‘make_schema_select’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5289:6: warning: ‘MEM[(struct LEX_CSTRING *)&table].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5289 |     :table(table_arg), sel(NULL)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:18: note: ‘MEM[(struct LEX_CSTRING *)&table].length’ was declared here
 8142 |   LEX_STRING db, table;
      |                  ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5294:9: warning: ‘MEM[(struct LEX_CSTRING *)&db].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5294 |       db= db_arg;
      |         ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:14: note: ‘MEM[(struct LEX_CSTRING *)&db].length’ was declared here
 8142 |   LEX_STRING db, table;
      |              ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc: In member function ‘refix_gc_items’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3424:11: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3424 |   mem_root=  set->mem_root;
      |           ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3425:12: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3425 |   free_list= set->free_list;
      |            ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc: In function ‘make_schema_select’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5289:6: warning: ‘MEM[(struct LEX_CSTRING *)&table].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5289 |     :table(table_arg), sel(NULL)
      |      ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:18: note: ‘MEM[(struct LEX_CSTRING *)&table].length’ was declared here
 8142 |   LEX_STRING db, table;
      |                  ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.h:5294:9: warning: ‘MEM[(struct LEX_CSTRING *)&db].length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 5294 |       db= db_arg;
      |         ^
/home/mdcallag/b/mysql-5.7.40/sql/sql_show.cc:8142:14: note: ‘MEM[(struct LEX_CSTRING *)&db].length’ was declared here
 8142 |   LEX_STRING db, table;
      |              ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_tiny’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4394:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 2 bytes from a region of size 1 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_tiny’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4393:8: note: source object ‘v’ of size 1
 4393 |   char v= (char) value;
      |        ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_short’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4403:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 3 bytes from a region of size 2 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_short’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4402:9: note: source object ‘v’ of size 2
 4402 |   int16 v= (int16) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_long’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4412:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_long’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4411:9: note: source object ‘v’ of size 4
 4411 |   int32 v= (int32) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_longlong’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4421:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_longlong’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4420:9: note: source object ‘v’ of size 8
 4420 |   int64 v= (int64) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4495:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4493:34: note: source object ‘value’ of size 4
 4493 | bool Protocol_local::store(float value, uint32 decimals, String *buffer)
      |                                  ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4503:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4501:35: note: source object ‘value’ of size 8
 4501 | bool Protocol_local::store(double value, uint32 decimals, String *buffer)
      |                                   ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_tiny’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4394:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 2 bytes from a region of size 1 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_tiny’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4393:8: note: source object ‘v’ of size 1
 4393 |   char v= (char) value;
      |        ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_short’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4403:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 3 bytes from a region of size 2 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_short’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4402:9: note: source object ‘v’ of size 2
 4402 |   int16 v= (int16) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_long’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4412:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_long’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4411:9: note: source object ‘v’ of size 4
 4411 |   int32 v= (int32) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store_longlong’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4421:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store_longlong’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4420:9: note: source object ‘v’ of size 8
 4420 |   int64 v= (int64) value;
      |         ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4495:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 5 bytes from a region of size 4 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4493:34: note: source object ‘value’ of size 4
 4493 | bool Protocol_local::store(float value, uint32 decimals, String *buffer)
      |                                  ^
In function ‘memcpy’,
    inlined from ‘memdup_root’ at /home/mdcallag/b/mysql-5.7.40/mysys/my_alloc.c:515:5,
    inlined from ‘store_column’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4351:45,
    inlined from ‘store’ at /home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4503:22:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:29:10: warning: ‘__builtin_memcpy’ reading 9 bytes from a region of size 8 [-Wstringop-overread]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ^
/usr/include/x86_64-linux-gnu/bits/string_fortified.h: In member function ‘store’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_prepare.cc:4501:35: note: source object ‘value’ of size 8
 4501 | bool Protocol_local::store(double value, uint32 decimals, String *buffer)
      |                                   ^
