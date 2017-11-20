#Check cmdlets in conflict (duplicates)
gcm -type cmdlet,function,alias | group name | where { $_.count -gt 1 }

#Remove Hyper-V module
(Get-Module -Name Hyper-V) | Remove-Module -Force