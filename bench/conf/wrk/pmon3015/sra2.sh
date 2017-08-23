for d in md2 ; do echo 768 > /sys/block/$d/queue/read_ahead_kb ; done
for d in nvme0n1 nvme1n1 nvme2n1 ; do echo 128 > /sys/block/$d/queue/read_ahead_kb ; done
