# Set Syslog, Firewall Exception (rule) & Reload Syslog agent
# Based on http://blogs.vmware.com/vsphere/2013/07/log-insight-bulk-esxi-host-configuration-with-powercli.html
# Modified
# * Removed serverport, as not supported when setting multiple syslog servers (set in logservers variable instead)
# * Added reset of syslog ($null value), before applying the new values

# Use DNS if only one syslog server.
# Use IP if multiple (else error of command output validation on the "Set-VMHostSysLogServer" - maybe fixed in future releases)
$logserver = "udp://11.11.11.11:514","udp://22.22.22.22:514"

Get-VMHost | Foreach {
    Write-Host "Adding $logserver as syslog server for $($_.Name)"
    $SetSyslog = Set-VMHostSysLogServer -SysLogServer $null -VMHost $_
    $SetSyslog = Set-VMHostSysLogServer -SysLogServer $logserver -VMHost $_
    Write-Host "Reloading Syslog on $($_.Name)"
    $Reload = (Get-ESXCLI -VMHost $_).System.Syslog.reload()
    Write-Host "Setting firewall to allow Syslog out of $($_)"
    $FW = $_ | Get-VMHostFirewallException | Where {$_.Name -eq 'syslog'} | Set-VMHostFirewallException -Enabled:$true
}