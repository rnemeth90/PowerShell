<#
    .SYNOPSIS 
     Removes users specified in a CSV file. The CSV file must be named "users.csv" and exist within the same directory
     as the script. The column name in the CSV must be "UPN". 
    .PARAMETER Mode
     The script accepts one parameter that is mandatory. The
     parameter specifies whether the script runs in "test mode" or "real mode". Test mode does not actually make any 
     modifications. Real mode does. To use real mode, pass the value "real" to the "-mode" parameter. To use test mode, 
     pass "test" to the "-mode" parameter.
    .EXAMPLE
     BulkRemove-Office365Accounts -Mode Test
    .EXAMPLE
     BulkRemove-Office365Accounts -Mode Real
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
    .EXAMPLE
     BulkRemove-Office365Accounts.ps1 [-Mode <String>]
#>

Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$Mode
)

#Connect to Office 365
Connect-MsolService -Credential (Get-Credential)

#Import users.csv into a variable
$users = Import-Csv .\users.csv

#The Test Mode Function
function testMode{
    foreach($user in $users){
        try{
            Write-Host "TEST: Removing user:" $user.UPN -ForegroundColor Yellow
        }
        catch{
            Write-Host "TEST: Unable to remove account " $user.UPN -ForegroundColor Red
        }
    }
}

#The Real Mode Function
function realMode{
    foreach($user in $users){

        try{
            Remove-MsolUser -UserPrincipalName $user.UPN -Force
            Write-Host "Removing user:" $user.UPN -ForegroundColor Yellow
        }
        catch{
            Write-Host "Unable to remove account " $user.UPN -ForegroundColor Red
        }
    }
}

if($mode -eq "test"){
    testMode
}
elseif($mode -eq "real"){
    realMode
}
else{
    Write-Host "Parameter not recognized. Please try again." -ForegroundColor Red
}