iodepth=$1
nsecs=$2
bs=$3
devname=$4

for njobs in 1 2 4 8 16 32; do

sfx=njobs${njobs}.iodepth${iodepth}.bs${bs}

killall -q iostat
iostat -y -kx 1 >& o.iostat.io.$sfx &
ipid=$!
vmstat 1 >& o.iostat.vm.$sfx &
vpid=$!

/usr/bin/time -o o.iostat.time.$sfx -f '%e %U %S' \
fio --filename=$devname --direct=1 --rw=randread \
    --bs=${bs} --ioengine=libaio --iodepth=$iodepth --runtime=$nsecs \
    --numjobs=$njobs --time_based --group_reporting \
    --name=iops-test-job --eta-newline=1 --eta-interval=1 \
    --readonly --eta=always > o.iostat.res.$sfx

kill $ipid
kill $vpid

iops=$( cat o.iostat.res.$sfx | grep iops | grep avg | awk '{ print $5 }' | tr ',' ' ' | sed 's/avg=//' )
ios=$( cat o.iostat.res.$sfx | grep ios | awk '{ print $2 }' | tr ',/' ' ' | sed 's/ios=//g' | awk '{ print $1 }' )

user_cpu=$( cat o.iostat.time.$sfx | awk '{ print $2 }' )
sys_cpu=$( cat o.iostat.time.$sfx | awk '{ print $3 }' )

cpu_usecs_per_query=$( echo $user_cpu $sys_cpu $ios | awk '{ printf "%.1f", (1000000.0 * ($1 + $2)) / $3 }' )
user_cpu_usecs_per_query=$( echo $user_cpu $ios | awk '{ printf "%.1f", (1000000.0 * $1) / $2 }' )
sys_cpu_usecs_per_query=$( echo $sys_cpu $ios | awk '{ printf "%.1f", (1000000.0 * $1) / $2 }' )

avg_cs=$( cat o.iostat.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $1 }' )
avg_us=$( cat o.iostat.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $2 }' )
avg_sy=$( cat o.iostat.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $3 }' )
avg_us_sy=$( cat o.iostat.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $4 }' )

#Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
rps_col=$( iostat -kx 1 1 | grep r\/s | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r/s") { found=n } } } END { printf "%s", found }' )
r_await_col=$( iostat -kx 1 1 | grep r_await | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r_await") { found=n } } } END { printf "%s", found }' )
rareq_sz_col=$( iostat -kx 1 1 | grep rareq\-sz | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "rareq-sz") { found=n } } } END { printf "%s", found }' )
aqu_sz_col=$( iostat -kx 1 1 | grep aqu\-sz | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "aqu-sz") { found=n } } } END { printf "%s", found }' )

dev_suffix=$( echo $devname | tr '/' ' ' | awk '{ print $2 }' )

rps=NA
if [ $rps_col -gt 0 ]; then
  rps=$( grep $dev_suffix o.iostat.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.0f", v/c }' colno=$rps_col )
fi
r_await=NA
if [ $r_await_col -gt 0 ]; then
  r_await=$( grep $dev_suffix o.iostat.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.3f", v/c }' colno=$r_await_col )
fi
rareq_sz=NA
if [ $rareq_sz_col -gt 0 ]; then
  rareq_sz=$( grep $dev_suffix o.iostat.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.3f", v/c }' colno=$rareq_sz_col )
fi
aqu_sz=NA
if [ $aqu_sz_col -gt 0 ]; then
  aqu_sz=$( grep $dev_suffix o.iostat.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.1f", v/c }' colno=$aqu_sz_col )
fi

echo "njobs=$njobs, iops=$iops cpu_usecs_per_io(user,sys,user+sys)=($user_cpu_usecs_per_query, $sys_cpu_usecs_per_query, $cpu_usecs_per_query) vmstat(cs,us,sy,us+sy)=($avg_cs, $avg_us, $avg_sy, $avg_us_sy) iostat(rps,r_await,rareq-sz,aqu-sz=($rps, $r_await, $rareq_sz, $aqu_sz)"

done
