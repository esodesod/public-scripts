$allDCs = (Get-ADForest).Domains | ForEach-Object { Get-ADDomainController -Filter * -Server $_ }
$serverlist = ($allDCs.name)

foreach ($server in $serverlist) {
        if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
                Write-Host "$server is responding" -ForegroundColor Green
                }
                else {
                Write-Host "$server is not responding" -ForegroundColor Red
                }
}