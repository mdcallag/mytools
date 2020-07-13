m=$1
dop=$2

bdir=$( dirname $0 )

shift 2

itests=( l.i0 l.i1 )
qtests=( q.L2.ips100 q.L4.ips200 q.L6.ips400 q.L8.ips600 q.L10.ips800 q.L12.ips1000 )

for x in "$@"; do
  echo bash $bdir/plot.sh 200 50 $x $dop ${m}m n 1.2 ${m}m.$x 
  bash $bdir/plot.sh 200 50 $x $dop ${m}m n 1.2 ${m}m.$x 
  mv do.gp do.gp.$x
  gnuplot do.gp.$x
  mv *.png report
  rm -f ${x}*.txt
done

# ----- Generate for insert-only tests

for t in ${itests[@]} ; do

cat <<IHeaderEOF > tput.$t.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes">
  <title>$t per-second graphs</title>
</head>
<body>
<p>
These have results per 1-second interval for: insert rate (IPS) and max insert reponse time.
The results are from 1 client while the test may have N clients where N > 1.
</p>
<h1 id=\"toc\">Contents</h1>
<ul>
IHeaderEOF

for x in "$@"; do
printf "<li>$x: <a href=\"#${x}.ips\">IPS</a> and <a href=\"#${x}.imax\">max insert response time</a>\n" >> tput.$t.html
done

printf "</ul>\n" >> tput.$t.html

for x in "$@"; do

printf "<hr />\n"  >> tput.$t.html
printf "<h1 id=\"${x}.ips\">${x}: IPS</h1>\n" >> tput.$t.html
printf "<img src=\"$x.$t.ips.png\">$x</a>\n" >> tput.$t.html

printf "<hr />\n"  >> tput.$t.html
printf "<h1 id=\"${x}.imax\">${x}: max insert response time</h1>\n" >> tput.$t.html
printf "<img src=\"$x.$t.imax.png\">$x</a>\n" >> tput.$t.html

done

cat <<IFooterEOF >> tput.$t.html
</ul>
</body>
</html>
IFooterEOF

mv tput.$t.html report
done

# ----- Generate for read+write tests

for t in ${qtests[@]} ; do

cat <<QHeaderEOF > tput.$t.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes">
  <title>$t per-second graphs</title>
</head>
<body>
<p>
These have results per 1-second interval for: insert rate (IPS), max insert reponse time, query rate (QPS) and max query response time.
The results are from 1 client while the test may have N clients where N > 1.
The test is run with a rate limit for the number of inserts/s. In some cases the DBMS is unable to sustain that rate. When a DBMS can sustain that rate IPS will be a horizontal line.
</p>
<h1 id=\"toc\">Contents</h1>
<ul>
QHeaderEOF

for x in "$@"; do
printf "<li>$x: <a href=\"#${x}.ips\">IPS</a>, <a href=\"#${x}.imax\">max insert response time</a>, <a href=\"#${x}.qps\">QPS</a> and <a href=\"#${x}.qmax\">max query response time</a>\n" >> tput.$t.html
done

printf "</ul>\n" >> tput.$t.html

for x in "$@"; do

printf "<hr />\n"  >> tput.$t.html
printf "<h1 id=\"${x}.ips\">${x}: IPS</h1>\n" >> tput.$t.html
printf "<img src=\"$x.$t.ips.png\">$x</a>\n" >> tput.$t.html

printf "<hr />\n"  >> tput.$t.html
printf "<h1 id=\"${x}.imax\">${x}: max insert response time</h1>\n" >> tput.$t.html
printf "<img src=\"$x.$t.imax.png\">$x</a>\n" >> tput.$t.html

printf "<hr />\n"  >> tput.$t.html
printf "<h1 id=\"${x}.qps\">${x}: QPS</h1>\n" >> tput.$t.html
printf "<img src=\"$x.$t.qps.png\">$x</a>\n" >> tput.$t.html

printf "<hr />\n"  >> tput.$t.html
printf "<h1 id=\"${x}.qmax\">${x}: max query response time</h1>\n" >> tput.$t.html
printf "<img src=\"$x.$t.qmax.png\">$x</a>\n" >> tput.$t.html

done

cat <<QFooterEOF >> tput.$t.html
</ul>
</body>
</html>
QFooterEOF

mv tput.$t.html report
done
