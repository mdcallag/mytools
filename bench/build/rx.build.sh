dop=$1

for v in $( seq 0 29 ) ; do git branch -D 6.$v.fb; git checkout remotes/origin/6.$v.fb -b 6.$v.fb ; done
for v in $( seq 0 10 ) ; do git branch -D 7.$v.fb; git checkout remotes/origin/7.$v.fb -b 7.$v.fb ; done
for v in $( seq 0 11 ) ; do git branch -D 8.$v.fb; git checkout remotes/origin/8.$v.fb -b 8.$v.fb ; done
for v in $( seq 0 11 ) ; do git branch -D 9.$v.fb; git checkout remotes/origin/9.$v.fb -b 9.$v.fb ; done
for v in $( seq 0 8 ) ; do git branch -D 10.$v.fb; git checkout remotes/origin/10.$v.fb -b 10.$v.fb ; done

b=6; for v in $( seq 0 29 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; CC=gcc-11 CXX=g++-11 make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.gcc 2> e.mk.$b.$v.gcc; mv db_bench db_bench.$b.$v.gcc ; done

b=7; for v in $( seq 0 10 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; CC=gcc-12 CXX=g++-12 make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.gcc 2> e.mk.$b.$v.gcc; mv db_bench db_bench.$b.$v.gcc ; done

b=8; for v in $( seq 0 11 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.gcc 2> e.mk.$b.$v.gcc; mv db_bench db_bench.$b.$v.gcc ; done

b=9; for v in $( seq 0 11 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.gcc 2> e.mk.$b.$v.gcc; mv db_bench db_bench.$b.$v.gcc ; done

b=10; for v in $( seq 0 8 ) ; do git checkout $b.$v.fb ; git log -1 > o.gitlog.$b.$v ; make clean >& /dev/null; make DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 V=1 VERBOSE=1 -j${dop} static_lib db_bench > o.mk.$b.$v.gcc 2> e.mk.$b.$v.gcc; mv db_bench db_bench.$b.$v.gcc ; done
