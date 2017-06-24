##==============================================================================
##==============================================================================
## SCRIPT.........: Get-AllComputerLastLogon
## AUTHOR.........: Clint McGuire
## EMAIL..........:
## VERSION........: 1
## DATE...........: 2011_05_26
## COPYRIGHT......: 2011, Clint McGuire
## LICENSE........:
## REQUIREMENTS...: Powershell v2.0, Quest AD Cmdlets
## DESCRIPTION....: Gets all computer accounts' last logon times and exports to CSV file.
## NOTES..........:
## CUSTOMIZE......:
##==============================================================================
## REVISED BY.....:
## EMAIL..........:
## REVISION DATE..:
## REVISION NOTES.:
##
##==============================================================================
##==============================================================================
##==============================================================================
## START <code>
##==============================================================================
$DCs = Get-QADComputer -ComputerRole DomainController
$LastLogon = @{}
ForEach ($DC in $DCs) {
$Computers = Get-QADcomputer -Service $dc.dnshostname -ip lastlogontimestamp
ForEach ($Computer in $Computers)
{
If ($Computer.lastlogontimestamp -ne $null)
{
$Time = $Computer.lastlogontimestamp | Get-Date -format u
}
Else
{
$Time = $Computer.lastlogontimestamp
}
$ComputerName = $Computer.ComputerName
If ($LastLogon.ContainsKey($ComputerName))
{
If ($LastLogon.Get_Item($ComputerName) -le $Time)
{
$LastLogon.Set_Item($ComputerName, $Time)
}
}
Else
{
$LastLogon.Add($ComputerName, $Time)
}
}
}
$LastLogon.GetEnumerator() | Sort-Object Name |export-csv $home\ComputerLastLogon.csv -NoTypeInformation
##==============================================================================
## END <code>
##===========================================================================