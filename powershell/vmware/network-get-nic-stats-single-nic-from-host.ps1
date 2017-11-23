# Get nic stats for a single host

## VARIABLES
$nicname = "vmnic4"
$esxhost = "esx-01.esod.local"

## SCRIPT
$esxcli=Get-EsxCli -VMHost $esxhost
$esxcli.network.nic.stats.get("$nicname") | select @{l="hostname";e={$esxhost}},NICName,ReceiveCRCerrors,ReceiveFIFOerrors,Receiveframeerrors,Receivelengtherrors,Receivemissederrors,Receiveovererrors,Receivepacketsdropped,Totalreceiveerrors,Totaltransmiterrors,TransmitFIFOerrors,Transmitabortederrors,Transmitcarriererrors,
Transmitheartbeaterrors,Transmitpacketsdropped,Transmitwindowerrors