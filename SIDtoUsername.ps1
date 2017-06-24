#Returns a username based on a SID
#Author: Ryan Nemeth
#Date: 12/5/2014

#print warning
#write-host "WARNING: This script will not work with computer SID's!"

#Get the SID
$SID = read-host "Please enter the SID "
#Create a new object from the SecurityIdentifier class with the SID as the value
$object = New-Object System.Security.Principal.SecurityIdentifier($SID)
#Translate the object into the username
$User = $object.Translate( [System.Security.Principal.NTAccount])
#print the username to stdout
write-host "The user is " $User.Value
