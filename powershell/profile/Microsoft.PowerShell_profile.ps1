# Remove Hyper-V modules, cause in conflict with VMware admins (modules)
(Get-Module -Name Hyper-V) | Remove-Module -Force -ErrorAction SilentlyContinue

# Set policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#<# Test paths for *.ps1 & load (if found)
$test_powershell_fuctions_path1 = "$($env:USERPROFILE)\GitHub\esodesod\scripts\powershell\functions"
if (Test-Path $test_powershell_fuctions_path1) {
    $result_test_powershell_fuctions_path1 = $test_powershell_fuctions_path1
    Write-Host "INFO: Found PowerShell functions in $result_test_powershell_fuctions_path1" -ForegroundColor DarkGray
    Get-ChildItem "$($result_test_powershell_fuctions_path1)\*.ps1" | ForEach-Object {
        Write-Host "INFO: Loading $_" -ForegroundColor DarkGray
        .$_
    }
    Write-Host "Custom esod.no PowerShell environment loaded" -ForegroundColor DarkGreen
}

#>