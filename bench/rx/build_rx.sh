for t in $( cat ../rx.tags  ); do
  echo; echo $t at $( date )
  echo git checkout $t -b me_${t}
  git checkout $t -b me_${t}
  # git checkout me_${t} > ../bld.${t} 2> ../e.${t}
  # cat ../e.${t}
  git branch -a | grep me_v6 
  echo STEP make clean >> ../bld.${t}
  make clean >> ../bld.${t} 2>& 1
  echo STEP make >> ../bld.${t}
  DISABLE_WARNING_AS_ERROR=1 DEBUG_LEVEL=0 make V=1 VERBOSE=1 -j4 static_lib db_bench >> ../bld.${t} 2> ../e.${t}
  mv db_bench ../db_bench.${t}
  tail -2 ../bld.${t}
done
