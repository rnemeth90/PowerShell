<#
.SYNOPSIS
This script defines a function, Enable-Gui which
enables the GUI on Windows Server 2012 Server Core
.DESCRIPTION
The Enable-GUI function enables the Gui in Server 2012
Server Core by adding in two windows features. The
script removes any Shell setting to ensure that when
Server 2012 restarts, it starts with the full Desktop.
.NOTES
File Name : Enable-GUI.ps1
Author : Thomas Lee - tfl@psp.co.uk
Requires : PowerShell Version 3.0 and Windows Server 2012.
.LINK
This script posted to:
http://www.pshscripts.blogspot.com
.EXAMPLE
Psh> Enable-GUI -Verbose
Installing Windows Feature: Server-GUI-Shell, Server-Gui-Mgmt-Infra
Removing Shell Registry Setting
Finished installation, now rebooting
< after reboot, full GUI is added >
#>
Function Enable-GUI {
# No parameters - but maybe later
# Turn on CmdletBinding to enable -Verbose
[Cmdletbinding()]
Param()
# Install the GUI
Write-Verbose "Installing Windows Feature: Server-GUI-Shell, Server-Gui-Mgmt-Infra"
Install-WindowsFeature Server-Gui-Shell, Server-Gui-Mgmt-Infra -Source d:\sources\sxs
# Remove the Setting For Shell to force back to CMD.EXE
Write-Verbose 'Removing Shell Registry Setting'
$RegPath = "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\winlogon"
Remove-ItemProperty -Confirm -Path $RegPath -Name Shell -ErrorAction SilentlyContinue
# And reboot the system
Write-Verbose "Finished installation, now rebooting"
Restart-Computer
}