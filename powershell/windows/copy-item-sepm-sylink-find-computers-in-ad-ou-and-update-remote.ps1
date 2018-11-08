# About: Espen Ødegaard / esod.no / Twitter: @esodesod
# Copy and re-use as you may like!
# ###################################################################################################################
# Script to update SEPM SyLink.xml-file on computers in a given OU i AD
#
# For reference - paths to SEPM configuration folder on local computer
# * Variable-way: "%allusersprofile%\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config"
# * Hard coded, 1999-way: "C:\ProgramData\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config"
# ###################################################################################################################

# Remote session?
<#
# Ask & save credential to variable, if not using current
$cred = Get-Credential
Enter-PSSession server.domain.tld -Credential $cred
#>

# ###################################################################################################################
# Set variables
$computers = Get-ADComputer -Filter * -SearchBase "OU=Computers,DC=domain,DC=local"
$sylink_local_path = "c$\ProgramData\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config\"
$sylink_fixed_file = "\\computer-esod\shared$\symantec\SyLink.xml"

# ###################################################################################################################
# Check if file is reachable on each computer object, and display the results
foreach ($computer in $computers) {
    $sylink_local_file = ("\\" + $computer.dnshostname + "\" + $sylink_local_path + "SyLink.xml")
    # Check if file is reachable, then
    Write-Host $computer.Name "Trying to update..." -ForegroundColor DarkBlue
    if ( Test-Path $sylink_local_file ) {
        Write-Host $computer.Name "File $sylink_local_file is accessible, will try to copy new one" -ForegroundColor DarkBlue
        # Copy new SyLink.xml-file to destination if computer is online
        $copyjob = Copy-Item -Path $sylink_fixed_file -Destination $sylink_local_file -Force -PassThru -ErrorAction SilentlyContinue
            if ($copyjob) { Write-Host $computer.Name "File is now replaced - sayonara, broken configuration file!" -ForegroundColor Green }
            else { Write-Host $computer.Name "Copying failed. Do yo have permission?" -ForegroundColor Yellow }
        
        }
    # If file is NOT reachable, display that as well.
    if ( -not (Test-Path $sylink_local_file) ) {
        Write-Host $computer.Name "is not reachable. Online? Permission?" -ForegroundColor DarkRed
        }
    }
# ###################################################################################################################