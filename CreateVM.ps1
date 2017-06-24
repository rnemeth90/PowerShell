# Create-VM.ps1 
# Script that creates VMs 
# Version 1.0.0 - 20 Jan 2013 
# See http://tfl09.blogspot.co.uk/2013/01/building-hyper-v-test-lab-on-windows-8.html 
 
# First define the Create-VM Function 
 
Function Create-VM { 
#=================================================== 
# Create a New VM 
#=================================================== 
 
# Parameters are Name, Virtual Machine Path, path to reference Vhdx,
# network switch to use, VM Memory, Unattend file, IP address and DNS
# Server to set. Default values are specified in the Param block,
# but these are normally overridden in the call to Create0VM 
 
 
[Cmdletbinding()] 
Param (  
 $Name         = "Server", 
 $VmPath       = "C:\v3", 
 $ReferenceVHD = "C:\v3\Ref2012.vhdx", 
 $Network      = "Internal", 
 $VMMemory     = 512mb, 
 $UnattendXML  = "C:\v3\unattend.xml", 
 $IPAddr       = '10.0.0.250/24', 
 $DnsSvr       = '10.0.0.10' 
) 
 
$Starttime = Get-Date 
Write-Verbose "Starting Create-VM at $Starttime" 
Write-verbose "Creating VM: [$name]" 
Write-verbose "Path to VM : [$VMpath]" 
 
#    Set path to differencing disk location 
$path = "$vmpath\$name.vhdx" 
Write-Verbose "Creating Disk at [$path]" 
 
#    Add a new differencing VHDX, Based on parent parent 
$vmDisk01 = New-VHD –Path $path -Differencing –ParentPath $ReferenceVHD -ErrorAction Stop 
Write-Verbose "Added VM Disk [$VMdisk01], pointing to [ReferenceVHD]" 
 
#    Create a New VM 
$VM = New-VM –Name $name –MemoryStartupBytes $VMMemory –VHDPath $VMDisk01.path -SwitchName $Network -Path $vmPath 
Write-Verbose "VM [$name] created" 
 
# Mount the Disk into the VM 
Mount-DiskImage -ImagePath $path 
$VHDDisk = Get-DiskImage -ImagePath $path | Get-Disk 
$VHDPart = Get-Partition -DiskNumber $VHDDisk.Number 
$VHDVolumeName = [string]$VHDPart.DriveLetter 
$VHDVolume = [string]$VHDPart.DriveLetter + ":" 
Write-verbose "Volume [$Volumename] created in VM [$name]" 
 
 
#    Get Unattended.XML file 
Write-Verbose "Using Unattended XML file [$unattendXML]" 
 
#    Open XML file 
$Xml = [xml](get-content $UnattendXML) 
 
#    Change ComputerName 
Write-Verbose "Setting VM ComputerName to: [$name]" 
$Xml.unattend.settings.component | Where-Object { $_.Name -eq "Microsoft-Windows-Shell-Setup" } | 
 ForEach-Object { 
   if($_.ComputerName) { 
     $_.ComputerName = $name 
   } 
} 
 
#    Change IP address 
Write-Verbose "Setting VM ComputerName to: [$name]" 
$Xml.unattend.settings.component | Where-Object { $_.Name -eq "Microsoft-Windows-TCPIP" } | 
  ForEach-Object { 
 
    if($_.Interfaces) { 
      $ht='#text' 
      $_.interfaces.interface.unicastIPaddresses.ipaddress.$ht = $IPAddr 
  } 
} 
 
#    Change DNS Server address 
#    Use obscure way to create the #TEXT node 
Write-Verbose "Setting VM DNS address to: [$DNSSvr]" 
$Xml.Unattend.Settings.Component | Where-Object { $_.Name -eq "Microsoft-Windows-DNS-Client" } | 
  ForEach-Object { 
      if($_.Interfaces) { 
      $ht='#text' 
      $_.Interfaces.Interface.DNSServerSearchOrder.Ipaddress.$ht = $DNSSvr 
  } 
} 
 
#    Save XML File on Mounted VHDX differencing disk 
$xml.Save("$VHDVolume\Unattend.XML") 
Write-Verbose "Unattended XML file saved to vhd [$vhdvolume\unattend.xml]" 
 
#    Dismount VHDX  
Write-Verbose "Dismounting disk image: [$Path]" 
Dismount-DiskImage -ImagePath $path 
 
#    Update additional VM settings 
Write-Verbose 'Setting additional VM settings' 
Set-VM -Name $name -DynamicMemory 
Set-VM -Name $name -MemoryMinimumBytes $VMMemory 
Set-VM -Name $name -AutomaticStartAction Nothing 
Set-Vm -Name $name -AutomaticStopAction ShutDown 
 
#    Show what has been created! 
"VM Created:" 
Get-VM -Name $name | fl * 
 
#    Start VM 
Write-verbose "VM [$Name] being started" 
Start-VM -Name $name 
 
#    Now work out and write how long it took to create the VM 
$Finishtime = Get-Date 
Write-Verbose ("Creating VB ($name) took {0} seconds" -f ($FinishTime - $Starttime).totalseconds) 
}  # End of Create-VM function 
 
 
####################################################################################################### 
#       CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS     # 
#       CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS     # 
#       CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS     # 
 
# Location of Server 2012 DVD Iso Image 
$iso   = 'c:\Builds\9200.16384.120725-1247_x64frev_Server_Datacenter_VL_HRM_SSS_X64FREV_EN-US_DVD.iso' 
# Where we put the reference VHDX 
$ref   = 'c:\v3\Ref2012.vhdx' 
# Path were VMs, VHDXs and unattend.txt files live 
$path  = 'c:\V3' 
# Location of Unattend.xml - first for workstation systems, second for domain joined systems  
$una   = 'c:\V3\UnAttend.xml' 
$unadj = 'c:\V3\UnAttend.dj.xml' 
 
#       CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS     # 
#       CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS     # 
#       CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS     # 
####################################################################################################### 
 
#   Now run the script to create the VMs as appropriate. 
$Start = Get-Date 
"Create-VM --- Started at: $Start" 
 
#################################################################### 
# Comment out VMs you do NOT want to create then run the entire script 
# To comment out a VM creation, just add a '#" at the start of the line.  
#        Removing the comment line means you want to create that VM.  
#        BE creful!  If you make a mistake, stop the script. Kill any VMs created, then remove the 
#        storage for the VMs.  
####################################################################################################### 
 
#    Create the DC - NON-domained joined 
# Create-VM -name "DC1"  -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $una -Verbose -IPAddr '10.0.0.10/24' -DNSSvr 10.0.0.10  -VMMemory 1gb 
 
#    Remaining VMs use the domain-join version of unattend.xml 
# Create-VM -name "Srv1"  -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.30/24' -DNSSvr 10.0.0.10  -VMMemory 512mb 
# Create-VM -name "Srv2"  -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.31/24' -DNSSvr 10.0.0.10  -VMMemory 512mb 
# Create-VM -name "Sql1"  -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.20/24' -DNSSvr 10.0.0.10  -VMMemory 768mb 
# Create-VM -name "Exch1" -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.21/24' -DNSSvr 10.0.0.10  -VMMemory 768mb 
 
#    DHCP 1,2 for advanced networking class 
# Create-VM -name "DHCP1" -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.51/24' -DNSSvr 10.0.0.10 -VMMemory 512mb 
# Create-VM -name "DHCP2" -VmPath $path -ReferenceVHD $ref -Network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.52/24' -DNSSvr 10.0.0.10 -VMMemory 512mb 
 
#    Create a second DC for reskit.org for advanced class 
# Create-VM -name "DC2"  -vmPath $path -ReferenceVHD $ref -network "Internal" -UnattendXML $unadj -Verbose -IPAddr '10.0.0.11/24' -DNSSvr 10.0.0.10  -VMMemory 512mb 
 
 
#  script is all done - just say nice things and quit. 
$Finish = Get-Date 
"Create-VM --- Finished at: $Finish" 
"Elapsed Time :  $(($Finish-$Start).totalseconds) seconds" 
  