$techCredentials = get-credential
Connect-MsolService -credential $techCredentials


$UPN = Read-Host "What is the User Principal Name of the account you would like to unlock? "
Set-MsolUser -UserPrincipalName $UPN -BlockCredential $false

Write-Host "The account has been unlocked!"

Read-Host "Press enter to continue...."

