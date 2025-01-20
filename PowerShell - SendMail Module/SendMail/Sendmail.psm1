<#
        .SYNOPSIS
        Create a way to easily call a mail function to have it the same on all scripts        
        Create Folder and Copy PSM1 file to C:\Windows\System32\WindowsPowerShell\v1.0\Modules\SendMail\

        .DESCRIPTION        
        Logic is to have all dynamic data (data that can change) come from a outside source
        This is so I can sign my script and it won't get modified when someone changes the mailto 
        If someone did that and I had the code inline I would have to digitally sign the script again 

        .INPUTS
        Inputs from Mail.csv with headers that match the SendMail module function that sends the email. 
        Anyone who uses this module can modify thier mailto, from, smtp etc and it won't change the Mod process
        
        Values to be passed to the Module Function SendMail 
        [string]$SmtpServer,
        [string]$EmailTo,
        [string]$EmailFrom,
        [string]$Subject,        
        [string]$Body,
        [string]$Filename

        .OUTPUTS        
        Outputs are just a email and attached file

        .LINK
        Online Website: https://www.scriptsbyscott.com/
    #>
 # Function to Semd Email message with Attachment
 function SendMail {
    param (
        [string]$SmtpServer,
        [string]$EmailTo,
        [string]$EmailFrom,
        [string]$Subject,        
        [string]$Body,
        [string]$Filename
    )
    #====================================
    # Attach Files and Send Email 
    #====================================
    $filenameAndPath = $Filename
    $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
    $attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
    $SMTPMessage.Attachments.Add($attachment)
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
    $SMTPClient.EnableSsl = $true 
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("Scotthead37@gmail.com", "xxxx xxxx xxxx xxxx");  ### App Password is Required for Gmail Use ###
    $SMTPClient.Send($SMTPMessage)
}
