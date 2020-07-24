# Remove Hyper-V modules, cause in conflict with VMware admins (modules)
(Get-Module -Name Hyper-V) | Remove-Module -Force -ErrorAction SilentlyContinue

# Set policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#<# Test paths for PowerShell functions
$test_esod_functions_path_userprofile = "$($env:USERPROFILE)\GitHub\esodesod\scripts\powershell\functions"
if (Test-Path $test_esod_functions_path_userprofile) {
    $result_esod_functions_path = $test_esod_functions_path_userprofile
    Write-Host "INFO: Found PowerShell functions in $result_esod_functions_path" -ForegroundColor DarkGray
}
#>

#<# Load PowerShell functions, if available
if (Test-Path $result_esod_functions_path) {
    Write-Host "INFO: Loading functions from path $($result_esod_functions_path)" -ForegroundColor DarkGray
    Get-ChildItem "$($result_esod_functions_path)\*.ps1" | ForEach-Object {
        Write-Host "INFO: Loading $_" -ForegroundColor DarkGray
        .$_
    }
    Write-Host "Custom esod.no PowerShell environment loaded" -ForegroundColor DarkGreen
}
else {
    Write-Host "INFO: Didn't find any match, searching for PowerShell functions" -ForegroundColor Yellow
}
#>
