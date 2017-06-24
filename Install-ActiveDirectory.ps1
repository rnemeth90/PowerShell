$domainName = ""
$SafeModeAdminPW = ""
$siteName = ""

Install-WindowsFeature Ad-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

Install-ADDSDomainController `
-NoGlobalCatalog:$false `
-InstallDns:$True `
-CreateDnsDelegation:$false `
-CriticalReplicationOnly:$false `
-DatabasePath "C:\Windows\NTDS" `
-LogPath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-DomainName $domainName `
-NoRebootOnCompletion:$false `
-SiteName $siteName `
-Force:$true `
-SafeModeAdministratorPassword $SafeModeAdminPW
