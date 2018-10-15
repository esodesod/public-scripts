# Quick information
# * Find files, based on criteria (in this case; *.nst-files, length (size) over "16818176" and lastewrite)
# * If found, based on criteria, remove files older then x-days (e.g. based on lastewrite / modified date)
# ####################################################################################################################

# ####################################################################################################################
# Remote PSSession? Run snippet below
<#
# Ask & save credential to variable, if not using current
$cred = Get-Credential
Enter-PSSession server.domain.tld -Credential $cred
#>
# ####################################################################################################################

# ####################################################################################################################
# Set variables
$now = Get-Date
# amount of days to add in search
$days = "8"
$lastwrite = $now.AddDays(-$days)
# folder to search
$targetfolder = "O:\appdata-outlook"
# file extension
$extension = "*.nst"
# ####################################################################################################################

# ####################################################################################################################
# get files based on lastwrite
$files = Get-ChildItem $targetfolder -include $extension -Recurse | Where-Object {$_.LastwriteTime -lt "$lastwrite" -and $_.Length -gt "16818176"}
# show files (run manually or uncomment section)
<#
# show files, sort by "default"
Write-Output $files | Select-Object fullname,@{Name='SizeMB';Expression={$_.Length / 1MB}} | Format-Table -AutoSize

# show files, sort by length (size)
Write-Output $files | Sort-Object length -desc | Select-Object fullname,@{Name='SizeMB';Expression={$_.Length / 1MB}} | Format-Table -AutoSize

# measure the total length (size) of all files that will be deleted
$totalSize = ($files | Measure-Object -Sum Length).Sum / 1GB
Write-Host Total size on all files is: $totalSize -ForegroundColor Green
#>

# delete files
foreach ($file in $files)
{
    if ($file -ne $null)
    {
        Write-Host "Deleting file $file" -backgroundcolor "DarkRed"
        Remove-item $file.Fullname | out-null
    }
    else
    {
        Write-host "No more files to delete" -forgroundcolor "Green"
    }
}
# ####################################################################################################################