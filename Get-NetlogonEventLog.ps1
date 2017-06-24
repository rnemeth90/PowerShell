$wks = "WCS15019","WCS15101","WCS13380","WCS16446","WCS12533","WCS15800","14079","WCS18177","17265"

$result = get-eventlog -logname SYSTEM -Source Netlogon | Where-object Message -notlike $wks

write-host $result

