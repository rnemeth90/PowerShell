function helloWorld(){
    param(
        [String]$StringOne,
        [String]$StringTwo
    )

    Write-Host $StringOne $StringTwo
}

$logfile = ".\playWithFunctions.log"

function writeLog(){
    param(
        [String]$value1
    )

    $date = Get-Date -DisplayHint DateTime
    [String]$date + " " + $value1 | Out-File $logfile -Append

}

writeLog "Test..."
writeLog "Test2..."
writeLog "Test3..."


