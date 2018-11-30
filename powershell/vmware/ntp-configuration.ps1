# PowerCLI Script to Configure NTP on ESXi Hosts
# PowerCLI Session must be connected to vCenter Server using Connect-VIServer
# Check http://www.vhersey.com/2013/10/setting-esxi-dns-and-ntp-using-powercli/

# Check NTP configuration
Get-VMHost | Select-Object Name,@{Name="NTPServer";Expression={$_ | Get-VMHostNtpServer}}, @{Name="NTPRunning";Expression={($_ | Get-VMHostService | Where-Object {$_.key -eq "ntpd"}).Running}} | Sort-Object -Property "NTPRunning", "NTPServer"

#Prompt for NTP Servers
$ntpone = read-host "Enter NTP Server One"
$ntptwo = read-host "Enter NTP Server Two"
#Or just set them directly here
$ntpone = "xx.xx.xx.xx"
$ntptwo = "yy.yy.yy.yy"

# Select hosts/cluster/datacenter
$esxHosts = get-vmHost

# Configure NTP
foreach ($esx in $esxHosts) {

   Write-Host "Configuring NTP Servers on $esx" -ForegroundColor Green
   Add-VMHostNTPServer -NtpServer $ntpone , $ntptwo -VMHost $esx -Confirm:$false

   Write-Host "Configuring NTP Client Policy on $esx" -ForegroundColor Green
   Get-VMHostService -VMHost $esx | where{$_.Key -eq "ntpd"} | Set-VMHostService -policy "on" -Confirm:$false

   Write-Host "Restarting NTP Client on $esx" -ForegroundColor Green
   Get-VMHostService -VMHost $esx | where{$_.Key -eq "ntpd"} | Restart-VMHostService -Confirm:$false

}
Write-Host "Done!" -ForegroundColor Green