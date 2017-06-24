<# 
.SYNOPSIS 
    This script reports on whether Lync should 
    automatically start on a machine when a user 
    logs in. 
.DESCRIPTION 
    This script looks in the registry at a chosen machine 
    to determine if the Lync client should automatically 
    attempt to login when a user logs onto that system. 
.NOTES 
    File Name  : Get-LyncAutoLogonStatus 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell Version 2.0 
                 Lync 2010 or later 
.LINK 
    This script posted to: 
        http://www.pshscripts.blogspot.com 
.EXAMPLE 
    Psh> .\Get-LyncAutoLogonStatus     
    Automatically start Lync when I log on to Windows: True 
#> 
 
 
[Cmdletbinding()] 
Param ( 
[string] $computer = "Cookham8.Cookham.net") 
 
 
# Get the relevant registry key 
$registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("CurrentUser", $computer) 
$key = $registry.OpenSubKey("SOFTWARE\Microsoft\Communicator", $True) 
  
# now write to host the details 
Write-Host "Automatically start Lync when I log on to Windows:",` 
    ([boolean] $key.GetValue("AutoRunWhenLogonToWindows",$null))