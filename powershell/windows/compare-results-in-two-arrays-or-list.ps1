# Compare array of files, based on name only.
# Filters: Files only - NOTE: Older PowerShell may not understand "-file". May use where {! $_.PSIsContainer }
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = gci -file $root_src -recurse | select -ExpandProperty Name
$files_dst = gci -file $root_dst -recurse | select -ExpandProperty Name
# Compare
$files_src | ?{$files_dst -notcontains $_}


# Compare array of files, based on name only.
# Filters: Find reparsepoint in src, and ignore folders (both)
#$root_src = "C:\temp\powershell\src"
#$root_dst = "C:\temp\powershell\dst"
#$files_src = gci -file $root_src -recurse | where {$_.attributes -match 'ReparsePoint' -and ! $_.PSIsContainer } | select -ExpandProperty name
#$files_dst = gci -file $root_dst -recurse |  where {! $_.PSIsContainer } | select -ExpandProperty name
#$files_src | ?{$files_dst -notcontains $_}
# Measure results, and display count
#$files_src | measure | % {$_.count }
#$files_dst | measure | % {$_.count }

# Compare two sources, and include path from fullname, but replace parts (e.g. keep folder structure)
# Compare results of two arrays
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = gci -file $root_src -recurse | select -ExpandProperty fullname
$files_dst = gci -file $root_dst -recurse | select -ExpandProperty fullname
$files_src.replace("$root_src","ROOT") | ?{$files_dst.replace("$root_dst","ROOT") -notcontains $_}

# Compare array of files, based on fullname, but replace ROOT
# Filters: Find reparsepoint in src, and ignore folders (both)
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = gci $root_src -recurse | where {$_.attributes -match 'ReparsePoint' -and ! $_.PSIsContainer } | select -ExpandProperty fullname
$files_dst = gci $root_dst -recurse |  where {! $_.PSIsContainer } | select -ExpandProperty fullname
# Measure results, and display count
$files_src | measure | % {$_.count }
$files_dst | measure | % {$_.count }
# Compare results, including folder structure
($files_src).replace("$root_src","ROOT") | ?{($files_dst).replace("$root_dst","ROOT") -notcontains $_}