# Credits: Ian Bruckner / b.koehler
# See https://social.technet.microsoft.com/Forums/ie/en-US/46881e57-62a4-446e-af2d-cd2423e7837f/report-on-remote-users-mapped-drives?forum=winserverpowershell
function Get-MappedDrives($ComputerName){
  #Ping remote machine, continue if available
  Write-Host "*** Testing connection against $($ComputerName)" -ForegroundColor DarkGray
  if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
    #Get remote explorer session to identify current user
    Write-Host "INFO: Connecting with WMI to target" -ForegroundColor DarkGray
    $explorer = Get-WmiObject -ComputerName $ComputerName -Class win32_process | ?{$_.name -eq "explorer.exe"}
    
    #If a session was returned check HKEY_USERS for Network drives under their SID
    if($explorer){
      $Hive = [long]$HIVE_HKU = 2147483651
      $sid = ($explorer.GetOwnerSid()).sid
      $owner  = $explorer.GetOwner()
      $RegProv = get-WmiObject -List -Namespace "root\default" -ComputerName $ComputerName | Where-Object {$_.Name -eq "StdRegProv"}
      $DriveList = $RegProv.EnumKey($Hive, "$($sid)\Network")
      
      #If the SID network has mapped drives iterate and report on said drives
      if($DriveList.sNames.count -gt 0){
        "$($owner.Domain)\$($owner.user) on $($ComputerName)"
        foreach($drive in $DriveList.sNames){
          "$($drive)`t$(($RegProv.GetStringValue($Hive, "$($sid)\Network\$($drive)", "RemotePath")).sValue)"
        }
      }else{"No mapped drives on $($ComputerName)"}
    }else{"explorer.exe not running on $($ComputerName)"}
  }else{"Can't connect to $($ComputerName)"}
}