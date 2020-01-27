pfx=$1
egarg=$2

#p.l.rt.s1.c1
#p.l.eff.op.s1.c1
#p.l.eff.sec.s1.c1 

for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
  echo $d
  cat p.l.rt.$d | egrep -v "$egarg" | egrep -v "mo42.c[7]" | egrep -v "in57\.c1[01]" | egrep -v "in80\.c1[01]" | egrep -v "rx56\.c[7]"
done > p.l.rt.io

for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
  echo $d
  cat p.l.rt.$d | egrep -v "$egarg" | egrep -v "mo42.c[89]" | egrep -v "in57\.c1[23]" | egrep -v "in80\.c1[23]" | egrep -v "rx56\.c[89]"
done > p.l.rt.mem

for x in pre post ; do
for t in sec op ; do
for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
  echo $d
  cat p.l.$x.eff.$t.$d | egrep -v "$egarg" | egrep -v "mo42.c[7]" | egrep -v "in57\.c1[01]" | egrep -v "in80\.c1[01]" | egrep -v "rx56\.c[7]"
done > p.l.$x.eff.$t.io

for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
  echo $d
  cat p.l.$x.eff.$t.$d | egrep -v "$egarg" | egrep -v "mo42.c[89]" | egrep -v "in57\.c1[23]" | egrep -v "in80\.c1[23]" | egrep -v "rx56\.c[89]"
done > p.l.$x.eff.$t.mem
done
done

#p.r.eff.sec.L1.P1.s1.c1
#p.r.eff.op.L1.P1.s1.c1
#p.r.rt.L1.P1.s1.c1

shift 2
echo $# args
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  # IO-bound
  for tag in "${doparr[@]}" ; do
    for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
      echo $d
      cat p.r.eff.sec.${tag}.$d | egrep -v "$egarg" | egrep -v "mo42.c[7]" | egrep -v "in57\.c1[01]" | egrep -v "in80\.c1[01]" | egrep -v "rx56\.c[7]"
    done > p.r.eff.sec.${tag}.io
  done

  for tag in "${doparr[@]}" ; do
    for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
      echo $d
      cat p.r.eff.op.${tag}.$d | egrep -v "$egarg" | egrep -v "mo42.c[7]" | egrep -v "in57\.c1[01]" | egrep -v "in80\.c1[01]" | egrep -v "rx56\.c[7]"
    done > p.r.eff.op.${tag}.io
  done

  for x in node link ; do
  for tag in "${doparr[@]}" ; do
    for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
      echo $d
      cat p.r.rt.$x.${tag}.$d | egrep -v "$egarg" | egrep -v "mo42.c[7]" | egrep -v "in57\.c1[01]" | egrep -v "in80\.c1[01]" | egrep -v "rx56\.c[7]"
    done > p.r.rt.$x.${tag}.io
  done
  done

  # in-memory
  for tag in "${doparr[@]}" ; do
    for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
      echo $d
      cat p.r.eff.sec.${tag}.$d | egrep -v "$egarg" | egrep -v "mo42.c[89]" | egrep -v "in57\.c1[23]" | egrep -v "in80\.c1[23]" | egrep -v "rx56\.c[89]"
    done > p.r.eff.sec.${tag}.mem
  done

  for tag in "${doparr[@]}" ; do
    for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
      echo $d
      cat p.r.eff.op.${tag}.$d | egrep -v "$egarg" | egrep -v "mo42.c[89]" | egrep -v "in57\.c1[23]" | egrep -v "in80\.c1[23]" | egrep -v "rx56\.c[89]"
    done > p.r.eff.op.${tag}.mem
  done

  for x in node link ; do
  for tag in "${doparr[@]}" ; do
    for d in $pfx.c1 $pfx.c0 $pfx.c0.orig ; do
      echo $d
      cat p.r.rt.$x.${tag}.$d | egrep -v "$egarg" | egrep -v "mo42.c[89]" | egrep -v "in57\.c1[23]" | egrep -v "in80\.c1[23]" | egrep -v "rx56\.c[89]"
    done > p.r.rt.$x.${tag}.mem
  done
  done

fi


