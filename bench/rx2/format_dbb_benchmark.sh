ifile=$1
astsv=$2
absval=$3

if [[ absval -eq 1 ]]; then
  if [[ astsv -eq 1 ]]; then
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s\t", $26 } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s\t", $1; tname=$24 } ; if ($1 == "ops_sec") { new=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | grep -v revrange\.t | grep -v overwritesome
  else
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s,", $26 } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s,", $1; tname=$24 } ; if ($1 == "ops_sec") { new=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | grep -v revrange\.t | grep -v overwritesome
  fi
else
  if [[ astsv -eq 1 ]]; then
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s\t", $26 } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { if (colno == 1) { printf "1.00\t"; colval=$1 } else { printf "%.2f\t", $1 / colval }; tname=$24 ; colno = colno+1 } ; if ($1 == "ops_sec") { new=1; colno=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | grep -v revrange\.t | grep -v overwritesome
  else
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s,", $26 } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { if (colno == 1) { printf "1.00,"; colval=$1 } else { printf "%.2f,", $1 / colval }; tname=$24 ; colno = colno+1 } ; if ($1 == "ops_sec") { new=1; colno=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | grep -v revrange\.t | grep -v overwritesome
  fi
fi


