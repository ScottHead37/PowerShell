<#
        .SYNOPSIS
        Examples of commands to set, create, remvoe, query Active Directory User

        .DESCRIPTION
        I wanted an example file for reference on Active Directory Module in PowerShell 
        Whenever possible dynamic data that may need to change will be imported from currnet DIR 
        The reason for this is the script is static, and we can sign the script, and it won’t change

        Scott Head | Jan 18, 2025

        .INPUTS
        Inputs from file designed to run from currnet DIR
        Input files are supplied 

        .OUTPUTS
        All outputs are clearly noted in script and will export to currnet DIR  
       
         .LINK
        Online Website: https://www.scriptsbyscott.com/adlibrary      
    #>

# Construct Pull from same DIR for use of $PSScriptRoot in VS Code Press F5 not > run button
$csvPath = Join-Path -Path $PSScriptRoot -ChildPath 'Dynamic_Users.csv'
$Dynamic = Import-csv -Path $csvPath

### Assing Mail Values ###
$EmailTo = $Dynamic.MailTo
$EmailFrom = $Dynamic.MailFrom 
$SMTPServer = $Dynamic.SMTP
$Subject = $Dynamic.MailSubject 
$Body = $Dynamic.MailBody

### Import list of users to Query From from same DIR as Script ###
$TXTPath = Join-Path -Path $PSScriptRoot -ChildPath 'Users.txt'
$Users = Get-Content $TXTPath

### Output File Path Same as Script DIR ###
$ExportPath = Join-Path -Path $PSScriptRoot -ChildPath 'ExportUserData.csv'

 ### Loop and Query Users, Format, Export ###
 ForEach($User in $Users){
    Get-ADuser -Properties * -f {SamAccountName -like $User} |`
    Select-Object @{name="Login ID";expression={$($_.Samaccountname)}},`
    @{name="First Name";expression={$($_.Givenname)}},`
    @{name="Last Name";expression={$($_.Surname)}},`
    @{name="Description";expression={$($_.Description)}},
    @{name="Job Title";expression={$($_.Title)}},
    @{name="Office";expression={$($_.Office)}},
    @{name="Department";expression={$($_.Department)}},
    @{name="Company";expression={$($_.Company)}},
    @{name="Current Manager";expression={$($_.Manager)}},
    @{name="Account Status";expression={$($_.Enabled)}} | Export-Csv $ExportPath -NoTypeInformation -Append
 }

### Special Note ! ###
#### Usually use local SMTP like a Ironport to forward without requiring inline credentials ###

#====================================
# Attach Files and Send Email 
#====================================
$filenameAndPath = $ExportPath
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
$SMTPMessage.Attachments.Add($attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("Scotthead37@gmail.com", "xxx xxx xxx xxx");  ### App Password is Required for Gmail Use ###
$SMTPClient.Send($SMTPMessage)
