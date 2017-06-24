Import-Module "D:\MDT2012x64\bin\MicrosoftDeploymentToolkit.psd1"
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "k:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\STARKILLER\DeploymentShare$" -Verbose | add-MDTPersistentDrive -Verbose
