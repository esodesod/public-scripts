# Remove Hyper-V modules, cause in conflict with VMware admins (modules)
(Get-Module -Name Hyper-V) | Remove-Module -Force -ErrorAction SilentlyContinue

$psdir="H:\github\esodsod\scripts\powershell\functions"
Get-ChildItem "$psdir\*.ps1" | ForEach-Object {.$_}
Write-Host "Custom esod.no PS-environment loaded" -ForegroundColor DarkGreen