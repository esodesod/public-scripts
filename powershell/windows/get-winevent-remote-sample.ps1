$remote_client="pc-esod-01"
$log_since=(Get-Date).AddDays(-1).Date.AddHours(0)
$log_result_system=Get-WinEvent -ComputerName $remote_client -FilterHashtable @{ LogName='System'; StartTime=$log_since }
$log_result_system | Out-GridViewCode # Use regular GridView if GridViewCode-function is not available

$log_result_application=Get-WinEvent -ComputerName $remote_client -FilterHashtable @{ LogName='Application'; StartTime=$log_since }
$log_result_application | Out-GridViewCode # Use regular GridView if GridViewCode-function is not available

#$log_result_security=Get-WinEvent -ComputerName $remote_client -FilterHashtable @{ LogName='Security'; StartTime=$log_since }
#$log_result_security | Out-GridViewCode # Use regular GridView if GridViewCode-function is not available