echo "ulimit -n 70000"
echo -1 > /proc/sys/kernel/perf_event_paranoid
echo 0 > /proc/sys/kernel/yama/ptrace_scope
sudo sh -c " echo 0 > /proc/sys/kernel/kptr_restrict"
echo 1 > /proc/sys/kernel/sysrq
echo x > /proc/sysrq-trigger
echo '0' > /sys/devices/system/cpu/cpufreq/boost

