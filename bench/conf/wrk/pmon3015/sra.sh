for d in md2 nvme0n1 nvme1n1 nvme2n1 ; do echo 8 > /sys/block/$d/queue/read_ahead_kb ; done
