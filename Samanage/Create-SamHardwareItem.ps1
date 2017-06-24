#read-host -assecurestring | convertfrom-securestring | out-file securestring.txt
 
$username = ""
$password = "" | convertto-securestring
$Credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
 
$headers = @{"Accept"="application/vnd.samanage.v1.1+xml"}
$ContentType = "text/xml"
 
#Create XML data for upload
$newowner = ""
$xmltext = "<hardware><owner><email>$newowner</email></owner></hardware>"
$xmldata = [xml] $xmltext
 
# 101010 = Samanage ID of Hardware to update
$uri = "https://api.samanage.com/hardwares/101010.xml";
Invoke-WebRequest $uri -Credential $Credentials -Method put -ContentType $ContentType -Body $xmldata -Headers $headers