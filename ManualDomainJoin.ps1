#This script will send a remote command to computers in a list

#Setup Variables
$dc = @() #Holds name of domain controller
$inputFile = @() #Holds location for output
$computerList = @() #Holds computers to query

$dc = $env:COMPUTERNAME
$inputFile = "\\${dc}\DomainJoin\ADCompResults.txt" #File to use for computer input
$computerList = Get-Content $inputfile  #populate the list of computers to query with a filter
#$inputFile = Read-Host "Where is the computer list file? (ex. '\\server\share\ADCompResults.txt')"  #Prompts user for location of computer list

Start-Transcript -Path "\\${dc}\DomainJoin\Results.txt" -NoClobber
Foreach($computer in $computerList)
{
    $computer
    invoke-command -computername $computer -filepath "\\${dc}\DomainJoin\Invoke.ps1"
}
Stop-Transcript