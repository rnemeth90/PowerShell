# Get the thumbprint from the most recent local machine certificate 
$hexstr = @(ls cert:\LocalMachine\Root | ` 
    ?{$_.subject -eq "CN=$env:computername.$((gwmi win32_computersystem).domain)"} | ` 
    ?{$_.verify()} | sort -property notafter)[-1].thumbprint 
if(!$hexstr){ 
    throw "Error: Local machine certificate not found." 
} 
# Convert the thumbprint string into an array of hex byte strings 
$hexstrarray = @() 
for($i = 0;$i -lt $hexstr.length;$i += 2){ 
    $hexstrarray += "0x" + $hexstr.substring($i,2) 
} 
# Check for the existence of the key, updating or creating it as needed 
if((gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization').authcertificatehash){ 
    set-itemproperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization' ` 
        -name AuthCertificateHash -value ([byte[]]$hexstrarray) 
}else{ 
    [void](new-itemproperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization' -name AuthCertificateHash -value ([byte[]]$hexstrarray)) 
}