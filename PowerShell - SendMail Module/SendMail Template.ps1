<#
        .SYNOPSIS
        Example of how to call and use the SendMail function from the SendMail module in PS

        .DESCRIPTION
        Use this type of format to call the Module, execute your script, export your CSV 
        populate required fields, Send EMail with Attachement

        .INPUTS
        Inputs are to allow any Dynamic data be avaialbe without chaning the script
        This process is desinged so I can Digitally sign my scripts and not have someone change 
        Them when they change to MailTo, From, Subject etc...

        .OUTPUTS
        Outputs are to a CSV file called Get-ADuserInfo.csv in the same DIR as the script
        This value and full path to file is passed to the SendMail fucntion var $MailPath

        .LINK
        Online Website: https://www.scriptsbyscott.com/
    #>
# Module for Sending EMail with Attachement
Import-Module Sendmail  
$MailImport = Join-Path -Path $PSScriptRoot -ChildPath 'Mail.csv' # Dynamic Data that can be modified as needed 
$MailConf = Import-csv $MailImport # Construct to have log to same DIR as script path
$MailPath = Join-Path -Path $PSScriptRoot -ChildPath $($MailConf.Filename) # Setup Path for File to be Attached to reside in same DIR as Script 
# Call Mail Function and Assing Values from Mail.csv
SendMail -Emailto $MailConf.EmailTo -EmailFrom  $MailConf.EmailFrom -Subject $MailConf.Subject -Body $MailConf.Body -Filename $MailPath -SmtpServer $MailConf.SmtpServer
