﻿<#
    .SYNOPSIS 
     Remove MyWebSearch (AppIntegrator64) AdWare
    .EXAMPLE
     Remove-MyWebSearch
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     This function will forcefully remove the MyWebSearch AdWare
#>

 

#Get the process(s) and kill it(them)
Write-Host "Stopping Processes....."
$myWebProc = Get-Process -Name *Appintegrat*
Stop-Process $myWebProc

$stillAlive = Get-Process -Name *Appintegrat*

#Remove all directories associated with the AdWare
Write-Host "Performing some magic...."
Remove-Item -Path %PROGRAM FILES%\TELEVISIONFANATIC\*.* -Recurse -Force
Remove-Item -Path %PROGRAM FILES%\CouponAlert*\*.* -Recurse -Force
Remove-Item -Path "%PROGRAM FILES%\Shop to Win *\*.*" -Recurse -Force
Remove-Item -Path c:\users\%username%\AppData\Local\dealcabby -Recurse -Force
Remove-Item -Path c:\users\%username%\AppData\Local\DownloadTerms -Recurse -Force


#Remove Registry Keys associated with the AdWare, create a backup first
Write-Host "Dancing with Unicorns..."
New-Item -ItemType Directory -Path c:\RegBackup
Reg export HKLM\System\CurrentControlSet\Services\TelevisionFanaticService\ c:\RegBackup\MyWebSearch.reg
Remove-Item -Path HKLM\System\CurrentControlSet\Services\TelevisionFanaticService\ -Recurse -Force
Remove-Item -Path "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Allin1Convert Home Page Guard 64 bit" -Recurse -Force
Remove-Item -Path "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\FromDocToPDF Home Page Guard 64 bit" -Recurse -Force
Remove-Item -Path "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\RadioRage Home Page Guard 64 bit" -Recurse -Force




