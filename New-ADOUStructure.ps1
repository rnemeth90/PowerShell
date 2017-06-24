New-ADOrganizationalUnit -Name TMCRV_Admins -Path "DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True

#Create Wakarusa OU Structure
New-ADOrganizationalUnit -Name Wakarusa -Path "DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Servers -Path "OU=Wakarusa,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Computers -Path "OU=Wakarusa,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Users -Path "OU=Wakarusa,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Mobile -Path "OU=Computers,OU=Wakarusa,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True

#Create Elkhart-A OU Structure
New-ADOrganizationalUnit -Name Elkhart-A -Path "DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Servers -Path "OU=Elkhart-A,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Computers -Path "OU=Elkhart-A,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Users -Path "OU=Elkhart-A,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Mobile -Path "OU=Computers,OU=Elkhart-A,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True

#Create Elkhart-B OU Structure
New-ADOrganizationalUnit -Name Elkhart-B -Path "DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Servers -Path "OU=Elkhart-B,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Computers -Path "OU=Elkhart-B,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Users -Path "OU=Elkhart-B,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Mobile -Path "OU=Computers,OU=Elkhart-B,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True

#Create Bristol OU Structure
New-ADOrganizationalUnit -Name Bristol -Path "DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Servers -Path "OU=Bristol,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Computers -Path "OU=Bristol,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Users -Path "OU=Bristol,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name Mobile -Path "OU=Computers,OU=Bristol,DC=AD,DC=TMCRV,DC=COM" -ProtectedFromAccidentalDeletion $True