<#
    .SYNOPSIS 
     Applies the specified license SKU to all user account provided in a CSV file called users.csv. The
     CSV file must contain three columns. The title of the columns should be UPN, UsageLocation, and SKU. 
    .EXAMPLE
     BulkSet-MSOLUserLicense.ps1
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.1
#>

Connect-MSOLService -Credential (Get-Credential)

$users = import-csv .\users.csv -delimiter "," 

foreach ($user in $users){
    try{
        $upn=$user.UPN 
        $usagelocation=$user.usagelocation  
        $SKU=$user.SKU 
        Set-MsolUser -UserPrincipalName $upn -UsageLocation $usagelocation 
        Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $SKU
        write-host "Adding license to: " $upn    
    }
    catch{
        Write-Host "Unable to apply user licenses. Please try again." -ForegroundColor Red
    }
}  