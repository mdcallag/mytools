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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:188:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:173:13,
    inlined from ‘GeneratePluginOutput’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/command_line_interface.cc:1288:24:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GeneratePluginOutput’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:522:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:507:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_file’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.h:866:19,
    inlined from ‘MergePartialFromCodedStream’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:965:11:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergePartialFromCodedStream’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:188:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:173:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:225:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:522:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:507:13,
    inlined from ‘protobuf_AddDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:505:1:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘protobuf_AddDesc_google_2fprotobuf_2fcompiler_2fplugin_2eproto’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:522:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:507:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:567:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:884:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:869:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:921:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:522:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:507:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:1097:18,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/plugin.pb.cc:1091:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitLogSilencerCountOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:138:17,
    inlined from ‘Finish’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:184:29,
    inlined from ‘operator=’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:203:15,
    inlined from ‘GenerateMergeFromCodedStreamWithPacking’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/cpp/cpp_field.cc:88:3:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GenerateMergeFromCodedStreamWithPacking’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitLogSilencerCountOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:138:17,
    inlined from ‘Finish’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:184:29,
    inlined from ‘operator=’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:203:15,
    inlined from ‘ReportUnexpectedPackedFieldsCall’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/java/java_field.cc:133:3,
    inlined from ‘GenerateParsingCodeFromPacked’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/java/java_field.cc:143:35:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GenerateParsingCodeFromPacked’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitLogSilencerCountOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:138:17,
    inlined from ‘Finish’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:184:29,
    inlined from ‘operator=’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:203:15,
    inlined from ‘IsReferenceType’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/java/java_helpers.cc:598:3,
    inlined from ‘SetPrimitiveVariables’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/java/java_primitive_field.cc:100:22:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘SetPrimitiveVariables’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3809:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3793:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_value’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:4365:20,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1688:21:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_field’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3537:20,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1606:21:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3231:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3216:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_oneof_decl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3687:25,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1609:26:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_enum_type’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3627:24,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1615:25:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_extension’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3567:24,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1623:25:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4473:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4457:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_method’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:4661:21,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1709:22:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_enum_type’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3233:24,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1582:25:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4140:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4124:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_service’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3263:22,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1585:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_extension’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3293:24,
    inlined from ‘CopyTo’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.cc:1588:25:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘CopyTo’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:920:23,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘Add’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘Add’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1992:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2031:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2654:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3231:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3216:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3268:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3516:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3809:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3793:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3730:19:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2425:19:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2426:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2428:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3231:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3216:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2430:24:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3477:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3461:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1613:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4140:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4124:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1614:21:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2599:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:2583:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:1615:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3809:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3793:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3849:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4140:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4124:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4179:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4473:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4457:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4520:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:5926:34:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4913:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4898:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4966:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6035:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6020:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6077:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4473:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4457:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:4393:20:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7703:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7688:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7741:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7703:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7688:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8415:18:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8507:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8492:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8548:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:6789:34:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘Add’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7072:34:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7351:34:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:930:23,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1167:47,
    inlined from ‘MergeFrom’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7630:34:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘MergeFrom’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7991:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:7976:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:8039:14:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘New’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘generated_factory’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘InitLogSilencerCountOnce’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:138:17,
    inlined from ‘Finish’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:184:29,
    inlined from ‘operator=’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:203:15,
    inlined from ‘WriteAliasedRaw’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/io/zero_copy_stream.cc:49:3:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘WriteAliasedRaw’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit.constprop’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘GoogleOnceInit.constprop’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘GetEmptyString’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_util.h:84:37,
    inlined from ‘SharedCtor’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3231:47,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.cc:3216:13,
    inlined from ‘New’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:362:38,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:905:56,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:900:36,
    inlined from ‘Add’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/repeated_field.h:1124:48,
    inlined from ‘add_oneof_decl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/descriptor.pb.h:3687:25,
    inlined from ‘ParseMessageStatement’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/parser.cc:650:22,
    inlined from ‘ParseMessageBlock.isra’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/compiler/parser.cc:596:31:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘ParseMessageBlock.isra’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/rapid/plugin/x/mysqlxtest_src/mysqlx_protocol.cc: In member function ‘enable_tls’:
/home/mdcallag/b/mysql-5.7.40/rapid/plugin/x/mysqlxtest_src/mysqlx_connection.cc:229:31: warning: ‘error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  229 |     return get_ssl_error(error);
      |                               ^
/home/mdcallag/b/mysql-5.7.40/rapid/plugin/x/mysqlxtest_src/mysqlx_connection.cc:226:17: note: ‘error’ was declared here
  226 |   unsigned long error;
      |                 ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:118:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:415:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:118:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:632:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:118:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:875:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:118:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx.pb.cc:1298:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:578:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:851:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:1378:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:1671:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:1891:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:2111:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:183:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_datatypes.pb.cc:2506:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:129:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:486:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:129:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:706:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:129:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:880:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:129:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:1111:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:129:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_connection.pb.cc:1285:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expect.pb.cc:100:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expect.pb.cc:527:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expect.pb.cc:100:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expect.pb.cc:795:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expect.pb.cc:100:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expect.pb.cc:969:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:982:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:1287:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:1644:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:2048:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:2319:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:2603:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:2896:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:3116:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:223:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_expr.pb.cc:3336:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:930:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:1223:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:1528:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:1803:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:2102:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:2458:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:3041:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:3261:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:3659:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:4151:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:4603:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:5165:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:5690:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:349:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_crud.pb.cc:5960:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_sql.pb.cc:78:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_sql.pb.cc:495:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_sql.pb.cc:78:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_sql.pb.cc:669:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:130:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:531:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:130:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:763:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:130:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:994:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:130:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:1168:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:130:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_session.pb.cc:1342:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:124:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:532:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:124:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:885:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:124:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:1178:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:124:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_notice.pb.cc:1493:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:140:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:383:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:140:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:557:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:140:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:731:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:140:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:1497:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘protobuf_AssignDescriptorsOnce’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:140:37,
    inlined from ‘GetMetadata’ at /home/mdcallag/b/mysql-5.7.40/build.rel_lto/rapid/plugin/x/generated/protobuf/mysqlx_resultset.pb.cc:1715:33:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In member function ‘GetMetadata’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
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
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc: In member function ‘SwapOneofField’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/generated_message_reflection.cc:516:28: warning: ‘field1’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  516 |         SetAllocatedMessage(message2, temp_message, field1);
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
In member function ‘__dt_del ’,
    inlined from ‘Run’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.h:877:30,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:83:17,
    inlined from ‘GoogleOnceInitImpl’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.cc:65:6,
    inlined from ‘GoogleOnceInit’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:127:23,
    inlined from ‘singleton’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:272:37,
    inlined from ‘generated_factory’ at /home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/message.cc:342:44:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc:238:61: warning: ‘operator delete’ called on unallocated object ‘func’ [-Wfree-nonheap-object]
  238 | namespace internal { FunctionClosure0::~FunctionClosure0() {} }
      |                                                             ^
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/common.cc: In function ‘generated_factory’:
/home/mdcallag/b/mysql-5.7.40/extra/protobuf/protobuf-2.6.1/src/google/protobuf/stubs/once.h:126:32: note: declared here
  126 |     internal::FunctionClosure0 func(init_func, false);
      |                                ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
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
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
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
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
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
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:55:36: warning: ‘srnd.seed2’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   55 |   rand_st->seed1= (rand_st->seed1*3+rand_st->seed2) % rand_st->max_value;
      |                                    ^
/home/mdcallag/b/mysql-5.7.40/client/auth_utils.cc:128:15: note: ‘srnd.seed2’ was declared here
  128 |   rand_struct srnd;
      |               ^
/home/mdcallag/b/mysql-5.7.40/mysys_ssl/my_rnd.cc:55:34: warning: ‘srnd.seed1’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   55 |   rand_st->seed1= (rand_st->seed1*3+rand_st->seed2) % rand_st->max_value;
      |                                  ^
/home/mdcallag/b/mysql-5.7.40/client/auth_utils.cc:128:15: note: ‘srnd.seed1’ was declared here
  128 |   rand_struct srnd;
      |               ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
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
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘cli_establish_ssl’:
/home/mdcallag/b/mysql-5.7.40/vio/viosslfactories.c:187:26: warning: ‘ssl_init_error’ may be used uninitialized [-Wmaybe-uninitialized]
  187 |   return ssl_error_string[e];
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3502:30: note: ‘ssl_init_error’ was declared here
 3502 |     enum enum_ssl_init_error ssl_init_error;
      |                              ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1917:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4259:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1432:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4261:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1838:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4265:72:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1376:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4267:71:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1871:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4271:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1405:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4273:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1894:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4277:74:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1479:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4279:73:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1505:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6499:78:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6483:7: note: ‘pos’ declared here
 6483 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2070:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6730:64:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6709:7: note: ‘pos’ declared here
 6709 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2023:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6673:82:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6659:7: note: ‘pos’ declared here
 6659 |   POS pos;
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c: In function ‘mysql_real_connect’:
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3545:7: warning: ‘ssl_error’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3545 |       ERR_error_string_n(ssl_error, buf, 512);
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql-common/client.c:3504:19: note: ‘ssl_error’ was declared here
 3504 |     unsigned long ssl_error;
      |                   ^
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
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ is used uninitialized [-Wuninitialized]
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ is used uninitialized [-Wuninitialized]
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
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
/home/mdcallag/b/mysql-5.7.40/sql/sql_parse.cc: In function ‘reset_statement_timer’:
/home/mdcallag/b/mysql-5.7.40/sql/sql_timer.cc:218:15: warning: ‘state’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  218 |   int status, state;
      |               ^
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
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ is used uninitialized [-Wuninitialized]
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ is used uninitialized [-Wuninitialized]
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
 4803 |         Query_arena backup_arena;
      |                     ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_geofunc.h:206:32,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_geofunc.h:320:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5501:72:
/home/mdcallag/b/mysql-5.7.40/sql/item_strfunc.h:52:26: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
   52 |     :Item_func(pos, a,b,c)
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5478:7: note: ‘pos’ declared here
 5478 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1505:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6499:78:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6483:7: note: ‘pos’ declared here
 6483 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2070:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6730:64:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6709:7: note: ‘pos’ declared here
 6709 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1917:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4259:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1432:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4261:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1838:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4265:72:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1376:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4267:71:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1871:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4271:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1405:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4273:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1894:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4277:74:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1479:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4279:73:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_strfunc.h:1118:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5180:59:
/home/mdcallag/b/mysql-5.7.40/sql/item_strfunc.h:52:26: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
   52 |     :Item_func(pos, a,b,c)
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5172:7: note: ‘pos’ declared here
 5172 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2023:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6673:82:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6659:7: note: ‘pos’ declared here
 6659 |   POS pos;
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql/rpl_mts_submode.cc: In member function ‘get_lwm_timestamp’:
/home/mdcallag/b/mysql-5.7.40/sql/rpl_mts_submode.cc:411:32: warning: ‘ptr_g’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  411 |     last_lwm_timestamp= ptr_g->sequence_number;
      |                                ^
/home/mdcallag/b/mysql-5.7.40/sql/rpl_mts_submode.cc:374:20: note: ‘ptr_g’ was declared here
  374 |   Slave_job_group* ptr_g;
      |                    ^
In function ‘strmake’,
    inlined from ‘relay_log_number_to_name’ at /home/mdcallag/b/mysql-5.7.40/sql/rpl_rli.cc:3010:15,
    inlined from ‘read_and_apply_events’ at /home/mdcallag/b/mysql-5.7.40/sql/rpl_rli_pdb.cc:2053:27:
/home/mdcallag/b/mysql-5.7.40/strings/strmake.c:65:7: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
   65 |   *dst=0;
      |       ^
/home/mdcallag/b/mysql-5.7.40/sql/rpl_rli_pdb.cc: In member function ‘read_and_apply_events’:
/home/mdcallag/b/mysql-5.7.40/sql/rpl_rli_pdb.cc:2048:8: note: at offset 513 into destination object ‘file_name’ of size 513
 2048 |   char file_name[FN_REFLEN+1];
      |        ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1302:3: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1302 |   if (mrg_info.errkey >= (int) table_share->keys)
      |   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1313:35: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1313 |   stats.mean_rec_length= mrg_info.reclength;
      |                                   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1354:17: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1354 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1301:25: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1301 |   stats.data_file_length= mrg_info.data_file_length;
      |                         ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:422:31: warning: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  422 |     stats.auto_increment_value= hp_info.auto_increment;
      |                               ^
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:409:12: note: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ was declared here
  409 |   HEAPINFO hp_info;
      |            ^
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:422:31: warning: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  422 |     stats.auto_increment_value= hp_info.auto_increment;
      |                               ^
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:409:12: note: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ was declared here
  409 |   HEAPINFO hp_info;
      |            ^
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
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1302:3: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1302 |   if (mrg_info.errkey >= (int) table_share->keys)
      |   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1313:35: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1313 |   stats.mean_rec_length= mrg_info.reclength;
      |                                   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1354:17: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1354 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1301:25: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1301 |   stats.data_file_length= mrg_info.data_file_length;
      |                         ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
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
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ is used uninitialized [-Wuninitialized]
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ is used uninitialized [-Wuninitialized]
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
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
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].mem_root’ is used uninitialized [-Wuninitialized]
 4803 |         Query_arena backup_arena;
      |                     ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: warning: ‘MEM[(struct Query_arena *)&backup_arena].free_list’ is used uninitialized [-Wuninitialized]
/home/mdcallag/b/mysql-5.7.40/sql/sql_class.cc:3426:8: warning: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3426 |   state= set->state;
      |        ^
/home/mdcallag/b/mysql-5.7.40/sql/table.cc:4803:21: note: ‘MEM <signed int> [(struct Query_arena *)&backup_arena + 24B]’ was declared here
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
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_geofunc.h:206:32,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_geofunc.h:320:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5501:72:
/home/mdcallag/b/mysql-5.7.40/sql/item_strfunc.h:52:26: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
   52 |     :Item_func(pos, a,b,c)
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      | 
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5478:7: note: ‘pos’ declared here
 5478 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1505:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6499:78:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      | 
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6483:7: note: ‘pos’ declared here
 6483 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2070:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6730:64:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      | 
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6709:7: note: ‘pos’ declared here
 6709 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1917:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4259:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1432:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4261:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1838:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4265:72:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1376:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4267:71:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1871:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4271:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1405:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4273:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1894:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4277:74:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1479:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4279:73:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_strfunc.h:1118:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5180:59:
/home/mdcallag/b/mysql-5.7.40/sql/item_strfunc.h:52:26: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
   52 |     :Item_func(pos, a,b,c)
      |                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      | 
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:5172:7: note: ‘pos’ declared here
 5172 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2023:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6673:82:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      | 
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6659:7: note: ‘pos’ declared here
 6659 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1917:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4259:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1432:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4261:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1838:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4265:72:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1376:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4267:71:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1871:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4271:70:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1405:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4273:69:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1894:42,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4277:74:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1757:43: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1757 |     :Item_func(pos, opt_list), udf(udf_arg)
      |                                           ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.cc:125:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  125 | Item_func::Item_func(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct_base ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1479:41,
    inlined from ‘create’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4279:73:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.h:1336:42: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
 1336 |     :Item_sum(pos, opt_list), udf(udf_arg)
      |                                          ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create’:
/home/mdcallag/b/mysql-5.7.40/sql/item_sum.cc:342:1: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  342 | Item_sum::Item_sum(const POS &pos, PT_item_list *opt_list)
      | ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:4254:7: note: ‘pos’ declared here
 4254 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:1505:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6499:78:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6483:7: note: ‘pos’ declared here
 6483 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2070:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6730:64:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6709:7: note: ‘pos’ declared here
 6709 |   POS pos;
      |       ^
In member function ‘__ct ’,
    inlined from ‘__ct ’ at /home/mdcallag/b/mysql-5.7.40/sql/item_func.h:2023:32,
    inlined from ‘create_native’ at /home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6673:82:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:743:79: warning: ‘pos’ may be used uninitialized [-Wmaybe-uninitialized]
  743 |   Item_int_func(const POS &pos, Item *a,Item *b,Item *c) :Item_func(pos, a,b,c)
      |                                                                               ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc: In member function ‘create_native’:
/home/mdcallag/b/mysql-5.7.40/sql/item_func.h:136:3: note: by argument 2 of type ‘const struct POS &’ to ‘__ct_base ’ declared here
  136 |   Item_func(const POS &pos, Item *a,Item *b,Item *c): super(pos),
      |   ^
/home/mdcallag/b/mysql-5.7.40/sql/item_create.cc:6659:7: note: ‘pos’ declared here
 6659 |   POS pos;
      |       ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1302:3: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1302 |   if (mrg_info.errkey >= (int) table_share->keys)
      |   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1313:35: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1313 |   stats.mean_rec_length= mrg_info.reclength;
      |                                   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1354:17: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1354 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1301:25: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1301 |   stats.data_file_length= mrg_info.data_file_length;
      |                         ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1302:3: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1302 |   if (mrg_info.errkey >= (int) table_share->keys)
      |   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].errkey’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1313:35: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1313 |   stats.mean_rec_length= mrg_info.reclength;
      |                                   ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].reclength’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1354:17: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1354 |     my_store_ptr(dup_ref, ref_length, mrg_info.dupp_key_pos);
      |                 ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].dupp_key_pos’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1301:25: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 1301 |   stats.data_file_length= mrg_info.data_file_length;
      |                         ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: note: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].data_file_length’ was declared here
 1287 |   MYMERGE_INFO mrg_info;
      |                ^
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].deleted’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/myisammrg/ha_myisammrg.cc:1287:16: warning: ‘MEM[(struct MYMERGE_INFO *)&mrg_info].records’ may be used uninitialized in this function [-Wmaybe-uninitialized]
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:422:31: warning: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  422 |     stats.auto_increment_value= hp_info.auto_increment;
      |                               ^
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:409:12: note: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ was declared here
  409 |   HEAPINFO hp_info;
      |            ^
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
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc: In member function ‘info’:
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:422:31: warning: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  422 |     stats.auto_increment_value= hp_info.auto_increment;
      |                               ^
/home/mdcallag/b/mysql-5.7.40/storage/heap/ha_heap.cc:409:12: note: ‘MEM[(struct HEAPINFO *)&hp_info].auto_increment’ was declared here
  409 |   HEAPINFO hp_info;
      |            ^
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
