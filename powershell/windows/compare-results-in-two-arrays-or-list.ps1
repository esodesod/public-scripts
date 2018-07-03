# Compare results of two arrays
$src = gci "C:\temp\powershell\src" -recurse | select -ExpandProperty Name
$dst = gci "C:\temp\powershell\dst" -recurse | select -ExpandProperty Name

$src | ?{$dst -notcontains $_}

# Same, but with Compare-Object
# Compare-Object $src $dst | ?{$_.SideIndicator -eq '<='} | Select-Object -ExpandProperty InputObject