$cred = Get-Credential

$getAsset = Invoke-RestMethod -URI "https://techsupport.ecipay.com/configuration_items/5694334.xml" -Headers @{"Accept" = "application/vnd.samanage.v1.1+xml"} -Credential $cred -ContentType "application/xml" -Method GET
