# Remove Hyper-V modules, cause in conflict with VMware admins (modules)
(Get-Module -Name Hyper-V) | Remove-Module -Force -ErrorAction SilentlyContinue

# Set policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#<# Test paths for *.ps1 & load (if found)
$test_powershell_functions_paths = @("C:\Users\odegaarde\GitHub\esodesod\scripts\powershell\functions","C:\temp\github\esodesod\scripts\powershell\fucntions")

foreach ($test_path in $test_powershell_functions_paths) {
    if (Test-Path $test_path) {
        Write-Host "INFO: Found PowerShell functions in $test_path" -ForegroundColor DarkGray
        Get-ChildItem "$($test_path)\*.ps1" | ForEach-Object {
            Write-Host "INFO: Loading $_" -ForegroundColor DarkGray
            .$_
        }
        Write-Host "INFO: Custom fuctions from $test_path loaded" -ForegroundColor DarkGreen
    }
}
#>