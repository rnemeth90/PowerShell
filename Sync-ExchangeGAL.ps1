#  Manages contacts in two domains based on mail-enabled users in the other domain.
#	- Contacts are created for new users.
#	- Contacts are deleted if the source user no longer meets the filter requirements.
#	- Contacts are updated with changed information.
#
#  NOTES:
#   - Requires RSAT roles and features installed. Ref http://blogs.technet.com/heyscriptingguy/archive/2010/01/25/hey-scripting-guy-january-25-2010.aspx
#	- Attribute deletions are not replicated - only attribute adds and changes.
#   - A user account is needed in each domain with permission to create contacts.
#	- The passwords for these user accounts must be stored in secure files using the command:
#		read-host -assecurestring | convertfrom-securestring | out-file C:\scripts\filename.txt
#
#  EXCHANGE 2007:
#   - The account running the script needs Recipient Administrator in the target forest.
#   - The Exchange management tools must be installed on the computer where the script runs.
#   - Depending on trust relationships, you may need to run the script seperately in each forest where contacts are to be created.
#
#  EXCHANGE 2010:
#   - Some changes may be required to enable access to Exchange remote powershell:
#     - Add the script account to the Recipient Management Role Group
#     - Give the script account permission to use remote powershell:
#           set-user -identity “GALSYNC” -RemotePowerShellEnabled $True
#     - Enable "Windows Authentication" on the Powershell virtual directory in IIS on the CAS servers.
#

### --- GLOBAL DEFINITIONS ---

$DOMAIN_1 = "mydomain.local"
$DOMAIN_2 = "myotherdomain.com"

$OU_CONTACTS_1 = "OU=Domain2,OU=Contacts,DC=mydomain,DC=local"
$OU_CONTACTS_2 = "OU=Domain1,OU=Contacts,DC=myotherdomain,DC=com"

$USER_1 = "galsync@mydomain.local"
$USER_2 = "galsync@myotherdomain.com"

$PWFILE_1 = "C:\scripts\dom1cred.txt"
$PWFILE_2 = "C:\scripts\dom2cred.txt"

# Exchange 2010 URIs if applicable
$URI_1 = "http://cas.mydomain.local/powershell"
$URI_2 = "http://cas.myotherdomain.com/powershell"

## The following list of attributes will be copied from User to Contact
$arrAttribs = 'displayName','company','givenName','mobile','postalAddress','postalCode','sn','st','streetAddress','telephoneNumber','title' ,'mail','c','co','l','facsimileTelephoneNumber','physicalDeliveryOfficeName'

## The following filter is used by Get-ADObject to decide which users will have contacts.
$strSelectUsers = 'ObjectClass -eq "user" -and homeMDB -like "*" -and -not userAccountControl -bor 2 -and -not msExchHideFromAddressLists -eq $true -and -not displayName -eq "Administrator"'

### --- FUNCTION TO ADD, DELETE AND MODIFY CONTACTS IN TARGET DOMAIN BASED ON SOURCE USERS ---

function SyncContacts
{
  PARAM($sourceDomain, $sourceUser, $sourcePWFile, $targetDomain, $targetUser, $targetPWFile, $targetOU, $targetExch, $targetURI)
  END
    {
	$colUsers = @()
	$colContacts = @()
	$colAddContact = @()
	$colDelContact = @()
	$colUpdContact = @()

	$arrUserMail = @()
	$arrContactMail = @()

	$objSourceDC = Get-ADDomainController -Discover -DomainName $sourceDomain
	$objTargetDC = Get-ADDomainController -Discover -DomainName $targetDomain 

	$sourceDC = [string]$objSourceDC.HostName
	$targetDC = [string]$objTargetDC.HostName

	write-host "Enumerating" $sourceDomain "objects using DC" $sourceDC

	### ENUMERATE USERS

	$password = get-content $sourcePWFile | convertto-securestring
	$sourceCred =  New-Object -Typename System.Management.Automation.PSCredential -Argumentlist $sourceUser,$password

	$colUsers = Get-ADObject -Filter $strSelectUsers -Properties * -Server $sourceDC -Credential $sourceCred

	if ($colUsers.Count -eq 0)
    {
        write-host "No users found in source domain!"
        break
    }

	foreach ($user in $colUsers)
	{
		$arrUserMail += $user.mail
	}

	### ENUMERATE CONTACTS

	$password = get-content $targetPWFile | convertto-securestring
	$targetCred =  New-Object -Typename System.Management.Automation.PSCredential -Argumentlist $targetUser,$password

	$colContacts = Get-ADObject -Filter 'objectClass -eq "contact"' -Server $targetDC -SearchBase $targetOU -Credential $targetCred -Properties targetAddress

	foreach ($contact in $colContacts)
	{
		$strAddress = $contact.targetAddress -replace "SMTP:",""
		$arrContactMail += $strAddress
	}

	### FIND CONTACTS TO ADD AND UPDATE

	foreach ($user in $colUsers)
	{
		if ($arrContactMail -contains $user.mail)
		{
			write-host "Contact found for " $user.mail
			$colUpdContact += $user
		}
		else
		{
			write-host "No contact found for " $user.mail
			$colAddContact += $user
		}
	}

	### FIND CONTACTS TO DELETE

	foreach ($address in $arrContactMail)
	{
		if ($arrUserMail -notcontains $address)
		{
			$colDelContact += $address
			write-host "Contact will be deleted for" $address
		}
	}

	write-host ""
	write-host "Updating" $targetDomain "using DC" $targetDC

	### ADDS

	foreach ($user in $colAddContact)
	{
		write-host "ADDING contact for " $user.mail

 		$targetAddress = "SMTP:" + $user.mail
		$alias = "c-" + $user.mail.split("@")[0]

		$hashAttribs = @{'targetAddress' = $targetAddress}
	        $hashAttribs.add("mailNickname", $alias)

		foreach ($attrib in $arrAttribs)
		{
			if ($user.$attrib -ne $null) { $hashAttribs.add($attrib, $user.$attrib) }
		}

		# Create Contact Object
		New-ADObject -name $user.displayName -type contact -Path $targetOU -Description $user.description -server $targetDC -credential $targetCred -OtherAttributes $hashAttribs

		# Exchange 2007/2010 - Run update-recipient to ensure contact is Exchange-enabled
		switch ($targetExch)
		{
			"2007"
			{
				if(@(get-pssnapin | where-object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.Admin"} ).count -eq 0) {add-pssnapin Microsoft.Exchange.Management.PowerShell.Admin}
				Update-Recipient -Identity $alias -DomainController $targetDC -Credential $targetCred
			}
			"2010"
			{
				$SO = New-PSSessionOption -SkipCACheck -SkipCNCheck –SkipRevocationCheck –ProxyAccessType None
				if ($PSSession -eq $null) {$PSSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $targetURI -Credential $targetCred -SessionOption $SO}
				Invoke-Command -Session $PSSession -ScriptBlock{param ($alias,$targetDC) Update-Recipient -Identity $alias -DomainController $targetDC} -ArgumentList $alias,$targetDC
			}
		}
	}

	### UPDATES

	foreach ($user in $colUpdContact)
	{
		write-host "VERIFYING contact for " $user.mail

 		$targetAddress = "SMTP:" + $user.mail
		$alias = "c-" + $user.mail.split("@")[0]

		$strFilter = "targetAddress -eq ""SMTP:" + $user.mail + """"
		$colContacts = Get-ADObject -Filter $strFilter -searchbase $targetOU -server $targetDC -credential $targetCred -Properties *
		foreach ($contact in $colContacts)
		{
			$hashAttribs = @{}
			foreach ($attrib in $arrAttribs)
			{
				if ($user.$attrib -ne $null -and $user.$attrib -ne $contact.$attrib)
				{
					write-host "	Changing " $attrib
					write-host "		Before: " $contact.$attrib
					write-host "		After: " $user.$attrib
					$hashAttribs.add($attrib, $user.$attrib)
				}
			}
			if ($hashAttribs.Count -gt 0)
			{
				Set-ADObject -identity $contact -server $targetDC -credential $targetCred -Replace $hashAttribs
			}
		}

	}

	### DELETES

	foreach ($contact in $colDelContact)
	{
		write-host "DELETING contact for " $contact
		$strFilter = "targetAddress -eq ""SMTP:" + $contact + """"
		Get-ADObject -Filter $strFilter -searchbase $targetOU -server $targetDC -credential $targetCred | Remove-ADObject -server $targetDC -credential $targetCred -Confirm:$false
	}

	}
}

### --- MAIN ---

Start-Transcript C:\scripts\galsync\galsync.log

if(@(get-module | where-object {$_.Name -eq "ActiveDirectory"} ).count -eq 0) {import-module ActiveDirectory}

# EXAMPLE - Exchange 2010 target forest
write-host "Domain1 Users --> Domain2 Contacts"
SyncContacts -sourceDomain $DOMAIN_1 -sourceUser $USER_1 -sourcePWFile $PWFILE_1 `
             -targetDomain $DOMAIN_2 -targetUser $USER_2 -targetPWFile $PWFILE_2 `
			 -targetOU $OU_CONTACTS_2 -targetExch "2010" -targetURI $URI_2

# EXAMPLE - Exchange 2007 target forest
write-host "Domain2 Users --> Domain1 Contacts"
SyncContacts -sourceDomain $DOMAIN_2 -sourceUser $USER_2 -sourcePWFile $PWFILE_2 `
             -targetDomain $DOMAIN_1 -targetUser $USER_1 -targetPWFile $PWFILE_1 `
			 -targetOU $OU_CONTACTS_1 -targetExch "2007"

# EXAMPLE - Exchange 2003 target forest
write-host "Domain2 Users --> Domain1 Contacts"
SyncContacts -sourceDomain $DOMAIN_2 -sourceUser $USER_2 -sourcePWFile $PWFILE_2 `
             -targetDomain $DOMAIN_1 -targetUser $USER_1 -targetPWFile $PWFILE_1 `
			 -targetOU $OU_CONTACTS_1             

Stop-Transcript