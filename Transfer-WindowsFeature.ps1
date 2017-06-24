<#
    .SYNOPSIS 
      Transfers features from one server to another, does not transfer configurations
    .EXAMPLE
     Transfer-WindowsFeature -Source <ServerName>
    .NOTES
     Author: Ryan Nemeth - RyanNemeth@live.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     This function will get a list of installed features on a specified source server and then install
     those features on the server where the script is running. 
#>

#Command line parameter for source server
param (
[Parameter(Mandatory=$True,ValueFromPipeline=$true)]
[string]$Source
)
# ***THIS IS NO LONGER NEEDED, BUT THE AUTHOR IS A HOARDER***
#Get a source server
#$source = read-host("Source Server: ")


#Get a list of features from a remote server and store them in the $InstalledFeatures variable
$InstalledFeatures = Get-WindowsFeature -ComputerName $source | Where-Object InstallState -EQ Installed


#Iterate through the list of features in $InstalledFeatures and attempt to install each one
Foreach($Feature in $InstalledFeatures){
        #Output progreess to console
        #This next line works (Kinda), but is extremely ugly, doesn't list features being installed, needs work
        #Write-Host("Now Installing", $Feature) -BackgroundColor DarkGray -ForegroundColor Red
        write-host("Now Installing Features. Please wait...")
        #Install the features, suppress output
        install-windowsfeature $Feature | Out-Null
    }


#Prompt to restart the machine
$Restart = Read-Host("Would you like to restart the server? Y or N")
   
if($Restart -eq "Y"){
    Restart-computer -Force
    }
else{
    Write-Host("Please restart ASAP") -ForegroundColor Red -BackgroundColor Black
    }
   