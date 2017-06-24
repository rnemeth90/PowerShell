#

$host = Read-Host("Server you want to install the GMSA on")

$kdsRootKey = Add-KdsRootKey -EffectiveTime ((Get-Date).addhours(-10))

Write-Host "Your KDS Root key is: ", $kdsRootKey

New-AdServiceAccount -Name $GMSAName -DNSHostName $DNSServer

Set-ADServiceAccount -identity $GMSAName -PrincipalsAllowedtoRetrieveManagedPassword $Host

Install-AdServiceAccount -Identity $GMSAName -computer $Host
