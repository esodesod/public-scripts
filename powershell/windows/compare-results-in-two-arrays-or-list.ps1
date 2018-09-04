# Compare array of files, based on name only.
# Filters: Files only - NOTE: Older PowerShell may not understand "-file". May use where {! $_.PSIsContainer }
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = Get-ChildItem -file $root_src -recurse | Select-Object -ExpandProperty Name
$files_dst = Get-ChildItem -file $root_dst -recurse | Select-Object -ExpandProperty Name
# Compare
$files_src | Where-Object{$files_dst -notcontains $_}

# Compare two sources, and include path from fullname, but replace parts (e.g. keep folder structure)
# Compare results of two arrays
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = Get-ChildItem -file $root_src -recurse | Select-Object -ExpandProperty fullname
$files_dst = Get-ChildItem -file $root_dst -recurse | Select-Object -ExpandProperty fullname
$files_src.replace("$root_src","ROOT") | Where-Object{$files_dst.replace("$root_dst","ROOT") -notcontains $_}

# Compare array of files, based on fullname, but replace ROOT
# Filters: Find reparsepoint in src, and ignore folders (both)
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = Get-ChildItem $root_src -recurse | Where-Object {$_.attributes -match 'ReparsePoint' -and ! $_.PSIsContainer } | Select-Object -ExpandProperty fullname
$files_dst = Get-ChildItem $root_dst -recurse | Where-Object {! $_.PSIsContainer } | Select-Object -ExpandProperty fullname
# Measure results, and display count
$files_src | Measure-Object | ForEach-Object {$_.count }
$files_dst | Measure-Object | ForEach-Object {$_.count }
# Compare results, including folder structure
($files_src).replace("$root_src","ROOT") | Where-Object{($files_dst).replace("$root_dst","ROOT") -notcontains $_}
# Compare results, but using Compare-Object (faster)
Compare-Object -ReferenceObject $(($files_src).replace("$root_src","ROOT")) -DifferenceObject $(($files_dst).replace("$root_dst","ROOT")) | Where-Object { $_.SideIndicator -eq '<=' }
Compare-Object -ReferenceObject $(($files_src).replace("$root_src","ROOT")) -DifferenceObject $(($files_dst).replace("$root_dst","ROOT")) | Where-Object { $_.SideIndicator -eq '<=' } | Measure-Object | ForEach-Object {$_.count }

# Compare-Object
$text_src = "C:\temp\src.txt"
$text_dst = "C:\temp\dst.txt"
Compare-Object -ReferenceObject $(Get-Content $text_src) -DifferenceObject $(Get-Content $text_dst)


# Compare array of files, based on fullname, but replace parts of fullname with ROOT (e.g. beginning)
# Filters: Find ReparsePoint in SRC, and only files (ignore olders)
# NOTE: Older PowerShell may not understand "-file". May use where {! $_.PSIsContainer }
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
$files_src = Get-ChildItem -file $root_src -recurse | Where-Object {$_.attributes -match 'ReparsePoint'} | Select-Object -ExpandProperty fullname
$files_dst = Get-ChildItem -file $root_dst -recurse | Select-Object -ExpandProperty fullname
# Measure results, and display count
$files_src | Measure-Object | ForEach-Object {$_.count }
$files_dst | Measure-Object | ForEach-Object {$_.count }
# Compare results, using Compare-Object
$compare_src = ($files_src).replace("$root_src","ROOT")
$compare_dst = ($files_dst).replace("$root_dst","ROOT")
Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' }
# Compare-Object. Measure left only (count)
Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' } | Measure-Object | ForEach-Object {$_.count }