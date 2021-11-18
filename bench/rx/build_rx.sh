for t in $( cat ../rx.tags  ); do
  echo; echo $t at $( date )
  git checkout co_${t} > ../bld.${t} 2> ../e.${t}
  cat ../e.${t}
  tail -2 ../bld.${t}
  echo STEP make clean >> ../bld.${t}
  make clean >> ../bld.${t} 2>& 1
  echo STEP make >> ../bld.${t}
  DEBUG_LEVEL=0 make V=1 VERBOSE=1 -j4 static_lib db_bench >> ../bld.${t} 2> ../e.${t}
  mv db_bench ../db_bench.${t}
  tail -2 ../bld.${t}
done
