<#
    .SYNOPSIS 
     Connect to Office 365 and Exchange Online 
    .PARAMETER Mode
     The script accepts no parameters. 
    .EXAMPLE
     Connect-MicrosoftOnline
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
#>


$cred = Get-Credential
$EmailAddress = $cred.UserName

Clear-Host

Write-Host "Connecting to Office 365" -ForegroundColor Red
Connect-MsolService -Credential $cred

Write-Host "Connecting to Exchange Online" -ForegroundColor Red
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -AllowRedirection -Authentication Basic
Import-PSSession $session

Clear-Host



