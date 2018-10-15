# Quick information
# * Find files, based on criteria, e.g. *.nst-files
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
$files = Get-ChildItem $targetfolder -include $extension -Recurse | where {$_.LastwriteTime -lt "$lastwrite"}
# measure the total size of files that will be deleted
$totalSize = ($files | Measure-Object -Sum Length).Sum / 1GB
Write-Host Total size on all files is: $totalSize -ForegroundColor Green
# delete files
foreach ($File in $Files)
{
    if ($File -ne $Null)
    {
        Write-Host "Deleting file $File" -backgroundcolor "DarkRed"
        Remove-item $File.Fullname | out-null
    }
    else
    {
        Write-host "No more files to delete" -forgroundcolor "Green"
    }
}
# ####################################################################################################################