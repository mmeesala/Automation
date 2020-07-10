#! /bin/bash
# Author: Murali Meesala <murali.meesala@gmail.com>
# Title: Principal Systems Engineer
# Script: sar-mem-cpu-used-report.sh
# Version: 1.0
# Functionality: Based on the defined days in the forloop, It will pull and generate report for Memory and CPU used in percentage for a given day
# Dependency: The system should have 'sysstat' enabled.
# Usage: ./sar-report.sh

for DAY in {01..09}
do
        echo "Day Time Memory-Used% CPU-Usage%"
        sar -r -f  /var/log/sa/sa${DAY} | grep -v Average | grep -v Linux |  grep -v kbmemfree | grep -v "^$" | awk -v DAY="$DAY" ' { print "Jul-"DAY,$1,$5 }' > mem_usage.txt
        sar -f /var/log/sa/sa${DAY} | grep -v CPU | grep -v Average | grep -v "^$" | awk '{ print $6}' > cpu_usage.txt
        paste mem_usage.txt cpu_usage.txt
        rm -r mem_usage.txt cpu_usage.txt
done
