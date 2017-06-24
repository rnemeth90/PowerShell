<# 
.SYNOPSIS 
    Shows use of GetComputerDomain to return information about the domain 
.DESCRIPTION 
    Uses system.directoryservices.activedirectory.domain and GetComputerDomain 
    to return domain information of the Computer. Note that this 
    may be different to the domain of the logged on user.    
.NOTES 
    File Name  : Get-DomainController.ps1 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell V2 CTP3 
.LINK 
   This script posted to: 
        http://pshscripts.blogspot.com/2010/06/get-computerdomainps1.html 
    MSDN Sample posted at: 
        http://msdn.microsoft.com/en-us/library/system.directoryservices.activedirectory.domain.getcomputerdomain%28VS.80%29.aspx  
.EXAMPLE 
    PS c:\foo> .\Get-ComputerDomain.ps1 
    Your computer is a member of the cookham.net domain 
    Role Holders in this domain: 
      PDC Role Holder     :  Cookham1.cookham.net 
      RID Role Holder     :  Cookham1.cookham.net 
      InfraM Role Holder  :  Cookham1.cookham.net 
#> 
  
### 
# Start of script 
### 
  
# Get Domain information using static method 
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()  
 
# Display information for current computer 
"Your computer is a member of the {0} domain" -f $domain.name  
"Role Holders in this domain:" 
"  PDC Role Holder     :  {0}" -f $domain.PdcRoleOwner 
"  RID Role Holder     :  {0}" -f $domain.RIDRoleOwner 
"  InfraM Role Holder  :  {0}" -f $domain.InfrastructureRoleOwner 
# End of script 