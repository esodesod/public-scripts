$servers=$(Get-Content C:\temp\list.txt)
$result = foreach ($server in $servers) {
Write-Host "Checking $server"
Test-Connection $server -ResolveDestination -Count 1 -TimeoutSeconds 10 #| Format-Table $server,address,status,latency
}


$job = Start-Job -ScriptBlock { Test-Connection -TargetName (Get-Content -Path "C:\temp\list.txt") -ResolveDestination -Count 1 -TimeoutSeconds 10 }
$results = Receive-Job $job -Wait



foreach ($ip in ($results_success)) {
    Write-Host "Checking $($ip.address) / $($ip.destination)"
    # Test IP with .NET module
    [System.Net.Dns]::GetHostEntry($($ip.address)).HostName
}


foreach ($ip in ($results_success)) {
    Write-Host "Checking $($ip.address)" -ForegroundColor DarkGray
    # Clean any previous errors first
    $error.clear()
    # Test IP with .NET "GetHostEntry"
    try { [System.Net.Dns]::GetHostEntry($($ip.address)).HostName }
    # Catch errors, and report
    catch {
        Write-Host "Failed reverse on $($ip.address), which should resolve in $($ip.destination)" -ForegroundColor Red
    }
}