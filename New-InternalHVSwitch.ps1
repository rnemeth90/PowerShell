<#
.SYNOPSIS
    This script demonstrates creating a Hyper-V Switch
.DESCRIPTION
    This script imports the Hyper-V module then uses it
    to create an Internal Switch for use in future provisioning.
.NOTES
    File Name : New-InternalSwitch.ps1
    Author : Thomas Lee - tfl@psp.co.uk
    Requires : PowerShell Version 3.0 and Windows 8/Server 2012
.LINK
    This script posted to:
    http://www.pshscripts.blogspot.com
.EXAMPLE
    C:\foo\> .New-InternalSwitch.ps1
    VERBOSE: New-InternalSwitch will create a new virtual network.
    Name      SwitchType NetAdapterInterfaceDescription
    ----      ---------- ------------------------------
    Internal  Internal
#>
# Import Hyper-V Module
Import-Module Hyper-V
Try {New-VMSwitch -Name Internal -SwitchType Internal -ComputerName LocalHost -Verbose}
Catch { "Failed to create switch"; $error[0] }
# End New-InternalSwitch.ps1