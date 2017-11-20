#Check cmdlets in conflict (duplicates)
gcm -type cmdlet,function,alias | group name | where { $_.count -gt 1 }

#Remove Hyper-V module
(Get-Module -Name Hyper-V) | Remove-Module -Force

#Get all VMware modules
Get-Module -ListAvailable VMware*

#Import all VMware modules
Get-Module -ListAvailable VMware* | Import-Module

#Connect vCenter (ask for usename/pwd)
Connect-ViServer -Server vc.domain.tld
