for nj in 1 2 5 10 ; do grep pread64 o.fio.st.njobs${nj}.iodepth1.bs4096.ioengine_psync | grep -v unfinished | awk '{ print $(NF-2) }' | tr ')' ' ' > offs.nj${nj}; done
for nj in 1 2 5 10 ; do sort offs.nj${nj} > offs.nj${nj}.sort; done
for nj in 1 2 5 10 ; do uniq offs.nj${nj}.sort > offs.nj${nj}.uniq; done
for nj in 1 2 5; do join offs.nj${nj}.uniq offs.nj10.uniq > join.${nj}.10; done
wc -l offs*.sort
wc -l offs.nj*.uniq
wc -l join.*
