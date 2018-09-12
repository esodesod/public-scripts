function Keep-Pinging
{
    param([string]$Hostname)

    ping.exe -t $Hostname |ForEach-Object {
        $Color = if($_ -like "Request timed out*") {
            "Red"
        } elseif($_ -like "Reply from*") {
            "Green"
        } else {
            "Gray"
        }
        Write-Host $_ -ForegroundColor $Color
    }
}