#!/bin/bash
# See awesome blog at https://devconnected.com/monitoring-linux-processes-using-prometheus-and-grafana/
# Slightly modified by me (esod) to match MacOS export, e.g. no path names (spaces, eeew), and only needed output
#
z=$(ps -cAo pid,%cpu,comm)
while read -r z
do
   var=$var$(awk '{print "cpu_usage{process=\""$3"\", pid=\""$1"\"}", $2z}');
done <<< "$z"
echo $var
curl -X POST -H  "Content-Type: text/plain" --data "$var
" http://localhost:9091/metrics/job/top/instance/machine
