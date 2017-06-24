$cred = get-credential
connect-viserver ("sbdvisp01.ecimain.ecipay.com", ecivisp01.ecimain.ecipay.com")
$vms = ("ECIVPSI01", "SBDVPSI01", "SBDVPSI02","SBDVPSI03")
get-vm $vms | New-HardDisk -CapacityKB 10000 -Persistence persistent -ThinProvisioned $true