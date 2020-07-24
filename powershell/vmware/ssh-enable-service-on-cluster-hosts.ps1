# Set cluster name
$cluster = "cluster-01-name"

# Get hosts in cluster, and enable TSH-SSH on all hosts
Get-Cluster -name $cluster | Get-VMhost | Foreach {
    Write-Host "Enabling SSH on server $($_.Name)"
    Get-VMHostService -VMHost $_ | Where { $_.Key -eq "TSM-SSH" } | Start-VMHostService
}