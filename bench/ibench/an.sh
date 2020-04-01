iof=$1
vmf=$2
sampr=$3
dname=$4
nr=$5

# Old and new output format for iostat
#Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
#Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

printf "\niostat, vmstat totals\n"
printf "samp\tr/s\trMB/s\twMB/s\tr/o\trKB/o\twKB/o\trGB\twGB\tMreads\n" 

iover=$( head -10 $iof | grep Device | grep avgrq\-sz | wc -l )
if [[ $iover -eq 1 ]]; then
  grep $dname $iof | awk '{ if (NR>1) { rs += $4; rkb += $6; wkb += $7; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.1f\t%.3f\t%.3f\t%.3f\t%.0f\t%.0f\t%.3f\n", c, rs/c, rkb/c/1024.0, wkb/c/1024.0, (rs*sr)/nr, (rkb*sr)/nr, (wkb*sr)/nr, (rkb*sr)/(1024*1024.0), (wkb*sr)/(1024*1024.0), (rs*sr)/1000000.0 }' sr=$sampr nr=$nr
else
  grep $dname $iof | awk '{ if (NR>1) { rs += $2; rkb += $4; wkb += $5; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.1f\t%.3f\t%.3f\t%.3f\t%.0f\t%.0f\t%.3f\n", c, rs/c, rkb/c/1024.0, wkb/c/1024.0, (rs*sr)/nr, (rkb*sr)/nr, (wkb*sr)/nr, (rkb*sr)/(1024*1024.0), (wkb*sr)/(1024*1024.0), (rs*sr)/1000000.0 }' sr=$sampr nr=$nr
fi

printf "\nsamp\tcs/s\tcpu/s\tcs/o\tMcpu/o\twa.sec\n"
grep -v swpd $vmf | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; wa += $16; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.3f\t%.1f\n", c, cs/c, cpu/c, (cs*sr)/nr, (cpu*sr*1000000.0)/nr, (wa*sr)/100.0 }' sr=$sampr nr=$nr
