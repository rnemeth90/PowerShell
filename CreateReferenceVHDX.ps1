# Create-ReferenceVHDX.ps1
# Script that will create a reference VHDX for later VM Creation
# Version 1.0.0 - 14 Jan 2013
# Define a function to create a reference VHDX.
Function Create-ReferenceVHDX {
[Cmdletbinding()]
Param (
# ISO of OS
[string] $Iso = 'C:\downloads\9200.16384.120725-1247_x64frev_Server_Datacenter_VL_HRM_SSS_X64FREV_EN-US_DVD.iso',
# Path to reference VHD
[string] $RefVHDXPath = "C:\vhd\Ref2012.vhdx"
)
# Get start time
$StartTime = Get-Date
Write-Verbose "Beginning at $StartTime"
#--------------------------------------------------+
# Mount an ISO and check out available OS versions!
#--------------------------------------------------+
# Import the DISM module
Write-Verbose 'Loading DISM module' -Verbose:$false
Import-Module -Name DISM -Verbose:$False
# Mount the OS ISO image onto the local machine
Write-Verbose "Mounting ISO image [$iso]"
Mount-DiskImage -ImagePath $iso
# Get the Volume the Image is mounted to
Write-Verbose 'Getting disk image of the ISO'
$ISOImage = Get-DiskImage -ImagePath $ISO | Get-Volume
Write-Verbose "Got disk image [$($ISOImage.DriveLetter)]"
# And get the drive Letter of the dirve where the image is mounted
# add the drive letter separator (:)
$ISODrive = [string]$ISOImage.DriveLetter+":"
Write-Verbose "OS ISO mounted on drive letter [$ISODrive]"
# Next we will get the installation versions from the install.wim.
# $Indexlist is the index of WIMs on the DVD - display the versions
# available in the DVD and let user select the one to serve as the base
# image - probably DataCentre Full Install
$IndexList = Get-WindowsImage -ImagePath $ISODrive\sources\install.wim
Write-Verbose 'Got Index list - displaying it now!'
# Display the list and return the index
$item = $IndexList | Out-GridView -OutputMode Single
$index = $item.ImageIndex
Write-Verbose "Selected image index [$index]"
#---------------------------------+
# Create a Reference Image !
#---------------------------------+
# Create the VHDX for the reference image
$VMDisk01 = New-VHD –Path $RefVHDXPath -SizeBytes 15GB
Write-Verbose "Created VHDX File [$($vmdisk01.path)]"
# Get the disk number
Mount-DiskImage -ImagePath $RefVHDXPath
$VHDDisk = Get-DiskImage -ImagePath $RefVHDXPath | Get-Disk
$VHDDiskNumber = [string]$VHDDisk.Number
Write-Verbose "IReference image is on disk number [$VhddiskNumber]"
# Create a New Partition
Initialize-Disk -Number $VHDDiskNumber -PartitionStyle MBR
$VHDDrive = New-Partition -DiskNumber $VHDDiskNumber -UseMaximumSize -AssignDriveLetter -IsActive | Format-Volume -Confirm:$false
$VHDVolume = [string]$VHDDrive.DriveLetter+":"
Write-Verbose "VHD drive [$vhddrive], Vhd volume [$vhdvolume]"
# Execute DISM to apply image to base disk
Write-Verbose 'Using DISM to apply image to the volume'
Write-Verbose 'This will take some time'
Dism.exe /apply-Image /ImageFile:$ISODrive\Sources\install.wim /index:$Index /ApplyDir:$VHDVolume\
# Execute BCDBoot so volume will boot
Write-Verbose 'Setting BCDBoot'
BCDBoot.exe $VHDVolume\Windows /s $VHDVolume /f BIOS
# Dismount the Images
Write-Verbose "Dismounting ISO and new disk"
Dismount-DiskImage -ImagePath $ISO
Dismount-DiskImage -ImagePath $RefVHDXPath
Write-Verbose "Created Reference Disk [$RefVHDXPath]"
Get-ChildItem $RefVHDXPath
$FinishTime = Get-Date
$tt= $FinishTime - $StartTime
Write-Verbose "Finishing at $FinishTime"
Write-verbose "Creating base image took [$($tt.totalminutes)] minutes"
} # End of Create-ReferenceVHDX
################################################################################################################
# CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS #
# CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS #
# CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS #
# Path to Server 2012 DVD
$iso = 'C:\Builds\9200.16384.120725-1247_x64frev_Server_Datacenter_VL_HRM_SSS_X64FREV_EN-US_DVD.iso'
# PathTo the reference VDHX is to go
$refvhdxpath = 'C:\V3\ref2012.vhdx'
# CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS #
# CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS #
# CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS ===== CHECK THESE PATHS #
#################################################################################################################
Create-ReferenceVHDX -iso $iso -RefVHDXPath $RefVHDXPath -Verbose