function Get-OpenfileSessions($ComputerName, $FilePath){
    # Ping remote machine, continue if available
    if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
      # Get openfiles (everything)
      $openfiles = openfiles.exe /query /s $ComputerName /fo CSV | ConvertFrom-Csv
      # Filter on "$FilePath"
      $sessions = $openfiles | Where-Object "Open File (Path\executable)" -Like $FilePath
      $sessions
    }
}