[CmdletBinding()] 
        Param 
          (            
            [parameter(Mandatory=$true)] 
            [String]$InputFileName,
		[parameter(Mandatory=$true)] 
           			 [String]$HTMLFileName,
				[parameter(Mandatory=$false)]
			[ValidateSet("Error","Warning","Information","NonDefault","Baseline","BestPractice","All")]
            [String]$InformationType="All"
          ) 
Begin 
{ 
	if (Get-ChildItem $InputFileName -ErrorAction SilentlyContinue)
	{
		$xmlFile = [xml](Get-Content $InputFileName)
	}
	else
	{
		Write-Error "Unable to find the file.Please check if the file exists and try again." -ErrorAction Stop
	}
}
Process
{
	If ($InformationType -eq "Information")
	{
		$parseddata = $xmlFile.SelectNodes("ObjectCollector//Message") | Where-Object {$_.Error -eq "None"} | select @{L="ErrorType";E={$_.error}},@{L="Server";E={$_.P2}},@{L="Object";E={$_.P3}},@{L="Info";E={$_.Title}},@{L="Description";E={$_.innertext}} 
		write-output $parseddata | ConvertTo-HTML | Out-File "$HTMLFileName"
	}
	elseif ($InformationType -eq "All")
	{
		$parseddata = $xmlFile.SelectNodes("ObjectCollector//Message") | select @{L="ErrorType";E={$_.error}},@{L="Server";E={$_.P2}},@{L="Object";E={$_.P3}},@{L="Info";E={$_.Title}},@{L="Description";E={$_.innertext}} 
		write-output $parseddata  | ConvertTo-HTML | Out-File "$HTMLFileName"
	}
	else
	{	
		$parseddata = $xmlFile.SelectNodes("ObjectCollector//Message") | Where-Object {$_.Error -eq $InformationType} | select @{L="ErrorType";E={$_.error}},@{L="Server";E={$_.P2}},@{L="Object";E={$_.P3}},@{L="Info";E={$_.Title}},@{L="Description";E={$_.innertext}} 
		write-output $parseddata  | ConvertTo-HTML | Out-File "$HTMLFileName"		
	}
	
}
End
{
}
<# 
    .SYNOPSIS 
    Parse XML data from EXBPA.
     
    .DESCRIPTION 
    Parse XML data from EXBPA.It can get the below information out from the XML.
        1. Error Type 
        2. Server
        3. Object (Could be server, database etc.,)
        4. Title (About the Item)
        5. Detailed Information        
         
    .PARAMETER <InputFileName> 
        Specify path of the ExBPA xml file.    
    
	.PARAMETER <InformationType> 
        Specify what data needs to be exported.    
		Below are the only valid options:
			Error
			Warning
			Information
			NonDefault
			Baseline
			BestPractice
			All
	.EXAMPLE	
		Parse-ExBPAXML -InputFileName "Test.xml" -InformationType "Warning"	
		Parses the ExBPA XML and then return collection of XML Element Objects which are only of type Warning.
	.EXAMPLE
		Parse-ExBPAXML -InputFileName "Test.xml"
		Parses the ExBPA XML and then return collection of XML Element Objects.
			
    .LINK 
        www.myExchangeWorld.com 
#> 