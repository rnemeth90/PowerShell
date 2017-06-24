Configuration IISWebsite
{
    Node ("Web01","Web02")
    {

        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }

        WindowsFeature ASP 
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
        }

        WindowsFeature "IIS Management"
        {
            Ensure = "Present"
            Name = "Web-Mgmt-Tools"
        }

        File WebContentDefault
        {
            Ensure = "Absent"
            Type = "Directory"
            DestinationPath = "C:\inetpub\wwwroot"
            Recurse = $true
        }
    }
}



