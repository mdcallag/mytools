while :; do

  echo nvme0n1 at $( date )
  smartctl -a /dev/nvme0n1

  echo nvme1n1 at $( date )
  smartctl -a /dev/nvme1n1

  echo acpi at $( date )
  acpi -V

  echo sensors at $( date )
  sensors

  sleep 60
done
