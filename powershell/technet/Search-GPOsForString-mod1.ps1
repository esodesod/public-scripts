######################################################### 
# 
# Name: Search-GPOsForString.ps1 
# Author: Tony Murray 
# Version: 1.0 
# Date: 13/07/2016 
# Comment: Simple search for GPOs within a domain that match a given string 
# ----------
# Mods by Espen Ødegaard
# * Added simple filter on GPO Name
# * Added output of "hits" (matches) in result
# * Don't output non-matching GPOs (sorry, but I really don't care about non-matching GPOs :-)
######################################################## 
 
# Get the string we want to search for 
$string = "search string"

# Set the domain to search for GPOs 
$DomainName = $env:USERDNSDOMAIN
 
# Find all GPOs in the current domain 
write-host "Finding all the GPOs in $DomainName" 
Import-Module grouppolicy 
$allGposInDomain = Get-GPO -All -Domain $DomainName # | Where-Object DisplayName -Match "^RTM*"
 
# Look through each GPO's XML for the string 
Write-Host "Starting search for $string" 
foreach ($gpo in $allGposInDomain) { 
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml 
    if ($report -match $string) { 
        write-host "********** Match found in: $($gpo.DisplayName) **********"
        $report | findstr -i "$string"
    } # end if 
    else { 
        #Write-Host "No match in: $($gpo.DisplayName)" 
    } # end else 
} # end foreach 
