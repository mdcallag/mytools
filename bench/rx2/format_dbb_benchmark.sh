ifile=$1
astsv=$2
absval=$3

if [[ absval -eq 1 ]]; then
  if [[ astsv -eq 1 ]]; then
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s\t", $(NF - 1) } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 | awk '{ printf "%stest", $0 }'
    cat $ifile | \
      awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s\t", $1; tname=$(NF - 3) } ; if ($1 == "ops_sec") { new=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | \
      grep -v revrange\.t | grep -v overwritesome
  else
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s,", $(NF - 1) } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 | awk '{ printf "test,%s", $0 }'
    cat $ifile | \
      awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s,", $1; tname=$(NF - 3) } ; if ($1 == "ops_sec") { new=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | \
      grep -v revrange\.t | grep -v overwritesome | \
      awk -F ',' '{ printf "%s", $NF; for (x=1 ; x < NF; x++ ) { printf ",%s", $x }; printf "\n" }'
  fi
else
  if [[ astsv -eq 1 ]]; then
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s\t", $(NF - 1) } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 | awk '{ printf "%stest", $0 }'
    cat $ifile | \
      awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { if (colno == 1) { printf "1.00\t"; colval=$1 } else { printf "%.2f\t", $1 / colval }; tname=$(NF - 3) ; colno = colno+1 } ; if ($1 == "ops_sec") { new=1; colno=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' \
      | grep -v revrange\.t | grep -v overwritesome
  else
    cat $ifile | awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { printf "%s,", $(NF - 1) } ; if ($1 == "ops_sec") { new=1; printf "\n"  }} ' | tail -1 | awk '{ printf "test,%s", $0 }'
    cat $ifile | \
      awk '{ if (new == 1 && NF > 20 && $1 != "ops_sec" ) { if (colno == 1) { printf "1.00,"; colval=$1 } else { printf "%.2f,", $1 / colval }; tname=$(NF - 3) ; colno = colno+1 } ; if ($1 == "ops_sec") { new=1; colno=1; printf "%s\n", tname }} END { printf "%s\n", tname } ' | \
      grep -v revrange\.t | grep -v overwritesome | \
      awk -F ',' '{ printf "%s", $NF; for (x=1 ; x < NF; x++ ) { printf ",%s", $x }; printf "\n" }'
  fi
fi


