<#  
    .Synopsis  
       Script to get snapshots from ESXI/vCenter hosts and add add to file.

    .DESCRIPTION  
	Designed to be ran in task scheduler to allow passing of credentials to vCenter login.
	The script will run the PowerCLI (if Installed) command to load PowerCLI core. 
	The script then connects to vCenter and gets a list of all snapshots and places in file.
	Finally the script append the file as an attachment and emails to whomever you choose. 
	
 
    .LINK
    Online Website: https://www.scriptsbyscott.com 
   	
    
    .NOTES
    Requirements:   
        VMware PowerCLI Module Installed on System
        Logon Account with Acess to vCenter  
        Output path to C:\Temp\    
        SMTP Server to Send To

#>   
     
    #\\----------------------------!!! Declare vCetner Server Name !!!--------------------------------\\
    $VCenterServer = "vCenter"
     
    #\\ Load Snap-in ---- PowerCLI Must be Installed ---------\\          
    & 'C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1'
    #Or Install-Module VMware.PowerCLI
    #Or Import-Module VMware.VimAutomation.Core
     
    #\\ Connect to the vCenter server ------ Domain Creds are Used for Auth------ \\
    Connect-VIServer $VCenterServer -ErrorAction Stop
     
    #----------Assuming PowerCLI is loaded and connected to vCenter -------------  
    $LogFile = "C:\Temp\Snapshot-" + "_$(get-date -format "yyyyMMdd_hhmmsstt").txt"

    $VMList=get-vm | where-Object {$_.PowerState -eq "PoweredOn"} | Get-VMGuest | where-Object {$_.OSFUllName -like "Microsoft Windows Server*"} | select -ExpandProperty VM 

    Foreach($VMItem in $VMList){
    get-snapshot $VMItem | select VM, created, name, description | Out-File $LogFile -Append
    }

    # ----- Configure Your Mail Variables -------
    $SMTPServer = "Mail_Server_Here"
    $SMTPFrom = "VMwareAdmin@YourDomain.com"
    $SMTPTo = "Email@YourDomain.com"
    $SMTPSubject = "Server Only Snapshots - " + (Get-Date -DisplayHint Date)
    $SMTPBody = "PowerCLI Review Snapshots in VMware"

    #Send Mail and Attach Custom Named Log File
    Send-MailMessage -SmtpServer $SMTPServer -From $SMTPFrom -To $SMTPTo -Subject $SMTPSubject -Body $SMTPBody -Attachments $LogFile

    #Disconnects from vCenter 
    DisConnect-VIServer $VCenterServer 	
    
    #Clear Variables
    Clear-Variable SMTPSubject
    Clear-Variable SMTPBody
    Clear-Variable SMTPTo
    Clear-Variable SMTPFrom
    Clear-Variable VMList
    Clear-Variable VMItem
    Clear-Variable LogFile        


        