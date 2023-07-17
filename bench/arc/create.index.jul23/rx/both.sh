secs=$1

bash ra.sh ~/d . nvme0n1 no  0 1 $secs
bash ra.sh ~/d . nvme0n1 no  0 4 $secs
bash ra.sh ~/d . nvme0n1 yes 0 4 $sec

