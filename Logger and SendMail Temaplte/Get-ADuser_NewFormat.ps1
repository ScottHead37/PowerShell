<#
        .SYNOPSIS
        Features the SendMail Module and Logger Module from my GitHub Site

        .DESCRIPTION
        Whenever possible dynamic data that may need to change will be imported from Mail.csv
        The reason for this is if the script is static, and we can sign the script, and it won’t change
        Scott Head | Jan 18, 2025

        .INPUTS
        Mail.csv - File priovided with headers and settings 
        Logger Module from my Github
        SendMail Module from my Github 
        Required Active Directory Module for Active Directory Query 
        Requires valid SMTP server access for sending email
        
        .OUTPUTS
        Local DIR same as script per design for attaching file
        Logger appends the MyLog.log file to show script historical processes same DIR as script
       
         .LINK
        Online Website: https://www.scriptsbyscott.com/    
    #>
#====================================== Header for Setup of Logger and SendMail Functions from Modules =====================================================

Import-Module Logger
$LogFile = Join-Path -Path $PSScriptRoot -ChildPath 'MyLog.Log'
try{
    # Module for Sending EMail with Attachement
    Import-Module Sendmail  
    $MailImport = Join-Path -Path $PSScriptRoot -ChildPath 'Mail.csv' # Dynamic Data that can be modified as needed 
    $MailConf = Import-csv $MailImport # Construct to have same DIR as script path
    $MailPath = Join-Path -Path $PSScriptRoot -ChildPath $($MailConf.Filename) # Setup Path for File to be Attached to reside in same DIR as Script 
    LogMessage "Import SendMail Module,  Mail.csv File, Attachmetn Filepath"
}catch{
    HandleError "Failed to Load SendMail Module, Mail.csv Settings, Assing File Paths. $_"
    exit    
}

#============================================== Main Body of Script where tasks are performed and error handling ============================================

try {
    # Import the ActiveDirectory module
    Get-ADuser -Filter * | Export-csv $MailPath -NoTypeInformation -ErrorAction Stop
    LogMessage "Get-ADuser and Export to CSV File"
} catch {    
    HandleError "Failed to gather AD User Info and Export to CSV. $_"
    exit
}

#===================== Footer of the Script that Sends Email and Attachment using input from the Mail.csv file and SendMail Function\Module==================

try{
    # Call Mail Function and Assing Values from Mail.csv
    SendMail -Emailto $MailConf.EmailTo -EmailFrom  $MailConf.EmailFrom -Subject $MailConf.Subject -Body $MailConf.Body -Filename $MailPath -SmtpServer $MailConf.SmtpServer
    LogMessage "Send Email and Attach CSV File $($MailConf.Filename)"
}catch{
    HandleError "Failed to gather AD User Info and Export to CSV. $_"
    exit
}