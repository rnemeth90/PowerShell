Import-Module "D:\MDT2012x64\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "k:\DeploymentShare"
import-mdtdriver -path "DS001:\Out-of-Box Drivers" -SourcePath "C:\Windows\System32\DriverStore\FileRepository" -Verbose
