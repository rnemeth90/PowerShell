<# 
.SYNOPSIS 
    This script renames a computer using WMI. 
.DESCRIPTION 
    This script uses the Rename method from
    the Win32_OperatingSystem WMI class.  
    This is sample 5 from http://msdn.microsoft.com/en-us/library/aa394586 
.NOTES 
    File Name  : Set-ComputerName.ps1 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell Version 2.0 
.LINK 
    This script posted to: 
        http://www.pshscripts.blogspot.com 
    MSDN sample posted tot: 
        http://msdn.microsoft.com/en-us/library/aa394586%28VS.85%29.aspx 
.EXAMPLE 
    Left as an exercise for the Reader 
#> 
# This script takes two parameters, The computer to  
# rename and then the newname for that computer 
 
param ( 
[$String] $NewName = 'NewName', 
[$string] $Comp = "." 
} 
 
# Get computer object 
$Computer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $comp 
 
#Rename the Computer 
$Return  = $Computer.Rename($NewName) 
 
if ($return.ReturnValue -eq 0) { 
   "Computer name is now: $NewName" 
   " but you need to reboot first" 
} else { 
"  RenameFailed, return code: {0}" -f $return.ReturnValue 
} 
Posted by Thomas Lee at 9/25/2011 12:50:00 pm 0 comments   Links to this post
TUESDAY, 13 SEPTEMBER 2011
Remove-WmiRegistryKey.ps1
<# 
.SYNOPSIS 
    This script creates removes registry key using WMI. 
.DESCRIPTION 
    This script uses WMI to get remove registry key.  
    This script deletes the key and everything below 
    it in the registry - use carefully! 
.NOTES 
    File Name  : Remove-WmiRegistryKey.ps1 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell Version 2.0 
.LINK 
    This script posted to: 
        http://www.pshscripts.blogspot.com 
    MSDN sample posted to: 
        http://msdn.microsoft.com/en-us/library/aa394600%28VS.85%29.aspx 
.EXAMPLE 
    Psh[C:\foo]>New-WMIRegistryKey.ps1 
    Key removed 
#> 
 
# Define Constants 
$HKEY_Local_Machine =2147483650  
$computer ='.' 
 
# Get Class to call static methods on 
$reg = [WMIClass]"ROOT\DEFAULT:StdRegProv" 
 
# Define key to create 
$Key     = "SOFTWARE\NewKey" 
 
# Create key and display reslts 
$results   = $reg.DeleteKey($HKEY_LOCAL_MACHINE, $Key) 
If ($results.Returnvalue -eq 0) {"Key Removed"}  