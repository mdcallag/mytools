w=$1
ldop=$2
rsecs=$3
usepypy=$4
bdir=$5

cnf=mconfig
rdir="r.w${w}.l${ldop}.pypy${usepypy}"

echo "start mongod"
ssh ec2-user@10.2.0.200 "cd /media/ephemeral1/${bdir}; bash -l tpcc-up.sh"
sleep 10
echo "started mongod"

vmstat 5 >& o.vm.l &
vpid=$!

while :; do ps aux ; sleep 30; done >& o.ps.l &
ppid=$!

echo start load at $( date )
if [[ $usepypy == "yes" ]]; then
  echo Use pypy
  /usr/bin/time -o o.l.time pypy ./tpcc.py --config $cnf --warehouses $w --clients $ldop --no-execute mongodb >& o.l
else
  echo Use python
  /usr/bin/time -o o.l.time python ./tpcc.py --config $cnf --warehouses $w --clients $ldop --no-execute mongodb >& o.l
fi
kill $vpid
kill $ppid

shift 5

loop=1
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  for dop in "${doparr[@]}" ; do
    echo Run dop=$dop at $( date )

    sfx="L${loop}.P${dop}"
    vmstat 5 >& o.vm.r.$sfx &
    vpid=$!
    while :; do ps aux ; sleep 30; done >& o.ps.r.$sfx &
    ppid=$!
    if [[ $usepypy == "yes" ]]; then
      /usr/bin/time -o o.r.time.$sfx pypy ./tpcc.py --config $cnf --warehouses $w --clients $dop --duration $rsecs --no-load mongodb >& o.r.$sfx
    else
      /usr/bin/time -o o.r.time.$sfx python ./tpcc.py --config $cnf --warehouses $w --clients $dop --duration $rsecs --no-load mongodb >& o.r.$sfx
    fi
    kill $vpid
    kill $ppid
    loop=$(( $loop + 1 ))
  done
fi

mkdir $rdir; mv o.* $rdir

echo "stop mongod"
ssh ec2-user@10.2.0.200 "cd /media/ephemeral1/${bdir}; bash -l tpcc-down.sh $rdir /data/m/mo"
echo "stopped mongod"
