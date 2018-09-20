# Compare files in two directories, based on fullname
# Replace parts of fullname with "ROOT" (e.g. beginning of an path)
# Filters:
# * Find ReparsePoints in SRC (aka VAULT in this script)
# * Only files (ignore folders)
# NOTE: Older PowerShell may not understand "-file". May use where {! $_.PSIsContainer }

########################################
# Set source and destination for compare
$root_vault = "C:\temp\vault"
$root_dst = "C:\temp\dst"
# Get all files from both directories
# Filter: Only ReparsePoints files from destination (which we want to copy from vault drive)
$files_dst = Get-ChildItem -file $root_dst -recurse | Where-Object {$_.attributes -match 'ReparsePoint'}
$files_vault = Get-ChildItem -file $root_vault -recurse
# Measure (count) objects in both locations
Write-Host "Count of files found in $root_vault"
$files_vault | Measure-Object | ForEach-Object {$_.count }
Write-Host "Count of files found in $root_dst"
$files_dst | Measure-Object | ForEach-Object {$_.count }
# Set compare variables, using previous variables, and replace parts of fullpath, so compare will work
$compare_vault = ($files_vault.FullName).replace("$root_vault","ROOT")
$compare_dst = ($files_dst.FullName).replace("$root_dst","ROOT")


#################################
# Compare IDENTICAL objects
# Objects found in both locations
# We'll automate copying here!
#################################
# Do a compare. Get "identical" objects
$compare_identical_objects = Compare-Object -ReferenceObject $compare_dst -DifferenceObject $compare_vault -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' }
# Count results
Write-Host "Count of files: IDENTICAL / found in both directories"
$compare_identical_objects | Measure-Object | ForEach-Object {$_.count }
# Show results
Write-Host "Files: IDENTICAL / found in both directories"
$compare_identical_objects

###################################
# Compare LEFT ONLY objects
# Objects found in "left side" only
# Needs manual copying for now
###################################
# Do a compare. Get "left only" objects
$compare_left_only_objects = Compare-Object -ReferenceObject $compare_dst -DifferenceObject $compare_vault | Where-Object { $_.SideIndicator -eq '<=' }
# Count results
Write-Host "Count of files: LEFT ONLY / MISSING IN $root_dst"
$compare_left_only_objects | Measure-Object | ForEach-Object {$_.count }
# Show results
Write-Host "Files: LEFT ONLY / MISSING IN $root_dst"
$compare_left_only_objects

###################################
# Do timings
# How long does a command take?
# Run only if needed
###################################
# Do a new compare, and time (measure) command
Write-Host "Timing compare of LEFT ONLY objects"
Measure-Command { Compare-Object -ReferenceObject $compare_vault -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' } }
Write-Host "Timing compare of IDENTICAL objects"
Measure-Command { Compare-Object -ReferenceObject $compare_vault -DifferenceObject $compare_dst -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' } }
