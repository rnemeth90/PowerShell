Import-Module "D:\MDT2012x64\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "k:\DeploymentShare"
import-mdtoperatingsystem -path "DS001:\Operating Systems" -SourceFile "K:\VMShare\install.wim" -DestinationFolder "install" -Verbose
