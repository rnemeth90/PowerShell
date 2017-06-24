#https://technet.microsoft.com/en-us/library/dn635115(v=exchg.150).aspx

########################
#### Variable Setup ####
########################

$serverName = Get-WmiObject -Class win32_ComputerSystem
$owaVDir = "Default Web Site/owa"
$ecpVDir = "Default Web Site/ecp"
$oabVDir = "Default Web Site/OAB"
$eacVDir = "Default Web Site/MSExchangeSyncAppPool"
$ewsVDir = "Default Web Site/EWS" 
$autodiscoverVDir = "Default Web Site/autodiscover"
$oaExternalHostName = "webmail.ecipay.com"

#######################
### Outlook Web App ###
#######################

#Disable SSL Offloading for Outlook Web App
appcmd set config $owaVDir /section:access /sslFlags:None /commit:APPHOST
#Recycle the Outlook Web App application pool
appcmd Recycle AppPool MSExchangeOWAAppPool

##############################
### Exchange Control Panel ###
##############################

#Disable SSL Offloading for Exchange Control Panel
appcmd set config $ecpVDir /section:access /sslFlags:None /commit:APPHOST
#Recycle the Exchange Control Panel application pool
appcmd Recycle AppPool MSExchangeECPAppPool

############################
###### Outlook Anywhere ####
############################

#Set-OutlookAnywhere -Identity $casServer\Rpc* -Externalhostname $oaExternalHostName -ExternalClientsRequireSsl:$True -ExternalClientAuthenticationMethod Basic
Set-OutlookAnywhere -Identity $casServer\Rpc* -SSLOffloading $True


############################
### Offline Address Book ###
############################
#Disable SSL Offloading for Offline Address Book
appcmd set config $oabVDir /section:access /sslFlags:None /commit:APPHOST
#Recycle the Offline Address Book application pool
appcmd Recycle AppPool MSExchangeOABAppPool


############################
### Exchange Active Sync ###
############################
#Disable SSL Offloading for Exchange Active Sync
appcmd set config $eacVDir /section:access /sslFlags:None /commit:APPHOST
#Recycle the Exchange Active Sync application pool
appcmd Recycle AppPool MSExchangeSyncAppPool


#############################
### Exchange Web Services ###
#############################
#Disable SSL Offloading for Exchange Web Services
appcmd set config $ewsVDIR /section:access /sslFlags:None /commit:APPHOST
#Recycle the Exchange Web Services application pool
appcmd Recycle AppPool MSExchangeServicesAppPool


#############################
######## Autodiscover #######
#############################
#Disable SSL Offloading for the Autodiscover service
appcmd set config $autodiscoverVDir /section:access /sslFlags:None /commit:APPHOST
#Recycle the autodiscover application pool
appcmd Recycle AppPool MSExchangeAutodiscoverAppPool


#Restart IIS
iisreset /force