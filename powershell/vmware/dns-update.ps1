# PowerCLI Script to Configure DNS and NTP on ESXi Hosts
# PowerCLI Session must be connected to vCenter Server using Connect-VIServer
# Credits: http://www.vhersey.com/2013/10/setting-esxi-dns-and-ntp-using-powercli/

# Set variables
$dnspri = "10.0.1.100"
$dnsalt = "10.0.1.200"
$domainname = "esod.local"
$esxHosts = get-VMHost


# Update DNS-configuration on hosts
foreach ($esx in $esxHosts) {
    Write-Host "Configuring DNS and Domain Name on $esx" -ForegroundColor Green
    Get-VMHostNetwork -VMHost $esx | Set-VMHostNetwork -DomainName $domainname -DNSAddress $dnspri, $dnsalt -Confirm:$false
    }

## Print current DNS-configuration
foreach ($esx in $esxHosts) {
    Get-VMHostNetwork -VMHost $esx | fl dnsaddress,domainname
    }