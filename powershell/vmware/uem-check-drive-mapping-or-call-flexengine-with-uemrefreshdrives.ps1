# Created by Espen Ødegaard / Proact IT Norge AS
# PowerShell script to check if N: drive exists, else run FlexEngine with UemRefreshDrives
# Useful for delayed network sessions (e.g. slow access / VLAN switching, etc.)
# * If exists, exit script.
# * If not exist, call FlexEngine.exe with -UemRefreshDrives, and sleep N seconds.
# * Retry commands N times, before exiting.

# Variables
$check_drive = "N"
$check_path = "$($check_drive):"
$check_count = 1..6
$sleep_time = "10"

# Start logging
$scriptname = $($MyInvocation.MyCommand.Name)
Start-Transcript $env:temp\$scriptname.log -Append

# If $check_path does not exists
if ($(Test-Path $check_path) -eq $False) {
    # Try N times
    $check_count | ForEach-Object {
        # Re-check $check_path
        # If $check_path now exists, exit
        if ($(Test-Path $check_path) -eq $True) {
            Write-Host "INFO: I already have the drive $($check_path) mapped. Not calling FlexEngine.exe" -ForegroundColor Green
            exit 0
            }
        else {
            # Check failed, retry UemRefreshDrives
            Write-Host "INFO: Mappings needed, calling FlexEngine.exe with -UemRefreshDrives. Attempt $_" -ForegroundColor DarkGray
            # Call FlexEngine.exe with -UemRefreshDrives
            & "$env:programfiles\Immidio\Flex Profiles\FlexEngine.exe" -UemRefreshDrives
            Write-Host "INFO: Called FlexEngine.exe with -UemRefreshDrives" -ForegroundColor Green
            # Sleep N seconds
            Start-Sleep $sleep_time
            }
        }
    }
else {
    Write-Host "INFO: I already have the drive $($check_path) mapped. Not calling FlexEngine.exe" -ForegroundColor Green
    exit 0
    }

<# Troubleshoot
Get-PSDrive
Get-PSDrive $check_drive
Get-PSDrive $check_drive | Remove-PSDrive -Force
net use
net use /d $check_path
#>

# Stop logging
Stop-Transcript