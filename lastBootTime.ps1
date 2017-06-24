$host = read-host "Computer name: "
get-wmiobject -class win32_operatingsystem -computername $host 
Select-Object -Property CSName,@{n=”Last Booted”;

e={[Management.ManagementDateTimeConverter]::ToDateTime($_.LastBootUpTime)}}