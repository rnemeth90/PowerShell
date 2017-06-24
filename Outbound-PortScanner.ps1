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

#Variables
$remoteHost = 207.46.163.42
$portrange = 20..1000
$logFile = .\portScanResults.txt

#Open connection for each port from the range
Foreach ($port in $portrange){
    $Socket = New-Object Net.Sockets.TcpClient      
    $ErrorActionPreference = 'SilentlyContinue'
    #Connect on the given port
    $Socket.Connect($remoteHost, $port)
    #Determine if the connection is established
    if ($Socket.Connected) {
        Write-Host "Outbound port $port is open." -ForegroundColor Yellow >> $logFile
        $Socket.Close()
    }
    else {
        Write-Host "Outbound port $port is closed or filtered." -ForegroundColor Red >> $logFile
    }
}
