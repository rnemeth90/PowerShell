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

param(
    [string]$SourcePath,
    [String]$EDBFilePath,
    [String]$LogFilePath,
    [String]$OrganizationName,
    [String]$Receipient,
    [string]$Sender, 
    [String]$EmailServer,
    [ValidateSet(mailbox,cas,mbAndCas)][String]$Roles
)

$ScriptStartDate = Get-Date

function TestConnection () {
    if(Test-Connection www.google.com -Quiet){
        break
    }
    else{
        Write-Host "This Server Does Not Have Internet Access. This script requires access to the interwebz." -ForegroundColor Red -BackgroundColor Black
    }

    if (-not((Get-WMIObject win32_OperatingSystem).OSArchitecture -eq '64-bit')){
        Write-Host "This script requires a 64bit version of Windows Server" -ForegroundColor Red -BackgroundColor Black
        Exit
    }
}

function InstallFeatures () {
    Install-WindowsFeature Desktop-Experience, NET-Framework, NET-HTTP-Activation, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Web-Server, WAS-Process-Model, Web-Asp-Net, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, RSAT-ADDS

    Install-WindowsFeature net-framework-core -IncludeAllSubFeature -IncludeManagementTools
}

Function InstallUcmaRuntime () {
    if (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{95140000-2000-0409-1000-0000000FF1CE}" -ErrorAction SilentlyContinue){
        Write-host "FilterPack is already installed." -ForegroundColor yellow
        return
    }
    else{
        New-Item -ItemType Directory -Path c:\Exchange
        
        $client = New-Object System.Net.WebClient
        $client.DownloadFile("https://www.microsoft.com/en-us/download/confirmation.aspx?id=34992","c:\Exchange")
        
        Write-Host "Waiting for UCMA Runtime to download..." -ForegroundColor Yellow
        Start-Sleep -Seconds 120
        c:\Exchange\UcmaRuntimeSetup.exe -q
        Write-Host "Waiting for UCMA Runtime to install..." -ForegroundColor Yellow
        Start-Sleep -Seconds 120
    }
}

function EmailAlert () {
    If($EmailServer -ne $null){

    $Subject = "Exchange Server Installation"
    $ScriptEndDate = Get-Date
    $ScriptElapsedTime = $ScriptEndDate - $ScriptStartDate
    write-host "Script Started $ScriptStartDate"
    $body = "Script Started $ScriptStartDate <br>"
    write-host "Script Ended $ScriptEndDate"
    $body += "Script Ended $ScriptEndDate <br>"
    write-host ("Script took " + $ScriptElapsedTime.hours + ":" + $ScriptElapsedTime.minutes + ":" + 
        $ScriptElapsedTime.seconds)
    $body += ("Script took " + $ScriptElapsedTime.hours + ":" + $ScriptElapsedTime.minutes + ":" + $ScriptElapsedTime.seconds)

    Send-MailMessage -To $Receipient -From $Sender -Subject $Subject -Body "$body" -SmtpServer $EmailServer -BodyAsHtml
    }
}

function Main () {
    Set-Location $SourcePath
    if($roles -eq "mailbox"){
        Setup.exe /Mode:Install /IAcceptExchangeServerLicenseTerms /Roles:mb,mt 
    }
    elseif($roles -eq "cas"){
        Setup.exe /Mode:Install /IAcceptExchangeServerLicenseTerms /Roles:cas,mt 
    }
    elseif($roles -eq "mbAndCas"){
        Setup.exe /Mode:Install /IAcceptExchangeServerLicenseTerms /Roles:cas,mb,mt 
    }
}




