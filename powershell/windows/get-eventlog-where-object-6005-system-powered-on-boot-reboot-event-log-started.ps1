# Search for event "6005", aka "The Event log service was started."
get-eventlog system | where-object {$_.eventid -eq 6005} | select -first 10

# Search for event "1074"
get-eventlog system | where-object {$_.eventid -eq 1074} | select -first 10 | out-gridview

# See https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/running-remote-commands?view=powershell-6