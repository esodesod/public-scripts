# Uses function Get-VMHostNetworkAdapterCDP
get-cluster "clustername" | get-vmhost | Get-VMHostNetworkAdapterCDP | where PortId -Like 'TenGig*' | sort switch | ft switch,portid,nic,vmhost -AutoSize