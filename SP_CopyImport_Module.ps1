#Run PowerShell as Administrator

Get-Host
#Verify the version is 2.0.

Set-ExecutionPolicy unrestricted
y
#This allows all modules to run regardless of where they came from.

$env:PSModulePath
#Note the location of the modules, you will be placing the SP modules here ("C:\windows\system32\WindowsPowerShell\v1.0\Modules").
#(This step already done on virtual) Extract SPModule.zip to "C:\windows\system32\WindowsPowerShell\v1.0\Modules"

#(This step done on virtual, remove # to run) Get-ChildItem -path "C:\windows\system32\WindowsPowerShell\v1.0\Modules\SPModule" | Move-Item -destination "C:\windows\system32\WindowsPowerShell\v1.0\Modules"
#(This step done on virtual, remove # to run) Remove-Item "C:\windows\system32\WindowsPowerShell\v1.0\Modules\SPModule"
#This will move SPModule.misc and SPModule.setup from the SPModule folder and delete the SPModule folder.

Import-Module "C:\windows\system32\WindowsPowerShell\v1.0\modules\SPModule.misc"
r
r
r
r
r
r
r
Import-Module "C:\windows\system32\WindowsPowerShell\v1.0\modules\SPModule.setup"
r
r
r
r
r
r
r
#This will import the SP modules into the system so the cmdlets can be run.

Set-ExecutionPolicy allsigned
y
#This changes the signed security settings back.