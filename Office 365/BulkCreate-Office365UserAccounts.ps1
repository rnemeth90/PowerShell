<#
    .SYNOPSIS 
     Creates Office 365 user accounts
    .PARAMETER Mode
     This script accepts no parameters
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
#>

$cred = Get-Credential
Connect-MsolService -Credential $cred

$users = Import-Csv .\ad_users.csv

foreach($user in $users){
 
    Write-Host "Creating account for " + $user.displayName
    New-MsolUser -UserPrincipalName $user.upn -FirstName $user.firstName -LastName $user.lastName -Country $user.country -DisplayName $user.displayName -LicenseAssignment $user.license -UsageLocation $user.usagelocation
    

}