# Search for event "6005", aka "The Event log service was started."
get-eventlog system | where-object {$_.eventid -eq 6005} | select -first 10