Good old one-liners, is it?
=============================
> Will probably add some comments here, #someday.

**Jump right in..**
- [VMware](#vmware)
   - [Networking](#networking)
   - [vSAN](#vsan)
- [Network](#network)
   - [tcpdump](#tcpdump)
   - [Sample log review, from a troubleshooting case](#sample-log-review-from-a-troubleshooting-case)
   - [Links](#links)
- [Microsoft](#microsoft)
- [Cisco](#cisco)
   - [Quick view on ports + input & output rate](#quick-view-on-ports--input--output-rate)

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

## Network
### tcpdump
> tcpdump - the real one!
```bash
tcpdump -i eth0 -n port 902 and src 10.10.10.10
tcpdump -i eth0 -n port 902 and src 10.10.10.10 -l | tee /tmp/tcpdump.log
tcpdump -i eth0 -n port 902 and host 10.10.10.10
tcpdump 'src 10.0.2.4 and (dst port 3389 or 22)'
```

> * `-i` interface
> * `-n` Don't convert addresses (i.e., host addresses, port numbers, etc.) to names.
> * `-l` Make stdout line buffered. Useful if you want to see the data while capturing it


### Sample log review, from a troubleshooting case
> Suspected issues with missing heartbeats from ESXi to vCenter (should be sent in UDP, on port 902, every 10 second - from the host). vCenter flagged the host as disconnected, multiple times a day, causing minor dropouts, and restart on vpxa-service on the host (e.g. if heartbeat is not received successfully by vCenter in a total of 60 seconds, as default). Set up tcpdump on vCSA, port 902, and filter on host (se samples above). Some quick awk magic, and you got an awesome counter.

Output from tcpdump, e.g. expected packets every 10 seconds (6 pr. minute)
```text
10:29:07.550565 IP 10.10.10.10.59967 > 11.11.11.11.902: UDP, length 350
10:29:17.558301 IP 10.10.10.10.45470 > 11.11.11.11.902: UDP, length 350
10:29:27.567534 IP 10.10.10.10.62691 > 11.11.11.11.902: UDP, length 350
10:29:37.575163 IP 10.10.10.10.26603 > 11.11.11.11.902: UDP, length 350
10:29:47.582807 IP 10.10.10.10.32935 > 11.11.11.11.902: UDP, length 350
10:29:57.591062 IP 10.10.10.10.30890 > 11.11.11.11.902: UDP, length 350
10:30:07.600489 IP 10.10.10.10.58784 > 11.11.11.11.902: UDP, length 350
10:30:17.608248 IP 10.10.10.10.13710 > 11.11.11.11.902: UDP, length 350
10:30:27.617420 IP 10.10.10.10.24131 > 11.11.11.11.902: UDP, length 350
10:30:37.623311 IP 10.10.10.10.58694 > 11.11.11.11.902: UDP, length 350
10:30:47.631906 IP 10.10.10.10.42228 > 11.11.11.11.902: UDP, length 350
10:30:57.640288 IP 10.10.10.10.49252 > 11.11.11.11.902: UDP, length 350
10:31:07.648979 IP 10.10.10.10.60944 > 11.11.11.11.902: UDP, length 350
10:31:17.655853 IP 10.10.10.10.44827 > 11.11.11.11.902: UDP, length 350
10:31:27.664812 IP 10.10.10.10.50608 > 11.11.11.11.902: UDP, length 350
10:31:37.672632 IP 10.10.10.10.10336 > 11.11.11.11.902: UDP, length 350
10:31:47.680505 IP 10.10.10.10.33252 > 11.11.11.11.902: UDP, length 350
10:31:57.689034 IP 10.10.10.10.29060 > 11.11.11.11.902: UDP, length 350
10:32:07.698434 IP 10.10.10.10.36984 > 11.11.11.11.902: UDP, length 350
10:32:17.704897 IP 10.10.10.10.53270 > 11.11.11.11.902: UDP, length 350
10:32:27.713901 IP 10.10.10.10.62697 > 11.11.11.11.902: UDP, length 350
10:32:37.721889 IP 10.10.10.10.10516 > 11.11.11.11.902: UDP, length 350
10:32:47.730129 IP 10.10.10.10.52707 > 11.11.11.11.902: UDP, length 350
```

Do a awk on logfile, to print uniq counts, to easy verify expected results
```
cat /tmp/tcpdump.log | awk '{ print substr($1, 1, length($1) - 10) }' | sort | uniq -c
      6 10:29
      6 10:30
      6 10:31
      5 10:32
```

As you can see above, missing the last expected packet (10.32:57), but this was just "for show". Could also do an additional `sort`, to show differences, or just remove the lines with expected results, e.g.
`cat /tmp/tcpdump.log | awk '{ print substr($1, 1, length($1) - 10) }' | sort | uniq -c | grep -v "6 ..:" ` would only display
```
      5 10:32
```

> Oh, and in this specific case, we actually found one "extra heartbeat" pr. minute when the host disconnected (that's 7 - seven).


### Links
* https://www.tcpdump.org/manpages/tcpdump.1.html
* https://danielmiessler.com/study/tcpdump/


## Microsoft
Measure size (length) on all items in this folder
```powershell
"{0:N2} GB" -f ((Get-ChildItem -Path . -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)
```

Disable Google Updater on all matching objects (well, two-liner, but who's counting?)
```powershell
$servers = (Get-ADComputer -Filter * -Property * | Where-Object operatingsystem -Like windows*server* | Where-Object name -Like srv-p-*)
foreach ($server in $servers) {Invoke-Command -ComputerName $server.name {Get-Service -name gupdate | Set-Service -StartupType Disabled}}
```

Invert Mouse Scrolling (MacOS, huh?)
```
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Enum\HID\*\*\Device` Parameters FlipFlopWheel -EA 0 | ForEach-Object { Set-ItemProperty $_.PSPath FlipFlopWheel 1 }
```
Needs reboot or trigger change


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
