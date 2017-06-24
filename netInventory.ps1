$PCs = "workstation1","workstation2","workstation3"            
# Or get the PCs from a text file:            
# $PCs = Get-Content PCs.txt            
$OutputArray = @()            
ForEach ($PC in $PCs) {            
    $bios = gwmi Win32_BIOS            -ComputerName $PC -Property Manufacturer, SerialNumber            
    $os   = gwmi Win32_OperatingSystem -ComputerName $PC -Property Caption, OSArchitecture            
    $cs   = gwmi Win32_ComputerSystem  -ComputerName $PC -Property DNSHostName
    $PCData = New-Object PSObject -Property @{            
         Manufacturer=$bios.Manufacturer;            
         SerialNumber=$bios.SerialNumber;            
         OSVersion=$os.Caption;            
         Arch=$os.OSArchitecture;            
         HostName=$cs.DNSHostName;            
        }            
    $OutputArray += $PCData            
}            
$OutputArray | Format-Table -AutoSize         