# Ask & save credential to variable
$cred = Get-Credential

# You may now enter remote sessions using the variable
Enter-PSSession computer.domain.tld -Credential $cred