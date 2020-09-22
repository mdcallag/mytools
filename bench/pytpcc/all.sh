v=$1
w=$2
bdir=$3
cnf=$4
ldop=$5
rsecs=$6
usepypy=$7

tdir=$PWD
#echo $tdir

cd $bdir/$v; bash ini.sh $cnf; cd $tdir

vmstat 5 >& o.vm.l &
vpid=$!
iostat -kx 5 >& o.io.l &
ipid=$!
if [[ $usepypy == "yes" ]]; then
  echo Use pypy
  /usr/bin/time -o o.l.time pypy ./tpcc.py --config config.desktop --warehouses $w --clients $ldop --no-execute mongodb >& o.l
else
  echo Use python
  /usr/bin/time -o o.l.time python ./tpcc.py --config config.desktop --warehouses $w --clients $ldop --no-execute mongodb >& o.l
fi
kill $vpid
kill $ipid

shift 7

loop=1
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  for dop in "${doparr[@]}" ; do
    echo Run dop=$dop at $( date )

    sfx="L${loop}.P${dop}"
    vmstat 5 >& o.vm.r.$sfx &
    vpid=$!
    iostat -kx 5 >& o.io.r.$sfx &
    ipid=$!
    if [[ $usepypy == "yes" ]]; then
      /usr/bin/time -o o.r.time.$sfx pypy ./tpcc.py --config config.desktop --warehouses $w --clients $dop --duration $rsecs --no-load mongodb >& o.r.$sfx
    else
      /usr/bin/time -o o.r.time.$sfx python ./tpcc.py --config config.desktop --warehouses $w --clients $dop --duration $rsecs --no-load mongodb >& o.r.$sfx
    fi
    kill $vpid
    kill $ipid
    loop=$(( $loop + 1 ))
  done
fi

cd $bdir/$v; bash down.sh; cd $tdir
rdir="r.$v.w${w}.pypy${usepypy}"
mkdir $rdir; mv o.* $rdir
