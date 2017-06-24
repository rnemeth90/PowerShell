# New-PasswordReminder.ps1

###################################
# Get the max Password age from AD 
###################################

function Get-maxPwdAge{
   $root = [ADSI]"LDAP://sbdedcp02.ecimain.ecipay.com"
   $filter = "(&(objectcategory=domainDNS)(distinguishedName=DC=ecimain,DC=ecipay,DC=com))"
   $ds = New-Object system.DirectoryServices.DirectorySearcher($root,$filter)
   $dc = $ds.findone()
   [int64]$maxpwdage = [System.Math]::Abs( $dc.properties.item("maxPwdAge")[0])
   $maxpwdage/864000000000
}

###################################
# Search for Non-disabled AD users that have a Password Expiry.
###################################

$strFilter = "(&(objectCategory=User)(logonCount>=0)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(!(userAccountControl:1.2.840.113556.1.4.803:=65536)))"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$colResults = $objSearcher.FindAll();

# how many days before PW expiry do we start sending reminder emails?
$max_alert = 7


# Get the maximum password lifetime
$max_pwd_life=Get-maxPwdAge

$userlist = @()
foreach ($objResult in $colResults)
   {$objItem = $objResult.Properties; 
   if ( $objItem.mail.gettype.IsInstance -eq $True) 
      {      
         $user_name = $objItem.name
         $user_email = $objItem.email
         #Transform the DateTime readable format
         $user_logon = [datetime]::FromFileTime($objItem.lastlogon[0])
         $result = $objItem.pwdlastset 
         $user_pwd_last_set = [datetime]::FromFileTime($result[0])

         #calculate the difference in Day from last time a password was set
         $diff_date = [INT]([DateTime]::Now - $user_pwd_last_set).TotalDays;

   $Subtracted = $max_pwd_life - $diff_date
         if (($Subtracted) -le $max_alert) {
            $selected_user = New-Object psobject
            #$selected_user | Add-Member NoteProperty -Name "Name" -Value $objItem.name[0]
            $selected_user | Add-Member NoteProperty -Name "Name" -Value $objItem.Item("displayname")
            $selected_user | Add-Member NoteProperty -Name "Email" -Value $objItem.mail[0]
            $selected_user | Add-Member NoteProperty -Name "LastLogon" -Value $user_logon
            $selected_user | Add-Member NoteProperty -Name "LastPwdSet" -Value $user_pwd_last_set
            $selected_user | Add-Member NoteProperty -Name "RemainingDays" -Value ($Subtracted)
            $userlist+=$selected_user
         }
      }
   }

###################################
# Function to send HTML email to each user
###################################

function send_email ($days_remaining, $email, $name ) 
{
 $today = Get-Date
 $today = $today.ToString("dddd (yyy-MMMM-dd)")
 $date_expire = [DateTime]::Now.AddDays($days_remaining);
 $date_expire = $date_expire.ToString("dddd (yyy-MMMM-dd)")
 $SmtpClient = new-object system.net.mail.smtpClient 
 $mailmessage = New-Object system.net.mail.mailmessage 
 $SmtpClient.Host = "SMTP01.ecipay.com" 
 $mailmessage.from = "ECI Password Alert <PasswordAlert@ecipay.com>" 
 $mailmessage.To.add($email)
 $mailmessage.Subject = "$name, Your password will expire soon."
 $mailmessage.IsBodyHtml = $true

 $mailmessage.Body = @"
<h5><font face=Arial>$name, </font></h5>
<h5><font face=Arial>Your password will expire in <font color=red><strong>$days_remaining</strong></font> days
 on <strong>$date_expire</strong><br />
 </font></h5>
 <p>Your Active Directory (AD) password is required for Computer Login, remote VPN, and Email Access. To prevent work interruption, please change your password BEFORE it expires.</p>

 <p>Remote employees MUST connect to the VPN before changing their passwords.</p>
 


<p>Update passwords in 3<sup>rd</sup> party applications (Jabber, Mobile devices)</p>


<p>For your password to be valid it must be 8 or more characters long and contain
<br />a number & uppercase letter.
 Valid characters are:<br /> <br /> uppercase letters (A-Z)<br /> lowercase letters (a-z)<br /> numbers (0-9)<br /> symbols (!"&pound;$%^&amp;*)</p>
<p>If you have any questions, please open a Samanage ticket. https://techsupport.ecipay.com</p>
<p>Thanks,</p>
<p>The ECI IT Department</p>
"@

 $smtpclient.Send($mailmessage) 
}


###################################
# Send email to each user
###################################
   foreach ($userItem in $userlist )
   {
    if ($userItem.RemainingDays -ge 0) {
      ####################################################################
      #Un-comment the line below to send emails to the affected users
      ####################################################################
      
      send_email $userItem.RemainingDays $userItem.Email $userItem.Name
      #send_email $userItem.RemainingDays rduclos@ecipay.com $userItem.Name
      #send_email $userItem.RemainingDays amassing@ecipay.com $userItem.Name
      
      ####################################################################
      #Un-comment the line below to send emails to a test user/users
      ####################################################################
      
       #send_email $userItem.RemainingDays amassing@ecipay.com $userItem.Name
      
       }
   }

# END

