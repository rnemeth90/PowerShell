$users = import-csv c:\users.csv
$attr = read-host "What attribute would you like to modify? "
$value = read-host "What value would you like to write to the attribute? "

foreach($user in $users){
    Set-ADUser -identity $user.SamAccountName -add @{"$attr"="$value"}
    write-host "Setting" $attr "attribute to" $value "for user account:" $user.SamAccountName
}