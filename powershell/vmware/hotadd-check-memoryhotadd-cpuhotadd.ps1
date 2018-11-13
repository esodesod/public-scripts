$result = (get-vm -name "*ad-*" | Select-Object extensiondata).extensiondata.config | Select-Object name,memoryhotaddenabled,cpuhotaddenabled,cpuhotremoveenabled
$result