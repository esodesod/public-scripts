# Measure size on a folder (recurse). Display in GB
"{0:N2} GB" -f ((Get-ChildItem -Path . -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)