#prompt for creds
$cred = get-credential

$Loop = $TRUE
while($Loop){


#######################################################################################################
    Write-Host ""
    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor DarkGreen
    write-host ******** Microsoft Online Administration Tool Menu ********* -ForegroundColor Green
    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor Darkgreen
    Write-Host ""

    write-host '
    Would you like to connect to Office365 or ExchangeOnline?
    You can say "Office365" or "ExchangeOnline"
    ' -foregroundcolor Yellow
    $choice = read-host " "
    

########################################################################################################

    try{

        if($choice -eq "Office365"){
            Clear-Host
            Import-Module msonline
            Write-Host "" 
            Write-Host "Importing MSOnline Powershell Module..." -ForegroundColor Yellow
            Write-Host "Done!" -ForegroundColor Yellow
            write-host ""
            Connect-MsolService -Credential $cred
            pause
            Clear-Host
            
            write-host 
            write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            write-host ++++++++++++++++++++++++ "Main Menu" +++++++++++++++++++++++++
            write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            write-host
            write-host
            write-host -ForegroundColor green  '------------------------------------------------------------' 
            write-host -ForegroundColor white  -BackgroundColor Blue 'Office 365 Management Menu' 
            write-host -ForegroundColor green  '------------------------------------------------------------' 
            write-host
            write-host                                              ' 1)  User Management'
	        write-host 
	        write-host                                              ' 2)  Group Management'
	        write-host 
	        write-host                                              ' 3)  Domain Management '
	        write-host
	        write-host                                              ' 4)  License Management'
	        write-host 
	        write-host                                              ' 5)  Role Management'
	        write-host 
	        write-host                                              ' 6)  Company Management'
	        write-host 
	        write-host 
            
            $opt = Read-Host "Choose a number"

                if($opt -eq "1"){

                    Clear-Host
                    write-host ""
                    write-host -ForegroundColor green  '---------------------------' 
                    write-host -ForegroundColor white  -BackgroundColor Blue 'Section 1: User Management ' 
                    write-host -ForegroundColor green  '---------------------------' 
                    write-host ""

                    Write-Host ""
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "1) Create a user"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "2) Reset a password"
                    Write-Host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "3) Add a UPN to a current user"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    write-host "4) Re-provision a user account"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "5) Get all info for a user"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "6) Remove a user account"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    write-host ""

                    $userOpt = Read-Host "Choose a number"
                    Clear-Host

                    if($userOpt -eq "1"){
					    #Create a user account
					    $upn = Read-Host "Username (Ex: jdoe@contoso.com)"
                        $first = Read-Host "First Name (Ex: John)"
                        $last = Read-Host "Last Name (Ex: Doe)"
                        #$pwExp = Read-Host "Set the users password to never expire? (Y/N)"
                        #if($pwExp -eq "Y"){
					    #    New-MsolUser -UserPrincipalName $upn -FirstName $first -LastName $last -DisplayName $first,$last -PasswordNeverExpires $true  #Will this work?
                        #    }
                        #elseif($pwExp -eq "N"){
                        #     New-MsolUser -UserPrincipalName $upn -FirstName $first -LastName $last -DisplayName $first,$last #Will this work?
                        #    }
				        }
                        #This loops back to the beginning, FIX!!!!
				    elseif($userOpt -eq "2"){
					    #Reset a user password
					    $userName = Read-Host "Username (Ex: jdoe@contoso.com)"
					    $newPass = Get-MsolUser -UserPrincipalName $userName | Set-MsolUserPassword
                        Write-Host "The new password is: " $newPass -ForegroundColor Red
				        }
				    elseif($userOpt -eq "3"){
					    #Add a UPN to a user account
					    $userName = Read-Host "Username (Ex: jdoe@contoso.com)"
                        $NewUserName = Read-Host "New Username"
					    Get-MsolUser -UserPrincipalName $userName | Set-MsolUserPrincipalName -NewUserPrincipalName $NewUserName
				        }
				    elseif($userOpt -eq "4"){
					    #Re-Provision a user account
					    $userName = Read-Host "Username (Ex: jdoe@contoso.com)"
                        Get-MsolUser -UserPrincipalName $newUserName | Redo-MsolProvisionUser
				        }
				    elseif($userOpt -eq "5"){
					    #Get all info for a user
					    $userName = Read-Host "Username (Ex: jdoe@contoso.com)"
					    Get-MsolUser -UserPrincipalName $userName |fl
				        }			
				    elseif($userOpt -eq 6){
					    #Remove a user account
					    $userName = Read-Host "Username (Ex: jdoe@contoso.com)"
					    Get-MsolUser -UserPrincipalName $UserName | Remove-MsolUser
				        }
                    }
                elseif($opt -eq "2"){
                    
                    Clear-Host
                    write-host ""
                    write-host -ForegroundColor green  '---------------------------' 
                    write-host -ForegroundColor white  -BackgroundColor Blue 'Section 2: Group Management ' 
                    write-host -ForegroundColor green  '---------------------------' 
                    write-host ""

                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "1) Create a group"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "2) Add a user to a group"
                    Write-Host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "3) Remove a user from a group"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    write-host "4) Re-provision a group"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "5) Get a list of all groups"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "6) Get a list of members of a group ***DOES NOT WORK YET***"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "7) Remove a group"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host ""
                    
                    $groupOpt = Read-Host "Choose a number"
                    Clear-Host

                    if($groupOpt -eq "1"){
                        $groupName = Read-Host "Name of the group (ex: 'This Group')"
                        New-MsolGroup -DisplayName $groupName
                        }
                    elseif($groupOpt -eq "2"){
                        $groupName = Read-Host "Name of the group (ex: 'This Group')"
                        $user = Read-Host "UPN of user (ex: jdoe@yourdomain.com)"
                        $Group = Get-MsolGroup | where-object { $_.DisplayName -eq $groupName} 
                        $userobj = Get-MsolUser | where-object { $_.Userprincipalname -eq $user } 
                        Add-MsolGroupMember -GroupObjectId $Group.ObjectId -GroupMemberObjectId $userobj.ObjectId -GroupMemberType "User"                              
                        }
                    elseif($groupOpt -eq "3"){
                        $groupName = Read-Host "Name of the group (ex: 'This Group')"
                        $user = Read-Host "UPN of user (ex: jdoe@yourdomain.com)"
                        $Group = Get-MsolGroup | where-object { $_.DisplayName -eq $groupName} 
                        $userobj = Get-MsolUser | where-object { $_.Userprincipalname -eq $user } 
                        Remove-MsolGroupMember -GroupObjectId $Group.ObjectId -GroupMemberObjectId $userobj.ObjectId -GroupMemberType "User"   
                        }
                    elseif($groupOpt -eq "4"){
                        $groupName = Read-Host "Name of the group (ex: 'This Group')"
                        $Group = Get-MsolGroup | where-object { $_.DisplayName -eq $groupName} 
                        Redo-MsolProvisionGroup -ObjectId $Group.ObjectId
                        Write-Host "The Group has been re-provisioned!"       
                        }
                    elseif($groupOpt -eq "5"){
                        Get-MsolGroup | select displayName,GroupType
                        }
                    elseif($groupOpt -eq "6"){
                        $groupName = Read-Host "Name of the group (ex: 'This Group')"
                        $Group = Get-MsolGroup | where-object { $_.DisplayName -eq $groupName}
                        Get-MsolGroupMember -GroupObjectId $group.ObjectId
                        }
                    elseif($groupOpt -eq "7"){
                        $groupName = Read-Host "Name of the group (ex: 'This Group')"
                        $Group = Get-MsolGroup | where-object { $_.DisplayName -eq $groupName}
                        Remove-MsolGroup -ObjectId $group.ObjectId -Force
                        }
                    }
                elseif($opt -eq "3"){
                    
                    Clear-Host
                    Write-Host ""
                    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor DarkGreen
                    write-host ******************** Domain Management ********************* -ForegroundColor Green
                    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor Darkgreen
                    Write-Host ""
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "1) Add a custom domain"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "2) Remove a domain"
                    Write-Host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "3) Get domain DNS verification settings"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    write-host "4) Confirm ownership of a domain (After adding the DNS records)"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "5) Set a custom domain as default"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
				    write-host ""

                    $domainOpt = Read-Host "Choose a number"
                    Clear-Host

                    if($domainOpt -eq "1"){
                        #add a custom domain
                        $domainName = Read-Host "Domain Name (Ex: contoso.com)"
                        New-MsolDomain -Name $domainName
                        }
                    elseif($domainOpt -eq "2"){
                         #Remove a domain
                         $domainName = Read-Host "Domain Name (Ex: contoso.com)"           
                         Remove-MsolDomain -DomainName $domainName -Force
                        }
                    elseif($domainOpt -eq "3"){
                        #Get DNS record value for domain verification
                        $domainName = Read-Host "Domain Name"
                        $recordType = Read-Host "Are you using a MX or TXT record for verification?"
                        Write-Host ""
                        write-host '   ----------------' -ForegroundColor green
                        Write-Host "1) MX Record"
                        write-host '   ----------------' -ForegroundColor green
                        Write-Host "2) TXT Record"
                        Write-Host '   ----------------' -ForegroundColor green
                        Write-Host ""
               
                        if($recordType -eq "1"){
                            $mx = Get-MsolDomainVerificationDns -DomainName $domainName -Mode DnsMXRecord
                            Write-Host ""
                            Write-Host "Add the following MX Record to your public DNS server"
                            Write-host ""
                            Write-Host "******" $mx "******"
                            }
                        elseif($recordType -eq "2"){
                            $txt = Get-MsolDomainVerificationDns -DomainName $domainName -Mode DnsTxtRecord
                            Write-Host ""
                            Write-Host "Add the following MX Record to your public DNS server"
                            Write-host ""
                            Write-Host "******" $txt "*****"
                            }
                        }
                    elseif($domainOpt -eq "4"){
                        #Confirm ownership of a domain after adding the DNS Record
                        $domainName = Read-Host "Domain Name"
                        Confirm-MsolDomain -DomainName $domainName                    
                        }
                    elseif($domainOpt -eq "5"){
                        #set a custom domain as default
                        $domainName = Read-Host "Domain Name"
                        Set-MsolDomain -Name $domainName -IsDefault $true		
			            }
                    }
			    elseif($opt -eq "4"){
                    
                    Clear-Host
                    Write-Host ""
                    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor DarkGreen
                    write-host ******************** License Management ******************** -ForegroundColor Green
                    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor Darkgreen
                    Write-Host ""
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "1) Add a license for a user"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "2) Remove a license from a user"
                    Write-Host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host ""
				
				    $LicenseOpt = Read-Host "Choose a number"
                    Clear-Host

                    if($LicenseOpt -eq "1"){
                        #assign a license to a user      
                        }
                    elseif($LicenseOpt -eq "2"){    
                        }
                    elseif($LicenseOpt -eq "3"){                   
                        }
                    elseif($LicenseOpt -eq "4"){    
                        }
                    elseif($LicenseOpt -eq "5"){     
                        }
                    elseif($LicenseOpt -eq "6"){  
                        }
                    elseif($LicenseOpt -eq "7"){  
                        }
			        }


			    elseif($opt -eq "5"){
                
                    Clear-Host
                    Write-Host ""
                    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor DarkGreen
                    write-host ********************* Role Management ********************** -ForegroundColor Green
                    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor Darkgreen
                    Write-Host ""
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "1) Add a user to a role"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "2) Get a list of available roles"
                    Write-Host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host "3) Get a list of members of roles"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    write-host "4) Remove a user from a role"
                    write-host '   --------------------------------------------------------------' -ForegroundColor green
                    Write-Host ""
				
				    $roleOpt = = Read-Host "Choose a number"
                    Clear-Host

                    if($roleOpt -eq "1"){
                        #Add a user to a role
					    #$role = 
                        }
                    elseif($roleOpt -eq "2"){
                        #
                        }
                    elseif($roleOpt -eq "3"){
                        #
                        }
                    elseif($roleOpt -eq "4"){
                        #
                        }
                    elseif($roleOpt -eq "5"){
                        #
                        }
                    elseif($roleOpt -eq "6"){
                        #
                        }
                    elseif($roleOpt -eq "7"){
                        #
                        }
			        }

		        elseif($opt -eq "6"){
                
                        Clear-Host
                        Write-Host ""
                        write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor DarkGreen
                        write-host ********************* Company Management ******************* -ForegroundColor Green
                        write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -ForegroundColor Darkgreen
                        Write-Host ""
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
                        Write-Host "1) "
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
                        Write-Host "2) "
                        Write-Host '   --------------------------------------------------------------' -ForegroundColor green
                        Write-Host "3) "
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
                        write-host "4) "
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
                        Write-Host "5) "
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
                        Write-Host "6) "
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
                        Write-Host "7) "
                        write-host '   --------------------------------------------------------------' -ForegroundColor green
				
				        $companyOpt = Read-Host "Choose a number"
                        Clear-Host

                        if($companyOpt -eq "1"){
                            #
                            }
                        elseif($companyOpt -eq "2"){
                            #
                            }
                        elseif($companyOpt -eq "3"){
                            #
                            }
                        elseif($companyOpt -eq "4"){
                            #
                            }
                        elseif($companyOpt -eq "5"){
                            #
                            }
                        elseif($companyOpt -eq "6"){
                            #
                            }
                        elseif($companyOpt -eq "7"){
                            #
                            }
			            }
            } 

        elseif($choice -eq "ExchangeOnline"){
            }
        }

    catch{
        [system.exception]
        Write-Host "Script has failed!"
        }
    }


    