
#Sets Variables
$dc = @() #Holds name of domain controller
$username = @() #Holds username for credentials
$Domain = @() #Holds domain
$password = @() #Holds password
$securepass = @() #Holds secure encrypted password
$cred = @() #Holds combined credentials

$dc = "2012-server08r2"
$username = "new\administrator"
$Domain = "new.local"
$password = "Paccess1"

$securepass = $password | convertto-securestring -asplaintext -force
$cred = (new-object -typename System.Management.Automation.PSCredential -argumentlist ($username, $securepass))

add-computer -Credential $cred -DomainName $Domain
Restart-Computer -force