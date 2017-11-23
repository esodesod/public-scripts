# Get nic stats for multiple nics on all hosts in a cluster

## VARIABLES
$clustername = "cluster-01"
$nicname1 = "vmnic4"
$nicname2 = "vmnic5"

## SCRIPT
$esxhosts = Get-Cluster -Name $clustername | get-vmhost
$output = foreach ($esxhost in $esxhosts)
    {
        try
        {
            $esxcli = get-vmhost $esxhost.name | get-esxcli
            Write-Host "Checking $esxhost.name" -ForegroundColor Green
            $esxcli.network.nic.stats.get("$nicname1") | select @{l="hostname";e={$esxhost.name}},NICName,ReceiveCRCerrors,ReceiveFIFOerrors,Receiveovererrors,Totalreceiveerrors,Totaltransmiterrors,Receivepacketsdropped,Receiveframeerrors,Receivelengtherrors,Receivemissederrors,TransmitFIFOerrors,Transmitabortederrors,Transmitcarriererrors,
Transmitheartbeaterrors,Transmitpacketsdropped,Transmitwindowerrors
            $esxcli.network.nic.stats.get("$nicname2") | select @{l="hostname";e={$esxhost.name}},NICName,ReceiveCRCerrors,ReceiveFIFOerrors,Receiveovererrors,Totalreceiveerrors,Totaltransmiterrors,Receivepacketsdropped,Receiveframeerrors,Receivelengtherrors,Receivemissederrors,TransmitFIFOerrors,Transmitabortederrors,Transmitcarriererrors,
Transmitheartbeaterrors,Transmitpacketsdropped,Transmitwindowerrors
        }
        catch
        {
        Write-Warning -Message "Error(s) in collecting from $esxhost.name manually"
        }
    }

# Output(s) to gridview
#$output | Out-GridView
$datetime = Get-Date -Format yyyy-MM-dd_HH-mm-ss
Write-Host "Results on $datetime" -ForegroundColor Yellow
$output | sort nicname | ft -AutoSize