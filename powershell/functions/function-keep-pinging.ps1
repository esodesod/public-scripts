function Keep-Pinging
{
    param([string]$Hostname)

    ping.exe -t $Hostname |ForEach-Object {
        $Color = if($_ -like "Request timed out*") {
            "Red"
        } elseif($_ -like "Reply from*time*") {
            "Green"
        } else {
            "Gray"
        }
        Write-Host $_ -ForegroundColor $Color
    }
}

Set-Alias -Name kping -Value Keep-Pinging
