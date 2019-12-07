iof=$1
vmf=$2
sampr=$3
dname=$4
nr=$5

printf "\niostat, vmstat totals\n"
printf "samp\tr/s\trMB/s\twMB/s\tr/o\trKB/o\twKB/o\trGB\twGB\tMreads\n" 
grep $dname $iof | awk '{ if (NR>1) { rs += $2; rkb += $4; wkb += $5; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.1f\t%.3f\t%.3f\t%.3f\t%.0f\t%.0f\t%.3f\n", c, rs/c, rkb/c/1024.0, wkb/c/1024.0, (rs*sr)/nr, (rkb*sr)/nr, (wkb*sr)/nr, (rkb*sr)/(1024*1024.0), (wkb*sr)/(1024*1024.0), (rs*sr)/1000000.0 }' sr=$sampr nr=$nr

printf "\nsamp\tcs/s\tcpu/s\tcs/o\tMcpu/o\twa.sec\n"
grep -v swpd $vmf | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; wa += $16; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.3f\t%.1f\n", c, cs/c, cpu/c, (cs*sr)/nr, (cpu*sr*1000000.0)/nr, (wa*sr)/100.0 }' sr=$sampr nr=$nr
