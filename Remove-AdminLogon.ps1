<#
.SYNOPSIS
This script defines a function that removes autologon
.DESCRIPTION
Autologon enables the system to logon after a reboot without
you needing to enter credentials. This is an ideal scenario
for lab or training room systems. This script defines
a function that removes the autologon registry keys
.NOTES
File Name : Remove-AdminLogon
Author : Thomas Lee - tfl@psp.co.uk
Requires : PowerShell Version 2.0
.LINK
This script posted to:
http://www.pshscripts.blogspot.com
.EXAMPLE
Psh> Remove-AdminLogon
Auto logon settings removed
#>
Function Remove-AdminLogon {
[Cmdletbinding()]
Param()
# Define registry path for autologon
$RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
# Remove autologon property
Remove-ItemProperty -Path $RegPath -Name AutoAdminLogon
# Remove userid and password
Remove-ItemProperty -Path $RegPath -Name DefaultUserName
Remove-ItemProperty -Path $RegPath -Name DefaultPassword
# Say nice things and exit!
Write-Host ("Auto logon removed")
}
Remove-AdminLogon