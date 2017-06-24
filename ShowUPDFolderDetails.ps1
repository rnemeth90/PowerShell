$UPDShare = $args[0]
$fc = new-object -com scripting.filesystemobject
$folder = $fc.getfolder($UPDShare)
"Username,SiD" >> export.csv
foreach ($i in $folder.files)
{
  $sid = $i.Name
  $sid = $sid.Substring(5,$sid.Length-10)
  if ($sid -ne "template")
  {
    $securityidentifier = new-object security.principal.securityidentifier $sid
    $user = ( $securityidentifier.translate( [security.principal.ntaccount] ) )
    $user,$i.Name -join "," >> export.csv
  }
}
$a = Import-Csv export.csv
$a