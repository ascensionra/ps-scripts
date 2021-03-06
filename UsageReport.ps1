#==================| Satnaam Waheguru Ji |===============================   
#              
#            Author  :  Aman Dhally    
#            E-Mail  :  amandhally@gmail.com    
#            website :  www.amandhally.net    
#            twitter :   @AmanDhally    
#            blog    : http://newdelhipowershellusergroup.blogspot.in/   
#            facebook: http://www.facebook.com/groups/254997707860848/    
#            Linkedin: http://www.linkedin.com/profile/view?id=23651495    
#    
#            Creation Date    : 03-June-2014 
#            File    :          Email Reporting on Office 365 mail Statictic 
#           
#            Version : 3    
#              
#   
#            My Pet Spider :          /^(o.o)^\     
#  
 
#------------------------------------------------------------------------------------------------------------  
 
 
function Send-O365MailStats { 
     
 
     
begin { 
    try { 
            Write-Output "$(get-date) : Script Start."
            
            Write-Output "$(get-date) : Asking for Office365 Administrative Credentials." 
            $UserCredential = Get-Credential 
            Write-Output "$(get-date) : Creating an Online PS Session with Office 365." 
            $ouSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection -ErrorAction 'Stop' -ErrorVariable 'ConnectionError' 
            Write-Output "$(get-date) : Importing PS Session." 
            Import-PSSession $ouSession -AllowClobber -ErrorAction 'Stop' -ErrorVariable 'SessionError'
        } 
     
    catch { 
            $ConnectionError 
            $SessionError 
        } 
    } 
process { 
    try { 

        #Setup path for output file
        #$file = 'd:\dropbox\venti\scripts\tmp\tmp.html'

        #Get SMTP server creds
        #$mailcred = Get-Credential

        #Your SMTP sever 
        $smtp = 'smtp.office365.com' 
        
        # To E-Mail Address
        $Emailto = 'jared@teamventi.com'
        
        # From E-Mail Address 
        $Emailfrom = 'jared@teamventi.com' 
        
        # Subject of the Email 
        $Subject = 'Office 365 MailBox Stats Report' 
        
        #Empty Array String 
        $body2 = @() 
        
        #Just a Counter 
        $int = 1 
        #$body2 += "<tr><td>" + $int + " Testing</td></tr>"
        
        #All Magic Done here
        Write-Output "$(get-date) : Running the Get-Mailbox and Get-MailboxStatistics cmdlet" 
        
        $userList = Get-Mailbox -Filter " RecipientType -eq 'UserMailbox'"   | Get-MailboxStatistics  | Sort-Object TotalItemSize -Descending
         
        #Processing 
        Write-Output "$(get-date) : Processing the Results." 
        foreach ( $user in $userList) 
                { 
                   #$user | fl * -Force 
                   $body2 += "<tr>" 
                   $body2 += "<td>" + $int++ + "</td>"  
                   $body2 += "<td>" + $user.DisplayName + "</td>" 
                    
                   #maniplating  
                   $UserTa= $user.TotalItemSize.value.ToString().split(" ")[0] 
                   $UserTb = $user.TotalItemSize.value.ToString().split(" ")[1]  
                   $userTotalSize =    $UserTa +  " " + $UserTb 
 
                   $body2 += "<td>" + $userTotalSize + "</td>" 
                    
                   $body2 += "<td>" + $user.LastLogonTime + "</td>" 
                   $body2 += "<td>" + $user.LastLogoffTime + "</td>" 
                   $body2 += "<td>" + $user.ServerName + "</td>" 
                   $body2 += "<td>" + $user.DatabaseName + "</td>" 
 
                   #Manuplating  
                   $userDDLa = $user.TotalDeletedItemSize.value.ToString().split(" ")[0] 
                   $userDDLb = $user.TotalDeletedItemSize.value.ToString().split(" ")[1] 
                   $userDelted =   $userDDLa + " " +   $userDDLb 
 
                   $body2 += "<td>" + $userDelted + "</td>" 
 
                   #Maniplated 
                   $userDBa = $user.DatabaseProhibitSendReceiveQuota.value.ToString().split(" ")[0] 
                   $userDBb = $user.DatabaseProhibitSendReceiveQuota.value.ToString().split(" ")[1] 
                   $userDBQuota = $userDBa + " " + $userDBb 
                    
                   $body2 += "<td>" + $userDBQuota + "</td>" 
 
                   #Maniplating 
                   $userWQa = $user.DatabaseIssueWarningQuota.value.ToString().split(" ")[0] 
                   $userWQb = $user.DatabaseIssueWarningQuota.value.ToString().split(" ")[1] 
                   $userWquota =  $userWQa + " " + $userWQb 
                    
                   $body2 += "<td>" + $userWquota+ "</td>" 
 
                   #Maniplating 
                   $UserDBPa = $user.DatabaseProhibitSendQuota.value.ToString().split(" ")[0] 
                   $UserDBPb = $user.DatabaseProhibitSendQuota.value.ToString().split(" ")[1] 
                   $userDBPS = $UserDBPa + " " + $UserDBPb 
 
                   $body2 += "<td>" + $userDBPS + "</td>" 
                   $body2 += "</tr>"
                } 
        
            <#
            $body = "<!DOCTYPE html>"
            $body += "<html><head><title>Mailbox Statistics</title></head>"
            $body += "<body>"
            #>
            
            $body = "<h3>Office 365 {Exchange Online}, User Mailbox Statics Report.</h3>" 
            $body += "<br>" 
            $body += "<br>" 
            $body += "<table border=2 style=background-color:silver;border-color:black >" 
            $body += "<tr>" 
            $body +=  "<th>S. No</th>" 
            $body +=  "<th>Display Name</th>" 
            $body +=  "<th>Total Mailbox Size </th>" 
            $body +=  "<th>Last LogonTime</th>" 
            $body +=  "<th>Last Logoff</th>" 
            $body +=  "<th>Server Name </th>" 
            $body +=  "<th>Database Name</th>" 
            $body +=  "<th>Deleted Item Size</th>" 
            $body +=  "<th>Prohibit S/R Quota</th>" 
            $body +=  "<th>Issue Warning Quota </th>" 
            $body +=  "<th>Prohibit Send Quota</th>" 
            $body += "</tr>" 
            $body += $body2 
            $body += "</table>"
            
            <#
            $body += "</body>"
            $body += "</html>" 
            #>

        #Sending Email Message to the $to 
        Write-Output "$(get-date) : Sending the Email."
         
        $SMTPServer = "smtp.office365.com" 
        $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
        $SMTPMEssage.To.Add($Emailto1)
        $SMTPMEssage.To.Add($Emailto2)
        $SMTPMessage.IsBodyHTML = $true
        $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
        $SMTPClient.EnableSsl = $true 
        $SMTPClient.Credentials = $mailcred
        $SMTPClient.Send($SMTPMessage)
        
        #Send-MailMessage -SmtpServer $smtp -To $to   -From $from -Subject $subject -Body $body  -BodyAsHtml -UseSsl -Credential $mailcred
             
        } 
    catch  
        { 
         
        } 
} 
end { 
         
    try { 
        #Remvoing the Session with Office 365 
        Write-Output "$(get-date) : Removing PS Session." 
        Remove-PSSession $ouSession  
        Write-Output "$(get-date) : Script End." 
        } 
    catch { 
        } 
    } 
} 
Send-O365MailStats 
 
# end of the script. 
