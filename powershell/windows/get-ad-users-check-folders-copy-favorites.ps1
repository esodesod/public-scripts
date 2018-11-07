$users = Get-ADUser -Filter * -SearchBase "OU=Users,DC=domain,DC=local"
$share = "\\servername\"

# Check favorites folder for users, and paste robocopy oneliner (as text, no action this time)
foreach ($user in $users) {
    $folder = ($share + $user.samaccountname + "\Favorites")
    $dst = ("E:\temp\favorites\" + $user.SamAccountName + "\Favorites")
    # Check if folder exists
    if ( Test-Path $folder ) {
        Write-Host $folder exists -ForegroundColor Green
        Write-Host "robocopy /MIR /COPY:DATSOU /MT:10 /R:3 /W:10" $folder $dst
        }
    # Check if folder does not exist
    if ( -not (Test-Path $folder) ) {
        Write-Host $folder does not exist -ForegroundColor Yellow
        }
    }