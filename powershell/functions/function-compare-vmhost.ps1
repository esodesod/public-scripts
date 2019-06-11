# Credits rgel / https://github.com/rgel/PowerCLi
Function Compare-VMHost
{
	
<#
.SYNOPSIS
	Compare two or more ESXi hosts on different criteria.
.DESCRIPTION
	This function compares two or more ESXi hosts on different criteria.
.PARAMETER ReferenceVMHost
	Specifies reference ESXi host object, returned by Get-VMHost cmdlet.
.PARAMETER DifferenceVMHost
	Specifies difference ESXi host object(s), returned by Get-VMHost cmdlet.
.PARAMETER Compare
	Specifies what to compare.
.PARAMETER Truncate
	If specified, try to truncate ESXi hostname.
.PARAMETER HideReference
	If specified, filter out reference host related objects from the output.
.EXAMPLE
	PS C:\> Get-VMHost 'esx2[78].*' |Compare-VMHost -ReferenceVMHost (Get-VMHost 'esx21.*') -Compare SharedDatastore
	Compare shared datastores of two ESXi hosts (esx27, esx28) with the reference ESXi host (esx21).
.EXAMPLE
	PS C:\> Get-VMHost 'esx2.*' |Compare-VMHost (Get-VMHost 'esx1.*') VIB -Truncate -HideReference
	Compare VIBs between two ESXi hosts, truncate hostnames and return difference hosts only.
.EXAMPLE
	PS C:\> Get-Cluster DEV |Get-VMHost 'esx2.*' |Compare-VMHost -ref (Get-VMHost 'esx1.*') -Compare LUN -Verbose |epcsv -notype .\LUNID.csv
.NOTES
	Author      :: Roman Gelman @rgelman75
	Shell       :: Tested on PowerShell 5.0|PowerCLi 6.5.1
	Platform    :: Tested on vSphere 5.5/6.5|VCenter 5.5U2/VCSA 6.5
	Requirement :: VIB compare (-Compare VIB) supported on ESXi/VC 5.0 and later
	Version 1.0 :: 26-Sep-2016 :: [Release]
	Version 1.1 :: 29-May-2017 :: [Change] Added NTP & VIB compare, -HideReference parameter and Progress bar
.LINK
	https://ps1code.com/2016/09/26/compare-esxi-powercli
#>
	
	[CmdletBinding()]
	[Alias("Compare-ViMVMHost", "diffesx")]
	[OutputType([PSCustomObject])]
	Param (
		[Parameter(Mandatory, Position = 1)]
		[Alias("ref")]
		[VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]$ReferenceVMHost
		 ,
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias("diff")]
		[VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]$DifferenceVMHost
		 ,
		[Parameter(Mandatory = $false, Position = 2)]
		[ValidateSet("NAA", "LUN", "Datastore", "SharedDatastore", "Portgroup", "NTP", "VIB")]
		[string]$Compare = 'SharedDatastore'
		 ,
		[Parameter(Mandatory = $false)]
		[Alias("TruncateVMHostName")]
		[switch]$Truncate
		 ,
		[Parameter(Mandatory = $false)]
		[switch]$HideReference
	)
	
	Begin
	{
		$ErrorActionPreference = 'Stop'
		$WarningPreference = 'SilentlyContinue'
		$FunctionName = '{0}' -f $MyInvocation.MyCommand
		Write-Verbose "$FunctionName started at [$(Get-Date)]"
		
		if ('Connected', 'Maintenance' -contains $ReferenceVMHost.ConnectionState -and $ReferenceVMHost.PowerState -eq 'PoweredOn')
		{
			Try
			{
				$RefHost = Switch -exact ($Compare)
				{
					'LUN'
					{
						(Get-ScsiLun -vb:$false -VmHost $ReferenceVMHost -LunType 'disk' | select @{ N = 'LUN'; E = { ([regex]::Match($_.RuntimeName, ':L(\d+)$').Groups[1].Value) -as [int] } } | sort LUN).LUN
						Break
					}
					'NAA'
					{
						(Get-ScsiLun -vb:$false -VmHost $ReferenceVMHost -LunType 'disk' | select CanonicalName | sort CanonicalName).CanonicalName
						Break
					}
					'Datastore'
					{
						($ReferenceVMHost | Get-Datastore -vb:$false | select Name | sort Name).Name
						Break
					}
					'SharedDatastore'
					{
						($ReferenceVMHost | Get-Datastore -vb:$false | ? { $_.ExtensionData.Summary.MultipleHostAccess } | select Name | sort Name).Name
						Break
					}
					'Portgroup'
					{
						(($ReferenceVMHost).NetworkInfo.ExtensionData.Portgroup).Spec.Name + ($ReferenceVMHost | Get-VDSwitch -vb:$false | Get-VDPortgroup -vb:$false | ? { !$_.IsUplink } | select Name | sort Name).Name
						Break
					}
					'NTP'
					{
						($ReferenceVMHost | Get-VMHostNtpServer -vb:$false) -join ', '
						Break
					}
					'VIB'
					{
						((Get-EsxCli -vb:$false -V2 -VMHost $ReferenceVMHost).software.vib.list.Invoke()).ID
					}
				}
			}
			Catch
			{
				"{0}" -f $Error.Exception.Message
			}
		}
		else
		{
			Write-Verbose "The reference host [$($ReferenceVMHost.Name)] currently is in [$($ReferenceVMHost.ConnectionState)::$($ReferenceVMHost.PowerState)] state. The compare was canceled"
		}
	}
	Process
	{
		if ('Connected', 'Maintenance' -contains $DifferenceVMHost.ConnectionState -and $DifferenceVMHost.PowerState -eq 'PoweredOn')
		{
			Write-Progress -Activity $FunctionName -Status "Comparing [$Compare] with Reference VMHost [$($ReferenceVMHost.Name)]" -CurrentOperation "Current VMHost [$($DifferenceVMHost.Name)]"
			
			Try
			{
				$DifHost = Switch -exact ($Compare)
				{
					
					'LUN'
					{
						(Get-ScsiLun -vb:$false -VmHost $DifferenceVMHost -LunType 'disk' | select @{ N = 'LUN'; E = { ([regex]::Match($_.RuntimeName, ':L(\d+)$').Groups[1].Value) -as [int] } } | sort LUN).LUN
						Break
					}
					'NAA'
					{
						(Get-ScsiLun -vb:$false -VmHost $DifferenceVMHost -LunType 'disk' | select CanonicalName | sort CanonicalName).CanonicalName
						Break
					}
					'Datastore'
					{
						($DifferenceVMHost | Get-Datastore -vb:$false | select Name | sort Name).Name
						Break
					}
					'SharedDatastore'
					{
						($DifferenceVMHost | Get-Datastore -vb:$false | ? { $_.ExtensionData.Summary.MultipleHostAccess } | select Name | sort Name).Name
						Break
					}
					'Portgroup'
					{
						(($DifferenceVMHost).NetworkInfo.ExtensionData.Portgroup).Spec.Name + ($DifferenceVMHost | Get-VDSwitch -vb:$false | Get-VDPortgroup -vb:$false | ? { !$_.IsUplink } | select Name | sort Name).Name
						Break
					}
					'NTP'
					{
						($DifferenceVMHost | Get-VMHostNtpServer -vb:$false) -join ', '
						Break
					}
					'VIB'
					{
						((Get-EsxCli -vb:$false -V2 -VMHost $DifferenceVMHost).software.vib.list.Invoke()).ID
					}
				}
				
				$diffObj = Compare-Object -ReferenceObject $RefHost -DifferenceObject $DifHost -IncludeEqual:$false -CaseSensitive
				
				foreach ($diff in $diffObj)
				{
					if ($diff.SideIndicator -eq '=>')
					{
						$diffOwner = $DifferenceVMHost.Name
						$Reference = $false
						$Difference = ''
					}
					else
					{
						$diffOwner = $ReferenceVMHost.Name
						$Reference = $true
						$Difference = $DifferenceVMHost.Name
					}
					
					if ($Truncate)
					{
						$diffOwner = [regex]::Match($diffOwner, '^(.+?)(\.|$)').Groups[1].Value
						$Difference = [regex]::Match($Difference, '^(.+?)(\.|$)').Groups[1].Value
					}
					
					$res = [pscustomobject] @{
						$Compare = $diff.InputObject
						VMHost = $diffOwner
						Reference = $Reference
						Difference = $Difference
					}
					
					if ($HideReference) { if (!$res.Reference) { $res } }
					else { $res }
				}
			}
			Catch
			{
				"{0}" -f $Error.Exception.Message
			}
		}
		else
		{
			Write-Verbose "The difference host [$($DifferenceVMHost.Name)] currently is in [$($DifferenceVMHost.ConnectionState)::$($DifferenceVMHost.PowerState)] state. The host was skipped"
		}
	}
	End
	{
		Write-Verbose "$FunctionName finished at [$(Get-Date)]"
	}
	
} #EndFunction Compare-VMHost