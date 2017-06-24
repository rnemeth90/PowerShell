<#
    .SYNOPSIS 
     Deploys multiple Azure Virtual Machines. Specifications for the virtual machines should be contained in a CSV file
     called virtualMachines.csv. This file should exist in the same directory as this script. 
    .PARAMETER Mode
     This script accepts no parameters. 
    .EXAMPLE
     Deploy-AzureVMs
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
#>

$operatingSystem = "Windows Server 2012 R2 Datacenter"
$vmList = Import-Csv .\virtualMachines.csv
$creds = get-credential
$subscriptionID = Read-Host "Enter your subscription ID: "

foreach($vm in $vmList){
    Write-Host "Deploying Virtual Machine: " $vm.vmName
    New-AzureQuickVM -Windows -ServiceName $vm.vmName -Name $vm.vmName -ImageName $operatingSystem -Location $vm.vmlocation –InstanceSize $vm.vmSize -AdminUsername $creds.UserName –Password $vm.vmPassword 
}