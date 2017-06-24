# Gets time stamps for all computers in the domain that have NOT logged in for x days
#
#This will get today's date and subtract x days from today in the format MM/dd/yyyy

$days = read-host "How many days back would you like to go?"
$today = get-date
$past = $today.AddDays(-$days)
$pastformat = $past.ToString("MM/dd/yyyy")

# Get all AD computers
Import-Module ActiveDirectory
get-aduser -filter * | where {$_.enabled -eq "true"}|
Get-ADObject -Properties lastlogontimestamp |

# lastLogonTimestamp - date specified is less than zero, outputs it to a CSV file is working directory
where {(([DateTime]::FromFileTime($_.lastlogontimestamp) - ([system.datetime]$pastformat)).totaldays) -lt 0 } |


# Output hostname and lastLogonTimestamp into CSV
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
