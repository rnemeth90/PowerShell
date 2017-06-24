<#
    .SYNOPSIS 
     Installs the SNMP Service and WMI Provider. Then configures the community string and SNMP Managers
    .PARAMETER Mode
     This script accepts no parameters
    .EXAMPLE
     Install-SNMPService
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
#>

#Vars
$mgrs = "snmp.tmcrv.com"
$commStr = "gwUhU19Azwj"
$contacts = "itnoc@tmcrv.com"
$Location = "606_Nelson's_Parkway_Wakarusa_Indiana_United_States"
$srv = hostname
$mailSrv = "mail.tmcrv.com"
$mailTo = "itinfrastructure@tmcrv.com"
$mailFrom = "snmpMon@tmcrv.com"
$mailCred = ([System.Management.Automation.PSCredential]::Empty) 
$status = Get-WindowsFeature -Name SNMP-Service

Import-Module ServerManager

#Install SNMP Service and WMI Provider if not already installed
if($status.Installed -ne "True" ){
    Install-WindowsFeature SNMP-Service -IncludeAllSubFeature | Out-Null
}

If($status.Installed -eq "True"){
    #reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" /v 1 /t REG_SZ /d localhost /f | Out-Null
    $i = 2
    foreach($mgr in $mgrs){
        reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" /v $i /t REG_SZ /d $mgr /f | Out-Null
        $i++
    }
    foreach($str in $commStr){
        reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v $str /t REG_DWORD /d 4 /f | Out-Null        
    }
    foreach($contact in $contacts){
        reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent" /v SysContact /t REG_DWORD /d $contact /f | Out-Null        
    }
#    foreach($contact in $contacts){
#        reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent" /v SysLocation /t REG_DWORD /d $Location /f | Out-Null        
#    }
}
Else {Out-Null}

#Send-MailMessage -To $mailTo -From $mailFrom -Subject "SNMP FAILED INSTALL" -Body "SNMP Failed to install on $srv" -SmtpServer $mailSrv 