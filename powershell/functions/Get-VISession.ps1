Function Get-VISession
{
	<#
.SYNOPSIS
Lists vCenter Sessions.

.DESCRIPTION
Lists all connected vCenter Sessions.

.NOTES
Author: Alan Renouf
Source: https://blogs.vmware.com/PowerCLI/2011/09/list-and-disconnect-vcenter-sessions.html
Changes:
- 2024-07-03 / esodesod: Added property "UserAgent" and "IpAddress"

.EXAMPLE
PS C:\> Get-VISession

.EXAMPLE
PS C:\> Get-VISession | Where { $_.IdleMinutes -gt 5 }

#>
	$SessionMgr = Get-View $DefaultViserver.ExtensionData.Client.ServiceContent.SessionManager
	$AllSessions = @()
	$SessionMgr.SessionList | ForEach-Object {
		$Session = New-Object -TypeName PSObject -Property @{
			Key            = $_.Key
			UserName       = $_.UserName
			FullName       = $_.FullName
			LoginTime      = ($_.LoginTime).ToLocalTime()
			LastActiveTime = ($_.LastActiveTime).ToLocalTime()
			UserAgent      = $_.UserAgent
			IpAddress      = $_.IpAddress

		}
		If ($_.Key -eq $SessionMgr.CurrentSession.Key)
		{
			$Session | Add-Member -MemberType NoteProperty -Name Status -Value "Current Session"
		} Else
		{
			$Session | Add-Member -MemberType NoteProperty -Name Status -Value "Idle"
		}
		$Session | Add-Member -MemberType NoteProperty -Name IdleMinutes -Value ([Math]::Round(((Get-Date) – ($_.LastActiveTime).ToLocalTime()).TotalMinutes))
		$AllSessions += $Session
	}
	$AllSessions
}
