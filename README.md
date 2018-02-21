# Scripts
> Will probably add some comments here, #someday.


# One-liners

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
