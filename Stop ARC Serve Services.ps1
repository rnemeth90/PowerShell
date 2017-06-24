$srvs = get-service  -DisplayName "CA ARCServe*"

#$srv
foreach($srv in $srvs){
    Stop-Service $srv -Force
    Write-Host "Stopping " $srv
}

#$status = get-service  -DisplayName "CA ARCServe*" | select status
#$name = get-service  -DisplayName "CA ARCServe*" | select displayname

#foreach($srv in $srvs){
#    Write-Host $name "Status=" $status
#}
