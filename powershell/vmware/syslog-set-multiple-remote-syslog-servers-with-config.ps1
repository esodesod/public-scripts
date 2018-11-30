# PowerCLI Script to Configure NTP on ESXi Hosts
# Used as issues with "Remove-VMHostNTPServer" in PowerCLI (latest check 2018-11-30). This simply replaces it (working fine)
# Credits: andiwe79 / https://communities.vmware.com/thread/590014
$config = New-Object VMware.Vim.HostDateTimeConfig
$config.NtpConfig = New-Object VMware.Vim.HostNtpConfig
$config.NtpConfig.Server = New-Object String[] (2)
$config.NtpConfig.Server[0] = 'ntp.esod.local'
#$config.NtpConfig.Server[1] = '10.2.2.2'
$config.NtpConfig.ConfigFile = New-Object String[] (0)
# I don't want to change TC
#$config.TimeZone = 'UTC'

# Limit scope here
$vmhosts = Get-Cluster | Get-VMhost

foreach ($vmhost in $vmhosts) {
     $view = get-view $vmhost
     $_this = Get-View $view.ConfigManager.DateTimeSystem
     $_this.UpdateDateTimeConfig($config)
     Restart-VMHostService -HostService ($vmhost | Get-VMHostService | Where {$_.Key -eq "ntpd"}) -Confirm:$false
}