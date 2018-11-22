# Scripts
> Will probably add some comments here, #someday.


# One-liners

## Microsoft
Measure size (length) on all items in this folder
``` powershell
"{0:N2} GB" -f ((Get-ChildItem -Path . -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)
```

## VMware
### Networking
Capture network traffic on a ESXi-host, e.g. for NTP
> * `-n` = No resolve
> * `-i` = Interface
> * `-q` = Quick (show e.g. UDP vs local6.info)

Samples
```
tcpdump-uw -nqi vmk0 port 123
tcpdump-uw -nqi vmk0 host 1.1.1.1 and port 123
tcpdump-uw -nqi vmk0 port 123 and not host 2.2.2.2
```

Useful blogs
http://rickardnobel.se/tcpdump-uw-for-troubleshoot-esxi-networking/

### vSAN
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
