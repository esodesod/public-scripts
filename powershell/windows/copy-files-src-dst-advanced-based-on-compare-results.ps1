<#
# Espen Ødegaard / esod.no / Twitter: @esodesod
# Copy and re-use as you may like!
# ####################################################################################################################
# Created for customer, based the following needs
# * Find files from archive solution (vault).
# * Match files in production file cluster (with "broken files", e.g. file attributes Offline and/or an invalid ReparsePoint)
# * Replace "broken files" with working files, retrieved from previous vault extraction (in seperate volume)
# 
# In short, we do this:
# * Compare files in two directories, based on fullname (e.g. archive and production)
# * Replace parts of fullname with "ROOT" (e.g. beginning of an path), so we may compare (identical, left only, e.g)
#     Filters:
#       * Find ReparsePoints in source (aka "VAULT" in this script)
#       * Only search files (ignore folders)
# * After finding matching files (located in both directories)
#   * Delete "broken file" in destination (because it's Offline and/or an invalid ReparsePoint, in this case)
#   * Copy file from vault to destination
#   * Replace specific file attributes in destination file (from source file)
# 
# Notes:
# * Tested with WMF & PSVersion 5.1
# * Older PowerShell may not understand e.g. "-file" (could use "{! $_.PSIsContainer }", but hey.. why not upgrade
# * Files with braces, e.g. file[1].pdf will sometimes have trouble reading ItemProperties (e.g. CreationTime)
#   - Manually fix for now, but may be scripted, if many occurrences
# ####################################################################################################################
#>

<#
# Be awesome. Do a remote session?
# ####################################################################################################################
# Ask & save credential to variable, if not using current
$cred = Get-Credential
Enter-PSSession server.domain.tld -Credential $cred
# ####################################################################################################################
#>

#<#
# ####################################################################################################################
# Set variables, and do a quick measure (count)
#
# Set source and destination for compare
$root_vault = "C:\temp\vault"
$root_dst = "C:\temp\dst"
$files_left_only_logfile = "C:\temp\files_left_only.txt"
# Get all files from both directories
$files_vault = Get-ChildItem -file $root_vault -recurse
# Filter: Only ReparsePoints files from destination (which we want to copy from vault drive)
$files_dst = Get-ChildItem -file $root_dst -recurse | Where-Object {$_.attributes -match 'ReparsePoint'}
# Measure (count) objects in both locations
Write-Host "Count of files found in $root_vault"
$files_vault | Measure-Object | ForEach-Object {$_.count }
Write-Host "Count of files (ReparsePoint only) found in $root_dst"
$files_dst | Measure-Object | ForEach-Object {$_.count }
# Set compare variables, using previous variables, and replace parts of fullpath, so compare will work
$compare_vault = ($files_vault.FullName).replace("$root_vault","ROOT")
$compare_dst = ($files_dst.FullName).replace("$root_dst","ROOT")
# ####################################################################################################################
#>

#<#
# ####################################################################################################################
# Compare IDENTICAL (==) / MATCHING objects
# In other words: objects found in both locations - we'll automate copying here!
#
# Do a compare. Get "identical" objects (==)
$compare_identical_objects = Compare-Object -ReferenceObject $compare_dst -DifferenceObject $compare_vault -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' }
# Count results
Write-Host "Count of MATCHING files (both in source, and as ReparsePoint)"
$compare_identical_objects | Measure-Object | ForEach-Object {$_.count }
# Show results (uncomment section below, or run selected parts of script)
<#
Write-Host "Display MATCHING files, if any (located as both ReparsePoint and in source)"
$compare_identical_objects
#>
# ####################################################################################################################
#>

#<#
# ####################################################################################################################
# Copy IDENTICAL (==) / MATCHING objects
# NOTE: If files include special characters, e.g. brackets, use "-LiteralPath" (see added sample later in this script)
$files_identical_src = ($compare_identical_objects.InputObject).replace("ROOT","$root_vault")

# Loop trough each file from compare results, where files have identical fullname MATCH, in both source and destination
foreach ($srcfile in $files_identical_src) {
    # Build destination file fullname, based on source fullname
    # Note: Use [io.FileInfo] to get existing file information
    $dstfile = [io.FileInfo]($srcfile).replace("$root_vault","$root_dst")
    
    # Remove destination file first (which is "offline" and inaccessible, and can't be "overwritten")
    if ($dstfile.Exists) { Remove-Item $dstfile }
  
    # Copy source file to destination
    Copy-Item $srcfile $dstfile

    # Copy specific file attributes from source to destination
    if ($dstfile.Exists) {
      $dstfile.CreationTime = (Get-ItemProperty $srcfile).CreationTime
      $dstfile.LastAccessTime = (Get-ItemProperty $srcfile).LastAccessTime
      $dstfile.LastWriteTime = (Get-ItemProperty $srcfile).LastWriteTime
      $dstfile.Attributes = (Get-ItemProperty $srcfile).Attributes
    }
  }
# ####################################################################################################################
#>










<#
# Uncomment section, or run selected parts of script
# ####################################################################################################################
# Other useful snippets
# ####################################################################################################################
# ####################################################################################################################
# Compare LEFT ONLY objects
# In other words: objects only found on "left side" (e.g. in destination, but not in source).
# Needs manual copying for now
#
# Do a compare. Get "left only" objects
$compare_left_only_objects = Compare-Object -ReferenceObject $compare_dst -DifferenceObject $compare_vault | Where-Object { $_.SideIndicator -eq '<=' }
# Count results
Write-Host "Count of files: LEFT ONLY / MISSING IN $root_dst"
$compare_left_only_objects | Measure-Object | ForEach-Object {$_.count }
# Generate list og files
$files_left_only = ($compare_left_only_objects.InputObject).Replace("ROOT","$root_dst")
# Export list
$files_left_only | Out-File $files_left_only_logfile
# Show results
Write-Host "Files: LEFT ONLY / MISSING IN $root_dst"
$files_left_only
#>

<#
# Uncomment section, or run selected parts of script
# ####################################################################################################################
# Copy IDENTICAL (==) / MATCHING objects
# NOTE: with SPECIAL CHARACTERS, e.g. brackets "[]" in name
# NOTE: * use "LiteralPath" (or replace brackets)
$files_identical_src = ($compare_identical_objects.InputObject).replace("ROOT","$root_vault")

# Loop trough each file from compare results, where files have identical fullname MATCH, in both source and destination
foreach ($srcfile in $files_identical_src) {
    # Build destination file fullname, based on source fullname
    # Note: Use [io.FileInfo] to get existing file information
    $dstfile = [io.FileInfo]($srcfile).replace("$root_vault","$root_dst")

    # Remove destination file first (which is "offline" and inaccessible, and can't be "overwritten")
    #if ($dstfile.Exists) { Remove-Item $dstfile }
    if ($dstfile.Exists) { Remove-Item -LiteralPath $dstfile }
    
    # Copy source file to destination
    #Copy-Item $srcfile $dstfile
    Copy-Item -LiteralPath $srcfile $dstfile

    # Copy specific file attributes from source to destination
    if ($dstfile.Exists) {
      $dstfile.CreationTime = (Get-ItemProperty -LiteralPath $srcfile).CreationTime
      $dstfile.LastAccessTime = (Get-ItemProperty -LiteralPath $srcfile).LastAccessTime
      $dstfile.LastWriteTime = (Get-ItemProperty -LiteralPath $srcfile).LastWriteTime
      $dstfile.Attributes = (Get-ItemProperty -LiteralPath $srcfile).Attributes
    }
  }
# ####################################################################################################################
#>

<#
# Uncomment section, or run selected parts of script
# ####################################################################################################################
# Do TIMINGS of commands
# Do timings
# How long does a command take?
# Run only if needed
###################################
# Do a new compare, and time (measure) command
Write-Host "Timing compare of LEFT ONLY objects"
Measure-Command { Compare-Object -ReferenceObject $compare_vault -DifferenceObject $compare_dst | Where-Object { $_.SideIndicator -eq '<=' } }
Write-Host "Timing compare of IDENTICAL objects"
Measure-Command { Compare-Object -ReferenceObject $compare_vault -DifferenceObject $compare_dst -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' } }
#>