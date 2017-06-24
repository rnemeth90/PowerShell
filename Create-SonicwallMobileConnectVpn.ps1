$VPNName="Vibe"
$ServerAddress="https://216.197.156.129:4433"
#$xml="<MobileConnect><Port>443</Port></MobileConnect>"
$sourceXml=New-Object System.Xml.XmlDocument
$sourceXml.LoadXml($xml)
Add-VpnConnection -Name $VPNName -ServerAddress $ServerAddress -SplitTunneling $True -PluginApplicationID SonicWALL.MobileConnect_cw5n1h2txyewy -CustomConfiguration $sourceXml