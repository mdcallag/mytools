for t in L1.P8 L2.P8 L3.P12 L4.P12 L5.P16 L6.P16 ; do bash ~/git/mytools/bench/run_linkbench/etl.sh $PWD $t yes no a ec2\-user $( cat o.a ) ; done

bash ../chart_all.sh $( cat ../ch.all.nocomp )
bash ../gen_html.sh "CPU-bound Linkbench, maxid1=10m" 10 ../config.ht.nocomp 3600 > report.html
