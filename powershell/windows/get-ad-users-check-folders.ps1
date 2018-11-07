$users = Get-ADUser -Filter * -SearchBase "OU=Users,DC=domain,DC=local"
$share = "\\file-server-here\"

foreach ($user in $users) {
    if ( Test-Path ($share + $user.samaccountname) ) {Write-Host "Folder for user" $user.samaccountname exists -ForegroundColor Green}
    if ( -not (Test-Path ($share + $user.samaccountname)) ) {Write-Host "Folder for user" $user.samaccountname does not exist -ForegroundColor Red}
    }