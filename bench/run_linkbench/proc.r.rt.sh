tag=$1
isNode=$2

if [[ $isNode == "node" ]]; then
  echo "an9,anx,anm,un9,unx,unm,dn9,dnx,dnm,gn9,gnx,gnm,cnf"
else
  echo "al9,alx,alm,dl9,dlx,dlm,ul9,ulx,ulm,cl9,clx,clm,mg9,mgx,mgm,gll9,gllx,gllm,cnf"
fi

for d in * ; do 
  if [[ $isNode == "node" ]]; then
    an9=$( cat $d/r.o.*.$tag | grep ADD_NODE | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    anx=$( cat $d/r.o.*.$tag | grep ADD_NODE | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    anm=$( cat $d/r.o.*.$tag | grep ADD_NODE | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.3f\n", $1 }' )
    un9=$( cat $d/r.o.*.$tag | grep UPDATE_NODE | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    unx=$( cat $d/r.o.*.$tag | grep UPDATE_NODE | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    unm=$( cat $d/r.o.*.$tag | grep UPDATE_NODE | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    dn9=$( cat $d/r.o.*.$tag | grep DELETE_NODE | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    dnx=$( cat $d/r.o.*.$tag | grep DELETE_NODE | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    dnm=$( cat $d/r.o.*.$tag | grep DELETE_NODE | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    gn9=$( cat $d/r.o.*.$tag | grep GET_NODE | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    gnx=$( cat $d/r.o.*.$tag | grep GET_NODE | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    gnm=$( cat $d/r.o.*.$tag | grep GET_NODE | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    echo "$an9,$anx,$anm,$un9,$unx,$unm,$dn9,$dnx,$dnm,$gn9,$gnx,$gnm,$d"
  else
    al9=$( cat $d/r.o.*.$tag | grep ADD_LINK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    alx=$( cat $d/r.o.*.$tag | grep ADD_LINK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    alm=$( cat $d/r.o.*.$tag | grep ADD_LINK | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    dl9=$( cat $d/r.o.*.$tag | grep DELETE_LINK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    dlx=$( cat $d/r.o.*.$tag | grep DELETE_LINK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    dlm=$( cat $d/r.o.*.$tag | grep DELETE_LINK | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    ul9=$( cat $d/r.o.*.$tag | grep UPDATE_LINK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    ulx=$( cat $d/r.o.*.$tag | grep UPDATE_LINK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    ulm=$( cat $d/r.o.*.$tag | grep UPDATE_LINK | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    cl9=$( cat $d/r.o.*.$tag | grep COUNT_LINK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    clx=$( cat $d/r.o.*.$tag | grep COUNT_LINK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    clm=$( cat $d/r.o.*.$tag | grep COUNT_LINK | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    mg9=$( cat $d/r.o.*.$tag | grep MULTIGET_LINK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    mgx=$( cat $d/r.o.*.$tag | grep MULTIGET_LINK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    mgm=$( cat $d/r.o.*.$tag | grep MULTIGET_LINK | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    gll9=$( cat $d/r.o.*.$tag | grep GET_LINKS_LIST | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
    gllx=$( cat $d/r.o.*.$tag | grep GET_LINKS_LIST | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.1f\n", $1 }' )
    gllm=$( cat $d/r.o.*.$tag | grep GET_LINKS_LIST | tail -1 | awk '{ print $29 }' | sed 's/ms//g' | awk '{ printf "%.3f\n", $1 }' )
    echo "$al9,$alx,$alm,$dl9,$dlx,$dlm,$ul9,$ulx,$ulm,$cl9,$clx,$clm,$mg9,$mgx,$mgm,$gll9,$gllx,$gllm,$d"
  fi
done


