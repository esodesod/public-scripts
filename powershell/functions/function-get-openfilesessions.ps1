function Get-OpenfileSessions($ComputerName, $FilePath){
    # Get openfiles on remote computer (everything)
    $openfiles = openfiles.exe /query /s $ComputerName /fo CSV | ConvertFrom-Csv
    # Filter on "$FilePath"
    $sessions = $openfiles | Where-Object "Open File (Path\executable)" -Like $FilePath
    # Report
    $sessions
}