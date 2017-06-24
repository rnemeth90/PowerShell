Configuration DeployFile{

    param(
        [Parameter(Mandatory=$True)]
        [String]$Servers,
        [Parameter(Mandatory=$True)]
        [String]$SourceFile,
        [Parameter(Mandatory=$True)]
        [String]$DestinationFile
    )

    Node $Servers{
        File CopyHostFile{
            Force = $True
            Ensure = "Present"
            Type = "File"
            SourcePath = $SourceFile
            DestinationPath = $DestinationFile  
        }
    }
}