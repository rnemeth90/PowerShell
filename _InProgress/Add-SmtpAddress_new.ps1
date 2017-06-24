param(
    [Parameter(Mandatory=$True)]
    [String]$DomainName,
    [Parameter(Mandatory=$False)]
    [String]$Commit,
    [Parameter(Mandatory=$False)]
    [String]$MakePrimary
)

#Function for writing to log file

$logfile = ".\Add-SmtpAddress.log"

function writeLog(){
    param(
        [String]$value1
    )
    $date = Get-Date -DisplayHint DateTime
    [String]$date + " " + $value1 | Out-File $logfile -Append
}

$mbs = Get-Mailbox

foreach($mb in $mbs){
    
    writeLog "***"
    writeLog "***Starting process for $mb"

    $currentAddresses = Get-Mailbox $mb | Select-Object EmailAddresses

    writeLog "***Current Email Addresses are $currentAddresses"

    $NewAddress = $null

    if ($MakePrimary)
    {
        $NewAddress = "SMTP:" + $Mb.Alias + "@$Domain"
    }
    else
    {
        $NewAddress = "smtp:" + $Mb.Alias + "@$Domain"
    }    

    writeLog "***New address will be $NewAddress"

    if (!($Commit)){
        Write-Host "You did not specify the Commit parameter. Changes will not be saved."
        writeLog "***Commit parameter not specified. Changes will not be saved."
    }

    



}
