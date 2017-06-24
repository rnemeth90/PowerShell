<# 
.SYNOPSIS 
    This script defines a function that sets autologon 
.DESCRIPTION 
    Autologon enables the system to logon after a reboot without 
    you needing to enter credentials. This is an ideal scenario 
    for lab or training room systems. This script defines 
    a function that sets a userid/password and autologon.
.NOTES 
    File Name  : Set-AdminLogon 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell Version 2.0 
.LINK 
    This script posted to: 
        http://www.pshscripts.blogspot.com 
.EXAMPLE 
    Psh> New-AdminLogon -user cookham\tfl -password 'JerryGarciaR0cks!' 
    Auto logon created for [Cookham\tfl] with password: [JerryGarciaR0cks]          
 
#> 
 
Function New-AdminLogon { 
 
[cmdletbinding()] 
Param( 
[string] $User     = $(Throw 'No user id specified'), 
[string] $Password = $(Throw 'No password specified') 
) 
 
# Define registry path for autologon 
$RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' 
 
# Set autologon 
Set-ItemProperty -Path $RegPath -Name AutoAdminLogon -Value 1  
 
# Set userid and password 
Set-ItemProperty -Path $RegPath -Name DefaultUserName -Value $User  
Set-ItemProperty -Path $regPath -Name DefaultPassword -Value $Password  
 
# Say nice things and exit! 
Write-Host ("Auto logon [{0}] set to password: [{1}]" -f $user, $password) 
} 
 
Set-AdminLogon -User 'Cookham\tfl' -Password 'JerryGarciaR0cks' 