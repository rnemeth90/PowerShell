

#Function for writing to log file

$logfile = ".\playWithFunctions.log"

function writeLog(){
    param(
        [String]$value1
    )

    $date = Get-Date -DisplayHint DateTime
    [String]$date + " " + $value1 | Out-File $logfile -Append

}