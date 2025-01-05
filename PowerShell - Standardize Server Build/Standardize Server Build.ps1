<#
    .SYNOPSIS
            PowerShell Scriptto Setup Server Default Build Settings Best Practices
    .DESCRIPTION
            Reset Guest & Default Local Admin Password
            Renamed Local Admin Account to Company Standard
            Disabled Windows Firewall
            Starts Windows Service Remote Regstry
            Optional Setting, Change Service Startup Mode
    .AUTHOR
           Scott Head
           ScriptsbyScott.com
#>
#=====================================================
#======== Set Local Admin and Guest Account ==========
#=====================================================
$Admin_Password = Read-Host "Enter Local Admin Password"
$Guest_Password = Read-Host "Enter Guest Account Password"
$Admin_Password | Out-File C:\temp\CheckMe.txt

#Reset Local Admin Password
Try {
$account = [ADSI]("WinNT://$Env:ComputerName/Administrator,user")
$account.psbase.invoke("setpassword",$Admin_Password)
}
Catch {
    Return "$Env:Computername | Administrator | --ERROR-- | $TimeStamp | $_"
}

#Reset Local Guest Password
Try {
    $account = [ADSI]("WinNT://$Env:ComputerName/Guest,user")
    $account.psbase.invoke("setpassword",$Guest_Password)
}
Catch {
    Return "$Env:Computername | Guest | --ERROR-- | $TimeStamp | $_"
}

#=====================================================
#======== Test Local Admin and Guest Account =========
#=====================================================
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$obj = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine',$Env:Computername)
$AdminPasswordResetResult=$obj.ValidateCredentials("Administrator",$Admin_Password)

#--------------------------------------------
#Return Results of Password Test Local Admin
#--------------------------------------------
If($AdminPasswordResetResult){
    Return "$Env:Computername | Administrator | $Admin_Password | $TimeStamp | Admin Password Reset Passed ===================="
}Else{
    Return "$Env:Computername | Administrator | --ERROR-- | $TimeStamp | Admin Password Reset FAILED ==================== "
}

#=====================================================
#============= Rename Local Admin Account ============
#=====================================================
$CompName = "PrefixHere" + $Env:ComputerName
Rename-LocalUser "Administrator" $CompName
$Name_Checker=Get-LocalUser | Where-Object{$_.SID -like "S-1-5-21*-500*"} | Select-Object -ExpandProperty Name

#-------------------------------
#Test and Display Rename Results
#-------------------------------
If($Name_Checker -ne $CompName){Write-Host "Local Admin Name Mismatch ================"}Else{Write-Host " Local Admin Rename Complete =============="}

#=====================================================
#============= Disable Windows Firewall ==============
#=====================================================
Set-NetFirewallProfile -profile Domain,Public,Private -Enabled False
$Results=Get-NetFirewallProfile -profile Domain,Public,Private | Select-Object -ExpandProperty Enabled
Foreach($State in $Results){
    If($State -eq "False"){"Windows Firewall Profile Passed ================"}Else{" Windows Firewall Profile Failed =================="}
}

#============================================================
#============= Enabled Remote Registry Service ==============
#============================================================
Get-service remoteregistry | Start-Service
$Services=Get-service remoteregistry | Select-Object -ExpandProperty Status
If($Services -ne "Running"){Write-host "Windows Remote Registry Service Failed ================="}else{Write-Host "Windows Remote Registry Service Passed =================="}

<# Optional Change Startmode
$UpdateServiceName = "RemoteRegistry"           
$Mode1=Get-WmiObject -Class Win32_Service -Namespace root\cimv2 | Where-Object{$_.Name -eq $UpdateServiceName}
$Mode1.changestartmode("Automatic")
#>

Pause

Write-host `n `n "Move the File to File Share and Place in main Password File C:\Temp\CheckMe.txt" `n `n