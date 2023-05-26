<#
        .SYNOPSIS
        Creates local user account on remote systems

        .DESCRIPTION
        Used to create a local user account on remote systems with the same 
        user name and password. This can be for a auto logon account, backup 
        local admin account
        
        .INPUTS
        You need to update the script to meet your needs.
        Input script should be a list of your computers 
        and should reside in C:\temp on the system you 
        run the script.

        .OUTPUTS
        #Export WinRM Failures to txt
        $WinRMErrorVar | Out-File C:\temp\WinRMFailures.txt 
        
        #Export Ping Failures to txt 
        $Array_PingFailed | Out-File C:\temp\PingFailed.txt 
        
        #Sum on inaccessible systems are not getting processed 
        C:\Temp\SumOfSystemsNotProcessed.txt

        #Script Results Output
        C:\temp\ScriptOutput.csv

        #script Error Output
        C:\temp\FinalScriptErrors.txt

         .LINK
        Online Website: https://www.scriptsbyscott.com

    #>

#Get Computers from File
$ArrayofComputers = Get-Content C:\temp\Comp.txt

#Summary of Ping Failures
$Array_PingFailed = @()
#Summary of Systems Pass Ping and WinRM
$Array_Passed = @()
#Summary of errors when tryin to connect to online system via WinRM
$WinRMErrorVar = @() 

#Connection Testing
Foreach ($Computer in $ArrayofComputers) {
    $Checker = Test-Connection $Computer.Trim() -Count 1 -Quiet    
    If ($Checker) { $Array_Passed += Invoke-Command -ErrorVariable MyErr -ErrorAction SilentlyContinue -ComputerName $Computer.Trim() -ScriptBlock { $Env:COMPUTERNAME } }Else { $Array_PingFailed += $Computer.trim() }
    $WinRMErrorVar += $MyErr 
}

#Export WinRM Failures to txt
$WinRMErrorVar | Out-File C:\temp\WinRMFailures.txt 
#Export Ping Failures to txt 
$Array_PingFailed | Out-File C:\temp\PingFailed.txt 

#Sum on inaccessible systems are not getting processed 
Compare-Object -ReferenceObject $Array_Passed -DifferenceObject $ArrayofComputers | Select -ExpandProperty inputobject | Out-File C:\Temp\SumOfSystemsNotProcessed.txt

#Script Command to Create Account
$MyScript = {

    $MyPassword = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force 
    New-LocalUser -Name "BackupAdmin1" -Password $MyPassword -FullName "Scott Head" -Description "Backup Admin Account"
}

#Command that Creates Account and Export Results 
Invoke-Command -ErrorVariable My2ndErr -ErrorAction SilentlyContinue -ComputerName $Array_Passed -ScriptBlock $MyScript `
| Select FullName, Enabled, PasswordChangeableDate, PasswordExpires, UserMayChangePassword, PasswordLastSet, Name, SID | Export-csv C:\temp\ScriptOutput.csv -NoTypeInformation

if ($My2ndErr -ne $null) { $My2ndErr | Out-File C:\temp\FinalScriptErrors.txt }