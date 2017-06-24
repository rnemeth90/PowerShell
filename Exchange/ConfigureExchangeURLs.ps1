﻿<#
.SYNOPSIS
ConfigureExchangeURLs.ps1

.DESCRIPTION 
PowerShell script to configure the Client Access server URLs
for Microsoft Exchange Server 2013/2016. All Client Access server
URLs will be set to the same namespace.

If you are using separate namespaces for each CAS service this script will
not handle that.

The script sets Outlook Anywhere to use NTLM with SSL required by default.
If you have different auth requirements for Outlook Anywhere  use the optional
parameters to set those.

.PARAMETER Server
The name(s) of the server(s) you are configuring.

.PARAMETER InternalURL
The internal namespace you are using.

.PARAMETER ExternalURL
The external namespace you are using.

.PARAMETER DefaultAuth
The default authentication method to set for Outlook Anywhere. Defaults to NTLM.

.PARAMETER InternalSSL
Specifies the internal SSL requirement for Outlook Anywhere. Defaults to True (SSL required).

.PARAMETER ExternalSSL
Specifies the external SSL requirement for Outlook Anywhere. Defaults to True (SSL required).

.EXAMPLE
.\ConfigureExchangeURLs.ps1 -Server sydex1 -InternalURL mail.exchangeserverpro.net -ExternalURL mail.exchangeserverpro.net

.EXAMPLE
.\ConfigureExchangeURLs.ps1 -Server sydex1,sydex2 -InternalURL mail.exchangeserverpro.net -ExternalURL mail.exchangeserverpro.net

.LINK
http://exchangeserverpro.com/powershell-script-configure-exchange-urls/

.NOTES
Written by: Paul Cunningham

For more Exchange Server tips, tricks and news
check out Exchange Server Pro.

* Website:	http://exchangeserverpro.com
* Twitter:	http://twitter.com/exchservpro

Find me on:

* My Blog:	http://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	http://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

Change Log:
V1.00, 13/11/2014 - Initial version
V1.01, 26/06/2015 - Added MAPI/HTTP URL configuration
V1.02, 27/08/2015 - Improved error handling, can now specify multiple servers to configure at once.
V1.03, 09/09/2015 - ExternalURL can now be $null
#>

#requires -version 2

[CmdletBinding()]
param(
	[Parameter( Position=0,Mandatory=$true)]
	[string[]]$Server,

	[Parameter( Mandatory=$true)]
	[string]$InternalURL,

	[Parameter( Mandatory=$true)]
    [AllowEmptyString()]
	[string]$ExternalURL,

    [Parameter( Mandatory=$false)]
    [string]$DefaultAuth="NTLM",

    [Parameter( Mandatory=$false)]
    [Boolean]$InternalSSL=$true,

    [Parameter( Mandatory=$false)]
    [Boolean]$ExternalSSL=$true
	)


#...................................
# Script
#...................................

Begin {

    #Add Exchange snapin if not already loaded in the PowerShell session
    if (Test-Path $env:ExchangeInstallPath\bin\RemoteExchange.ps1)
    {
	    . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
	    Connect-ExchangeServer -auto -AllowClobber
    }
    else
    {
        Write-Warning "Exchange Server management tools are not installed on this computer."
        EXIT
    }
}

Process {

    foreach ($i in $server)
    {
        if ((Get-ExchangeServer $i -ErrorAction SilentlyContinue).IsClientAccessServer)
        {
            Write-Host "----------------------------------------"
            Write-Host " Configuring $i"
            Write-Host "----------------------------------------`r`n"
            Write-Host "Values:"
            Write-Host " - Internal URL: $InternalURL"
            Write-Host " - External URL: $ExternalURL"
            Write-Host " - Outlook Anywhere default authentication: $DefaultAuth"
            Write-Host " - Outlook Anywhere internal SSL required: $InternalSSL"
            Write-Host " - Outlook Anywhere external SSL required: $ExternalSSL"
            Write-Host "`r`n"

            Write-Host "Configuring Outlook Anywhere URLs"
            Get-OutlookAnywhere -Server $i | Set-OutlookAnywhere -ExternalHostname $externalurl -InternalHostname $internalurl -ExternalClientsRequireSsl $ExternalSSL -InternalClientsRequireSsl $InternalSSL -DefaultAuthenticationMethod $DefaultAuth

            if ($externalurl -eq "")
            {
                Write-Host "Configuring Outlook Web App URLs"
                Get-OwaVirtualDirectory -Server $i | Set-OwaVirtualDirectory -ExternalUrl $null -InternalUrl https://$internalurl/owa

                Write-Host "Configuring Exchange Control Panel URLs"
                Get-EcpVirtualDirectory -Server $i | Set-EcpVirtualDirectory -ExternalUrl $null -InternalUrl https://$internalurl/ecp

                Write-Host "Configuring ActiveSync URLs"
                Get-ActiveSyncVirtualDirectory -Server $i | Set-ActiveSyncVirtualDirectory -ExternalUrl $null -InternalUrl https://$internalurl/Microsoft-Server-ActiveSync

                Write-Host "Configuring Exchange Web Services URLs"
                Get-WebServicesVirtualDirectory -Server $i | Set-WebServicesVirtualDirectory -ExternalUrl $null -InternalUrl https://$internalurl/EWS/Exchange.asmx

                Write-Host "Configuring Offline Address Book URLs"
                Get-OabVirtualDirectory -Server $i | Set-OabVirtualDirectory -ExternalUrl $null -InternalUrl https://$internalurl/OAB

                Write-Host "Configuring MAPI/HTTP URLs"
                Get-MapiVirtualDirectory -Server $i | Set-MapiVirtualDirectory -ExternalUrl $null -InternalUrl https://$internalurl/mapi
            }
            else
            {
                Write-Host "Configuring Outlook Web App URLs"
                Get-OwaVirtualDirectory -Server $i | Set-OwaVirtualDirectory -ExternalUrl https://$externalurl/owa -InternalUrl https://$internalurl/owa

                Write-Host "Configuring Exchange Control Panel URLs"
                Get-EcpVirtualDirectory -Server $i | Set-EcpVirtualDirectory -ExternalUrl https://$externalurl/ecp -InternalUrl https://$internalurl/ecp

                Write-Host "Configuring ActiveSync URLs"
                Get-ActiveSyncVirtualDirectory -Server $i | Set-ActiveSyncVirtualDirectory -ExternalUrl https://$externalurl/Microsoft-Server-ActiveSync -InternalUrl https://$internalurl/Microsoft-Server-ActiveSync

                Write-Host "Configuring Exchange Web Services URLs"
                Get-WebServicesVirtualDirectory -Server $i | Set-WebServicesVirtualDirectory -ExternalUrl https://$externalurl/EWS/Exchange.asmx -InternalUrl https://$internalurl/EWS/Exchange.asmx

                Write-Host "Configuring Offline Address Book URLs"
                Get-OabVirtualDirectory -Server $i | Set-OabVirtualDirectory -ExternalUrl https://$externalurl/OAB -InternalUrl https://$internalurl/OAB

                Write-Host "Configuring MAPI/HTTP URLs"
                Get-MapiVirtualDirectory -Server $i | Set-MapiVirtualDirectory -ExternalUrl https://$externalurl/mapi -InternalUrl https://$internalurl/mapi
            }



            Write-Host "Configuring Autodiscover"
            Get-ClientAccessServer $i | Set-ClientAccessServer -AutoDiscoverServiceInternalUri https://$internalurl/Autodiscover/Autodiscover.xml

            Write-Host "`r`n"
        }
        else
        {
            Write-Host -ForegroundColor Yellow "$i is not a Client Access server."
        }
    }
}

End {

    Write-Host "Finished processing all servers specified. Consider running Get-CASHealthCheck.ps1 to test your Client Access namespace and SSL configuration."
    Write-Host "Refer to http://exchangeserverpro.com/testing-exchange-server-2013-client-access-server-health-with-powershell/ for more details."

}

#...................................
# Finished
#...................................