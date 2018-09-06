# Compare files in two directories, based on fullname
# Replace parts of fullname with "ROOT" (e.g. beginning of an path)
# Filters:
# * Find ReparsePoints in SRC
# * Only files (ignore folders)
# NOTE: Older PowerShell may not understand "-file". May use where {! $_.PSIsContainer }

# Set source and destination for compare
$root_src = "C:\temp\powershell\src"
$root_dst = "C:\temp\powershell\dst"
# Get all files from both directories
# Filter: Only ReparsePoints files from source
$files_src = Get-ChildItem -file $root_src -recurse | Where-Object {$_.attributes -match 'ReparsePoint'} | Select-Object -ExpandProperty fullname
$files_dst = Get-ChildItem -file $root_dst -recurse | Select-Object -ExpandProperty fullname
# Measure (count) objects in both locations
Write-Host "Count of files found in $root_src"
$files_src | Measure-Object | ForEach-Object {$_.count }
Write-Host "Count of files found in $root_dst"
$files_dst | Measure-Object | ForEach-Object {$_.count }
# Set compare variables, using previous variables, and replace parts of fullpath
$compare_src = ($files_src).replace("$root_src","ROOT")
$compare_dst = ($files_dst).replace("$root_dst","ROOT")

# -------------------------
# --- COMPARE LEFT ONLY ---
# -------------------------
# Do a compare. Get "left only" objects
$compare_left_only_objects = Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' }
# Count results
Write-Host "Count of files: LEFT ONLY / MISSING IN $root_dst"
$compare_left_only_objects | Measure-Object | ForEach-Object {$_.count }
# Show results
Write-Host "Files: LEFT ONLY / MISSING IN $root_dst"
$compare_left_only_objects

# -------------------------
# --- COMPARE IDENTICAL ---
# -------------------------
# Do a compare. Get "identical" objects
$compare_identical_objects = Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' }
# Count results
Write-Host "Count of files: IDENTICAL / found in both directories"
$compare_identical_objects | Measure-Object | ForEach-Object {$_.count }
# Show results
Write-Host "Files: IDENTICAL / found in both directories"
$compare_identical_objects

# -------------------------
# --- TIMINGS ---
# -------------------------
# Do a new compare, and time (measure) command
Write-Host "Timing compare of LEFT ONLY objects"
Measure-Command { Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' } }
Write-Host "Timing compare of IDENTICAL objects"
Measure-Command { Compare-Object -ReferenceObject $compare_src -DifferenceObject $compare_dst -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' } }
