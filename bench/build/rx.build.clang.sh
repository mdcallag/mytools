dop=$1
lto=$2

for v in $( seq 0 29 ) ; do git branch -D 6.$v.fb; git checkout remotes/origin/6.$v.fb -b 6.$v.fb ; done
for v in $( seq 0 10 ) ; do git branch -D 7.$v.fb; git checkout remotes/origin/7.$v.fb -b 7.$v.fb ; done
for v in $( seq 0 11 ) ; do git branch -D 8.$v.fb; git checkout remotes/origin/8.$v.fb -b 8.$v.fb ; done
for v in $( seq 0 11 ) ; do git branch -D 9.$v.fb; git checkout remotes/origin/9.$v.fb -b 9.$v.fb ; done
for v in $( seq 0 8 ) ; do git branch -D 10.$v.fb; git checkout remotes/origin/10.$v.fb -b 10.$v.fb ; done

#b=6; for v in $( seq 0 29 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; CC=clang CXX=clang++ make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.clang 2> e.mk.$b.$v.clang; mv db_bench db_bench.$b.$v.clang ; done

#b=7; for v in $( seq 0 10 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; CC=clang CXX=clang++ make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.clang 2> e.mk.$b.$v.clang; mv db_bench db_bench.$b.$v.clang ; done

#b=6; v=29; dop=6; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.clang 2> e.mk.$b.$v.clang; mv db_bench db_bench.$b.$v.clang
#b=6; v=29; dop=6; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make USE_LTO=1 DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.clang.lto 2> e.mk.$b.$v.clang.lto; mv db_bench db_bench.$b.$v.clang.lto

#b=7; v=0; dop=6; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.clang 2> e.mk.$b.$v.clang; mv db_bench db_bench.$b.$v.clang
#b=7; v=0; dop=6; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make USE_LTO=1 DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.clang.lto 2> e.mk.$b.$v.clang.lto; mv db_bench db_bench.$b.$v.clang.lto

flags=( DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 )

if [[ $lto -eq 1 ]]; then

echo Use LTO

b=8; for v in $( seq 0 11 ) ; do sfx="$b.$v.clang.lto"; git checkout $b.$v.fb ; git log -1 > o.gitlog.${sfx} ; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make USE_LTO=1 "${flags[@]}" -j${dop} static_lib db_bench > o.mk.${sfx} 2> e.mk.${sfx} ; mv db_bench db_bench.${sfx} ; done
b=9; for v in $( seq 0 11 ) ; do sfx="$b.$v.clang.lto"; git checkout $b.$v.fb ; git log -1 > o.gitlog.${sfx} ; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make USE_LTO=1 "${flags[@]}" -j${dop} static_lib db_bench > o.mk.${sfx} 2> e.mk.${sfx} ; mv db_bench db_bench.${sfx} ; done
b=10; for v in $( seq 0 8 ) ; do sfx="$b.$v.clang.lto"; git checkout $b.$v.fb ; git log -1 > o.gitlog.${sfx} ; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make USE_LTO=1 "${flags[@]}" -j${dop} static_lib db_bench > o.mk.${sfx} 2> e.mk.${sfx} ; mv db_bench db_bench.${sfx} ; done

else

echo Do not Use LTO

b=8; for v in $( seq 0 11 ) ; do sfx="$b.$v.clang"; git checkout $b.$v.fb ; git log -1 > o.gitlog.${sfx} ; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make "${flags[@]}" -j${dop} static_lib db_bench > o.mk.${sfx} 2> e.mk.${sfx} ; mv db_bench db_bench.${sfx} ; done
b=9; for v in $( seq 0 11 ) ; do sfx="$b.$v.clang"; git checkout $b.$v.fb ; git log -1 > o.gitlog.${sfx} ; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make "${flags[@]}" -j${dop} static_lib db_bench > o.mk.${sfx} 2> e.mk.${sfx} ; mv db_bench db_bench.${sfx} ; done
b=10; for v in $( seq 0 8 ) ; do sfx="$b.$v.clang"; git checkout $b.$v.fb ; git log -1 > o.gitlog.${sfx} ; make clean >& /dev/null; AR=llvm-ar-18 RANLIB=llvm-ranlib-18 CC=clang CXX=clang++ make "${flags[@]}" -j${dop} static_lib db_bench > o.mk.${sfx} 2> e.mk.${sfx} ; mv db_bench db_bench.${sfx} ; done

fi
