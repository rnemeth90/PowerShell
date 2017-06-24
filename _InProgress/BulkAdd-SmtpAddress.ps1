<#
    .SYNOPSIS 
     This script changes the primary email address for all mailboxes in Exchange Online
     or Exchange On-prem. 
    .PARAMETER Mode
     This script accepts one parameter. 
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
#>

param(
    [Parameter(Mandatory=$False)]
    [String]$Online,
    [Parameter(Mandatory=$True)]
    [String]$DomainName,
    [Parameter(Mandatory=$False)]
    [bool]$IsDefault,
    [Parameter(Mandatory=$False)]
    [String]$AllMailboxes,
    [Parameter(Mandatory=$False)]
    [String]$Mailbox
)


#Null out the variables
$checkConnection = $null
$Mailboxes = $null
$EmailAddresses = $null
$MB = $null
$NewAddress = $null

#Check if connected to Exchange Online PowerShell
#Connect if not already connected
$checkConnection = Get-PsSession | Where-Object ConfigurationName -eq "Microsoft.Exchange" -ErrorAction SilentlyContinue

if($Online){
    if($checkConnection -eq $null){
        $cred=Get-Credential
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
        Import-PSSession $Session
    }else{
        continue
    }
}

<#
function addAddressAndSetDefault(OptionalParameters){
    [String]$EmailAddresses = $Mb.EmailAddresses
    [string]$EmailAddresses.Replace("SMTP","smtp")
    [String]$NewAddress = " SMTP:" + $Mb.Alias + "@" + $DomainName
    Set-Mailbox $Mb.alias -EmailAddresses @{add="$NewAddress"}
}

function addAddress(OptionalParameters){
    [String]$EmailAddresses = $Mb.EmailAddresses
    [String]$NewAddress = " smtp:" + $Mb.Alias + "@" + $DomainName
    Set-Mailbox $Mb.alias -EmailAddresses @{add="$NewAddress"}
}
#>

if($AllMailboxes){
    $Mbs = Get-Mailbox
    Foreach($Mb in $Mbs){ 
        if($IsDefault){
            [String]$EmailAddresses = $Mb.EmailAddresses
            [string]$EmailAddresses.Replace("SMTP","smtp")
            [String]$NewAddress = " SMTP:" + $Mb.Alias + "@" + $DomainName
            Set-Mailbox $Mb.alias -EmailAddresses @{add="$NewAddress"}
        }else{
            [String]$EmailAddresses = $Mb.EmailAddresses
            [String]$NewAddress = " smtp:" + $Mb.Alias + "@" + $DomainName
            Set-Mailbox $Mb.alias -EmailAddresses @{add="$NewAddress"}
        }
    }
}elseif($Mailbox){
    if($IsDefault){
        [String]$EmailAddresses = $Mb.EmailAddresses
        [string]$EmailAddresses.Replace("SMTP","smtp")
        [String]$NewAddress = " SMTP:" + $Mb.Alias + "@" + $DomainName
        Set-Mailbox $Mb.alias -EmailAddresses @{add="$NewAddress"}
    }else{
        [String]$EmailAddresses = $Mb.EmailAddresses
        [String]$NewAddress = " smtp:" + $Mb.Alias + "@" + $DomainName
        Set-Mailbox $Mb.alias -EmailAddresses @{add="$NewAddress"}
    }
}else{
    Write-Host "You must specify the $Mailbox or $AllMailboxes parameter" -ForegroundColor Red
}
