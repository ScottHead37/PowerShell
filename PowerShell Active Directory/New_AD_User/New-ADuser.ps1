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

 # Function to log messages
function LogMessage {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"    
    Add-Content -Path $LogFile -Value "$timestamp - $Message"
}

# Function to handle errors
function HandleError {
    param (
        [string]$ErrorMessage
    )
    LogMessage "ERROR: $ErrorMessage"
    Write-Error $ErrorMessage
}

try {

    # Construct Pull from same DIR for use of $PSScriptRoot in VS Code Press F5 not > run button
    $csvPath = Join-Path -Path $PSScriptRoot -ChildPath 'Dynamic_NewADUser.csv'
    $Dynamic = Import-csv -Path $csvPath -ErrorAction Stop

    # Construct to have csv pulled from same DIR as script path
    $LogPath = Join-Path -Path $PSScriptRoot -ChildPath 'New_ADUser.Log'
    $LogFile = $LogPath   # Current DIR log file path

    ### Assing Mail Values ###
    $EmailTo = $Dynamic.MailTo
    $EmailFrom = $Dynamic.MailFrom 
    $SMTPServer = $Dynamic.SMTP
    $Subject = $Dynamic.MailSubject + " From Server: " + $Env:COMPUTERNAME
    $Body = $Dynamic.MailBody       
    LogMessage "CSV file imported and Values Assigned Dynamic_NewADUser.csv"
} catch {
    HandleError "Failed to import CSV file from  Dynamic_NewADUser.csv. $_"
    exit
}

try {
    # Import the ActiveDirectory module
    Import-Module ActiveDirectory -ErrorAction Stop
    LogMessage "Active Directory module imported successfully."
} catch {
    HandleError "Failed to import Active Directory module. $_"
    exit
}

try {
    # Construct to have csv pulled from same DIR as script path
    $csvPath = Join-Path -Path $PSScriptRoot -ChildPath 'NewUserInput.csv'
    $All = Import-csv -Path $csvPath -ErrorAction Stop
    LogMessage "CSV file imported successfully from $csvPath."
} catch {
    HandleError "Failed to import CSV file from $csvPath. $_"
    exit
}

# Process each item in the CSV
ForEach ($Item in $All) {
    try {
        # Create new AD user
        New-ADUser `
            -SamAccountName $Item.SamAccountName `
            -UserPrincipalName $Item.UserPrincipalName `
            -Name $Item.Name `
            -GivenName $Item.GivenName `
            -Surname $Item.Surname `
            -DisplayName $Item.DisplayName `
            -Department $Item.Department `
            -Title $Item.Title `
            -Office $Item.Office `
            -Company $Item.Company `
            -Description $Item.Description `
            -EmailAddress $Item.EmailAddress `
            -AccountPassword (ConvertTo-SecureString $Item.Password -AsPlainText -Force) `
            -Enabled $true `
            -Path $Item.OU `
            -ErrorAction Stop

        LogMessage "Successfully created user: $($Item.SamAccountName)"
    } catch {
        HandleError "Failed to create user: $($Item.SamAccountName). $_"
    }
}

LogMessage "Script completed."  


### Special Note ! ###
#### Usually use local SMTP like a Ironport to forward without requiring inline credentials ###

#====================================
# Attach Files and Send Email 
#====================================
$filenameAndPath = $LogFile
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
$SMTPMessage.Attachments.Add($attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("Scotthead37@gmail.com", "xxx xxx xxx xxx");  ### App Password is Required for Gmail Use ###
$SMTPClient.Send($SMTPMessage)
