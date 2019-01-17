#<# REMOTE (right?)
# #######################################################
# Ask & save credential to variable, if not using current
$cred = Get-Credential
$srv="srv.domain.tld"
# #######################################################
#>

#<# VARIABLES
# #######################################################
$srv_folder = "X:\folder\here"
# #######################################################
#>

#<# COMMANDS
# #######################################################
$files = Invoke-Command -ComputerName $srv -Credential $cred -ScriptBlock {Get-ChildItem $Using:srv_folder -recurse –force | Sort-Object length -descending | select-object -first 32}
# #######################################################
#>

#<# TEST & CLEANUP
# #######################################################
$files | Format-Table FullName
Remove-Variable files
# #######################################################
#>
