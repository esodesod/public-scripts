# Ask & save credential to variable
$cred = Get-Credential

# See https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/running-remote-commands?view=powershell-6
$s = New-PSSession computer1,computer2,computer3 -Credential $cred
Invoke-Command -Session $s {ls C:\win*}