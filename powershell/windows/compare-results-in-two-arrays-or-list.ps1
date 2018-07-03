# Compare results of two arrays
$src = gci -file "C:\temp\powershell\src" -recurse | select -ExpandProperty Name
$dst = gci -file "C:\temp\powershell\dst" -recurse | select -ExpandProperty Name

$src | ?{$dst -notcontains $_}


# A little more complex - compare results of two arrays - find reparsepoint files (ignore folders)
#$src = gci -file "C:\temp\powershell\src" -recurse | where {$_.attributes -match 'ReparsePoint' -and ! $_.PSIsContainer } | select -ExpandProperty name
#$dst = gci -file "C:\temp\powershell\dst" -recurse |  where {! $_.PSIsContainer } | select -ExpandProperty name
#$src | ?{$dst -notcontains $_}
# Measure results, and display count
#$dst | measure | % {$_.count }
#$src | measure | % {$_.count }


# Same, but with Compare-Object
# Compare-Object $src $dst | ?{$_.SideIndicator -eq '<='} | Select-Object -ExpandProperty InputObject