# Created by Espen Ødegaard / Proact IT Norge AS
# PowerShell script to check if path exists (True vs False)
# Useful for delayed network sessions (e.g. slow access / VLAN switching, etc.)
# * Try N times
# * Sleep N seconds

# Start logging
$scriptname = $($MyInvocation.MyCommand.Name)
Start-Transcript $env:temp\$scriptname.log -Append

# Variables
$check_path = "\\domain.tld\share\path"
$check_count = 1..1000
$sleep_time = "1"


# Run script
# Try N times
$check_count | ForEach-Object {
    # Test-Path
    if ($(Test-Path $check_path) -eq $True) {
        Write-Host "INFO: Attempt $($_)/$($check_count.Count) - command 'Test-Path $($check_path)' results in success (True). Folder may be accessed" -ForegroundColor Green
        Write-Host "INFO: Attempt $($_)/$($check_count.Count) - Sleeping 10 seconds, then exiting script with exit code success" -ForegroundColor DarkGray
        Start-Sleep 10
        exit 0
        }
    else {
        # Retry Test-Path
        Write-Host "INFO: Attempt $($_)/$($check_count.Count) - command 'Test-Path $($check_path)' results in failure (False). Folder not available yet" -ForegroundColor Red
        # Sleep N seconds
        Write-Host "INFO: Attempt $($_)/$($check_count.Count) - Sleeping 1 second, then retry command" -ForegroundColor DarkGray
        Start-Sleep $sleep_time
        }
}

# Stop logging
Stop-Transcript