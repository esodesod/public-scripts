# Compare files in two directories, based on fullname
# Replace parts of fullname with "ROOT" (e.g. beginning of an path)
# Filters:
# * Find ReparsePoints in SRC
# * Only files (ignore folders)
# NOTE: Older PowerShell may not understand "-file". May use where {! $_.PSIsContainer }

# Set variables
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
# Get files from both directories. Only ReparsePoints files from source
$files_src = Get-ChildItem -file $root_src -recurse | Where-Object {$_.attributes -match 'ReparsePoint'} | Select-Object -ExpandProperty fullname
$files_dst = Get-ChildItem -file $root_dst -recurse | Select-Object -ExpandProperty fullname
# Do a simple "measure" to display count of files
$files_src | Measure-Object | ForEach-Object {$_.count }
$files_dst | Measure-Object | ForEach-Object {$_.count }
# Set compare variables, using previous variables, and replace parts of fullpath
$compare_src = ($files_src).replace("$root_src","ROOT")
$compare_dst = ($files_dst).replace("$root_dst","ROOT")
# Do a compare. Get "left only" objects
$compare_left_only_objects = Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' }
# Count results
$compare_left_only_objects | Measure-Object | ForEach-Object {$_.count }
# Show results
$compare_left_only_objects

# Do a new compare, and time (measure) command
Measure-Command { Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' } }

# Do a compare. Get "identical" objects
$compare_identical_objects = Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' }
# Count results
$compare_identical_objects | Measure-Object | ForEach-Object {$_.count }
# Show results
$compare_identical_objects