# Scripts
> Will probably add some comments here, #someday.


# One-liners

## Microsoft
Measure size (length) on all items in this folder
"{0:N2} GB" -f ((Get-ChildItem -Path . -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)

## VMware VSAN
Check congestion values
`for ssd in $(localcli vsan storage list |grep "Group UUID"|awk '{print $5}'|sort -u);do echo $ssd;vsish -e get /vmkModules/lsom/disks/$ssd/info|grep Congestion;done`

Sample output
```
52b7c82e-127f-3b9f-351f-05b741414052
   memCongestion:0
   slabCongestion:0
   ssdCongestion:0
   iopsCongestion:0
   logCongestion:0
   compCongestion:0
```

## Cisco
### Quick view on ports + input & output rate
`sh int | inc protocol|input rate|output rate`

Sample output
```
GigabitEthernet1/5 is up, line protocol is up (connected) 
  5 minute input rate 98521000 bits/sec, 8148 packets/sec
  5 minute output rate 2219000 bits/sec, 4180 packets/sec
     0 unknown protocol drops
GigabitEthernet1/6 is up, line protocol is up (connected) 
  5 minute input rate 899636000 bits/sec, 74263 packets/sec
  5 minute output rate 10217000 bits/sec, 18932 packets/sec
     0 unknown protocol drops
```
