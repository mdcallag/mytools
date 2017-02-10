e=$1
mybin=$2
myslap=$3
maxdop=$4

$mybin -uroot -ppw test -e 'drop table if exists incident'
$mybin -uroot -ppw test -e 'drop table if exists task'
$mybin -uroot -ppw test < test.$e.sql 
$mybin -uroot -ppw test -e 'explain select count(*), category from incident straight_join task on task.sys_id=incident.sys_id group by incident.category' > o.plans
$mybin -uroot -ppw test -e 'explain select count(*), category from task straight_join incident on task.sys_id=incident.sys_id group by incident.category' >> o.plans

rm -f o.q1 o.q2 o.m1 o.m2 o.a1 o.a2

i=10
for c in 1 2 4 8 12 16 20 24 28 32 36 40 44 48 64 80 96 112 128 144 160 176 192 ; do
q=$(( 100 * $c ))

if [[ $c -gt $maxdop ]]; then
  grep "Average number of sec" o.q1 | awk '{ printf "%s\t", $9 } END { printf "\n" }' > o.a1
  grep "Average number of sec" o.q2 | awk '{ printf "%s\t", $9 } END { printf "\n" }' > o.a2
  grep "Maximum number of sec" o.q1 | awk '{ printf "%s\t", $9 } END { printf "\n" }' > o.m1
  grep "Maximum number of sec" o.q2 | awk '{ printf "%s\t", $9 } END { printf "\n" }' > o.m2
  exit 0
fi
echo $c at $( date )

$myslap -uroot -ppw --iterations=$i --concurrency=$c --create-schema=test --no-drop --number-of-queries=$q \
--query='select count(*), category from incident straight_join task on task.sys_id=incident.sys_id group by incident.category' >> o.q1

$myslap -uroot -ppw --iterations=$i --concurrency=$c --create-schema=test --no-drop --number-of-queries=$q \
--query='select count(*), category from task straight_join incident on task.sys_id=incident.sys_id group by incident.category' >> o.q2

done
