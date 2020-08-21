#!/bin/bash
# See awesome blog at https://devconnected.com/monitoring-linux-processes-using-prometheus-and-grafana/
# Slightly modified by me (esod) to match MacOS export, e.g. no path names (spaces, eeew), and only needed output
#
#z=$(ps -cAo pid,%cpu,comm)
z=$(ps -rcAo pid,%cpu,comm |grep -v "0.0 ")
while read -r z
do
   var=$var$(awk '{print "cpu_usage{process=\""$3$4$5$6"\", pid=\""$1"\"}", $2z}');
done <<< "$z"
#echo $var
echo "$(date "+%Y-%m-%d %H:%M:%S") Sending ps metrics to pushgateway"
curl -X POST -H  "Content-Type: text/plain" --data "$var
" http://localhost:9091/metrics/job/top/instance/machine
