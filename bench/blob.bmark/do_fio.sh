iodepth=$1
nsecs=$2
bs=$3
devname=$4
# raw, odir or buf
iotype=$5
# path to files is $dbdir
dbdir=$6
# number of data files
nfiles=$7
# sum of sizes for data files, in GB
dbgb=$8
# yes if files should be created, for iotype=dir or buf, 
makefiles=$9
ioengine=${10}

first=yes

# The first run (njobs=3) is meant to be ignored
for njobs in 3 1 2 4 8 16 32 48 64; do

sfx=njobs${njobs}.iodepth${iodepth}.bs${bs}.ioengine_${ioengine}

killall -q iostat
iostat -y -kx 1 >& o.fio.io.$sfx &
ipid=$!
vmstat 1 >& o.fio.vm.$sfx &
vpid=$!

if [ $iotype == "raw" ]; then
  fiocmd="fio --filename=$devname --direct=1 --rw=randread \
      --bs=${bs} --ioengine=$ioengine --iodepth=$iodepth --runtime=$nsecs \
      --numjobs=$njobs --time_based --group_reporting \
      --name=iops-test-job --eta-newline=1 --eta-interval=1 \
      --readonly --eta=always"
  echo $fiocmd > o.fio.res.$sfx
  /usr/bin/time -o o.fio.time.$sfx -f '%e %U %S' $fiocmd >> o.fio.res.$sfx 2>&1

elif [[ $iotype == "dir" || $iotype == "buf" ]]; then
  if [ $iotype == "dir" ]; then exflags="--direct=1"; else exflags="--direct=0"; fi

  fpath=""
  for x in $( seq 1 $(( nfiles - 1)) ); do fpath=${fpath}${dbdir}"/fio.in."${x}":" ; done
  fpath=${fpath}${dbdir}"/fio.in."${nfiles}

  mb_per_file=$( echo $dbgb $nfiles | awk '{ printf "%.0f", ($1 * 1024) / $2 }' )

  fiocmd="fio --filename=$fpath --filesize=${mb_per_file}m $exflags --rw=randread \
    --bs=${bs} --ioengine=$ioengine --iodepth=$iodepth \
    --numjobs=$njobs --time_based --group_reporting \
    --name=iops-test-job --eta-newline=1 --eta-interval=1 \
    --eta=always"

  touch o.fio.res.$sfx

  if [[ $first == "yes" && $makefiles == "yes" ]]; then
    echo "Removing $dbdir/fio.in.*"
    sleep 5
    rm -f $dbdir/fio.in.*
    # Run fio to create the files, then sync them and rest
    echo $fiocmd >> o.fio.res.$sfx
    echo Create files like $dbdir/fio.in.*
    /usr/bin/time -o o.fio.time.$sfx -f '%e %U %S' $fiocmd --runtime=30 >> o.fio.res.$sfx 2>&1
    ls -lh $dbdir/fio.in.*
    echo sync and sleep 30
    sync; sleep 30
  else
    if [ $first == "yes" ]; then echo Use existing files; ls -lh $dbdir/fio.in.* ; fi
    echo $fiocmd >> o.fio.res.$sfx
    /usr/bin/time -o o.fio.time.$sfx -f '%e %U %S' $fiocmd --runtime=$nsecs >> o.fio.res.$sfx 2>&1
  fi

else
  echo iotype :: $iotype :: is not supported
  exit 1
fi

first=no

kill $ipid
kill $vpid

# iops        : min= 9184, max=11568, avg=9804.42, stdev=558.14, samples=59
iops=$( cat o.fio.res.$sfx | grep iops | grep avg= | tail -1 | awk '{ for (x=3; x <= NF; x += 1) { if (index($x, "avg=") == 1) { print $x } } }' | tr ',' ' ' | sed 's/avg=//' | awk '{ printf "%.0f", $1 }' )
ios=$( cat o.fio.res.$sfx | grep ios | awk '{ print $2 }' | tr ',/' ' ' | sed 's/ios=//g' | awk '{ print $1 }' )

user_cpu=$( cat o.fio.time.$sfx | awk '{ print $2 }' )
sys_cpu=$( cat o.fio.time.$sfx | awk '{ print $3 }' )

cpu_usecs_per_query=$( echo $user_cpu $sys_cpu $ios | awk '{ printf "%.1f", (1000000.0 * ($1 + $2)) / $3 }' )
user_cpu_usecs_per_query=$( echo $user_cpu $ios | awk '{ printf "%.1f", (1000000.0 * $1) / $2 }' )
sys_cpu_usecs_per_query=$( echo $sys_cpu $ios | awk '{ printf "%.1f", (1000000.0 * $1) / $2 }' )

avg_cs=$( cat o.fio.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $1 }' )
avg_us=$( cat o.fio.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $2 }' )
avg_sy=$( cat o.fio.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $3 }' )
avg_us_sy=$( cat o.fio.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $4 }' )

#Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
rps_col=$( iostat -kx 1 1 | grep r\/s | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r/s") { found=n } } } END { printf "%s", found }' )
r_await_col=$( iostat -kx 1 1 | grep r_await | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r_await") { found=n } } } END { printf "%s", found }' )
rareq_sz_col=$( iostat -kx 1 1 | grep rareq\-sz | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "rareq-sz") { found=n } } } END { printf "%s", found }' )
aqu_sz_col=$( iostat -kx 1 1 | grep aqu\-sz | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "aqu-sz") { found=n } } } END { printf "%s", found }' )

dev_suffix=$( echo $devname | tr '/' ' ' | awk '{ print $2 }' )

rps=NA
if [ $rps_col -gt 0 ]; then
  rps=$( grep $dev_suffix o.fio.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.0f", v/c }' colno=$rps_col )
fi
r_await=NA
if [ $r_await_col -gt 0 ]; then
  r_await=$( grep $dev_suffix o.fio.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.3f", v/c }' colno=$r_await_col )
fi
rareq_sz=NA
if [ $rareq_sz_col -gt 0 ]; then
  rareq_sz=$( grep $dev_suffix o.fio.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.3f", v/c }' colno=$rareq_sz_col )
fi
aqu_sz=NA
if [ $aqu_sz_col -gt 0 ]; then
  aqu_sz=$( grep $dev_suffix o.fio.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.1f", v/c }' colno=$aqu_sz_col )
fi

echo "njobs=$njobs, iops=$iops cpu_usecs_per_io(user,sys,user+sys)=($user_cpu_usecs_per_query, $sys_cpu_usecs_per_query, $cpu_usecs_per_query) vmstat(cs,us,sy,us+sy)=($avg_cs, $avg_us, $avg_sy, $avg_us_sy) iostat(rps,r_await,rareq-sz,aqu-sz=($rps, $r_await, $rareq_sz, $aqu_sz)"

done
