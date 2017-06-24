Configuration WebServers {

    Param {
        [Parameter(Mandatory=$True)]
        [String]$Servers
    }

    Node $Servers {
        WindowsFeature IIS
    }

}