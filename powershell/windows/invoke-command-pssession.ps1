# Ask & save credential to variable
$cred = Get-Credential

# See https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/running-remote-commands?view=powershell-6

# One compute directly
Invoke-Command -ComputerName computer1 {get-eventlog system | where-object {$_.eventid -eq 1074} | select -first 10} -Credential $cred | Out-GridView

# Multiple computers at once
$s = New-PSSession computer1,computer2,computer3 -Credential $cred
Invoke-Command -Session $s {ls C:\win*}

