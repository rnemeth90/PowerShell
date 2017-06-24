<# 
.SYNOPSIS 
    This script creates an Excel workbook using PowerShell and  
    populates it with the results of calling Get-Process and  
    copying across the key properties 
.DESCRIPTION 
    This script demonstrates manipulating Excel with PowerShell 
    and the Excel.Application COM object. 
.NOTES 
    File Name  : .\Get-ProcessesAsExcel.ps1 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell Version 2.0 
.LINK 
    This script posted to:
http://pshscripts.blogspot.com/2012/02/get-processesasexcelps1.html
.EXAMPLE 
    Left as an exercise to the reader. 
#> 
##  
# Start of Script 
## 
 
# First, create and single worksheet workbook 
 
# Create Excel object 
$excel = new-object -comobject Excel.Application 
    
# Make Excel visible 
$excel.visible = $true 
   
# Create a new workbook 
$workbook = $excel.workbooks.add() 
 
# The default workbook has three sheets, remove 2,4 
$S2 = $workbook.sheets | where {$_.name -eq "Sheet2"} 
$s3 = $workbook.sheets | where {$_.name -eq "Sheet3"} 
$s2.delete() 
$s3.delete() 
  
# Get sheet and update sheet name 
$s1 = $workbook.sheets | where {$_.name -eq 'Sheet1'} 
$s1.name = "Processes" 
   
# Update workook properties 
$workbook.author  = "Thomas Lee - Doctordns@gmail.com" 
$workbook.title   = "Processes running on $(hostname)" 
$workbook.subject = "Demonstrating the Power of PowerShell with Excel" 
   
# Next update Headers 
$s1.range("A1:A1").cells="Handles" 
$s1.range("B1:B1").cells="NPM(k)" 
$s1.range("C1:C1").cells="PM(k)" 
$s1.range("D1:D1").cells="WS(k)" 
$s1.range("E1:E1").cells="VM(M)" 
$s1.range("F1:F1").cells="CPU" 
$s1.range("G1:G1").cells="ID" 
$s1.range("H1:H1").cells="Process Name" 
 
$row = 2 
Foreach ($Process in $(Get-Process)) { 
 $s1.range("A$Row:A$Row").cells=$Process.handles 
 $s1.range("b$Row:B$Row").cells=$Process.NPM 
 $s1.range("c$Row:C$Row").cells=$Process.PM 
 $s1.range("d$Row:D$Row").cells=$Process.WS 
 $s1.range("e$Row:E$Row").cells=$Process.VM 
 $s1.range("f$Row:F$Row").cells=$Process.CPU 
 $s1.range("g$Row:G$Row").cells=$Process.ID 
 $s1.range("h$Row:H$Row").cells=$Process.Name 
 $row++ 
} 
 
# And save it away: 
$s1.saveas("c:\foo\process.xlsx") 
# end of script 