<# 
    .SYNOPSIS
    Script to create new registry key.

    .DESCRIPTION    
    This used to check for key path and then create the key path.
    invoke-command statment to create registry values on multiple remote systems.

    .EXAMPLE
    Fill in the values as shown below in the script to customize your registry key.   
    $KeyPath1="HKLM:\HARDWARE\DESCRIPTION\System"   
    $MyNewKeyName="MyNewKeyName"   
    $MyNewKeytysValue="245"   
    $MyKeyDataType="DWORD"

    .INPUTS
    Get data from source file with sysytems separated by carriage returns 
    Get-Content C:\temp\Comp.txt

    .OUTPUTS
    Logging files
    #Export WinRM Failures to txt
    $WinRMErrorVar | Out-File C:\temp\RegWinRMFailures.txt 
    #Export Ping Failures to txt 
    $Array_PingFailed | Out-File C:\temp\RegPingFailed.txt 
    C:\Temp\RegSumOfSystemsNotProcessed.txt
    C:\temp\RegFinalScriptErrors.txt

    .NOTES
    !!!! You must use the prefix abbreviations as show below: !!!!
    Incorrect Syntax:    HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System
    Correct Syntax:      HKLM:\HARDWARE\DESCRIPTION\System  
    HKEY_LOCAL_MACHINE (HKLM)
    HKEY_CURRENT_CONFIG (HKCC)
    HKEY_CLASSES_ROOT (HKCR)
    HKEY_USERS (HKU)
    HKEY_CURRENT_USER (HKCU)
    ! You must declare a valid data value type !
    BINARY
    DWORD
    STRING
    MULTISTRING
    EXPANDSTRING
    QWORD

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
$WinRMErrorVar | Out-File C:\temp\RegWinRMFailures.txt 
#Export Ping Failures to txt 
$Array_PingFailed | Out-File C:\temp\RegPingFailed.txt 

#Sum on inaccessible systems are not getting processed 
Compare-Object -ReferenceObject $Array_Passed -DifferenceObject $ArrayofComputers | Select -ExpandProperty inputobject | Out-File C:\Temp\RegSumOfSystemsNotProcessed.txt

#Object to be passed in array to comptuers
$MyObj = [PSCustomObject]@{
    KeyPath1         = 'HKLM:\HARDWARE\DESCRIPTION\SystemSS'  
    MyNewKeyName     = 'MyNewKeyName'  
    MyNewKeytysValue = '245'  
    MyKeyDataType    = 'DWORD' 
}    

#Script Executed on Remote Machines 
$MyScript = {
    
    Try { 
        #Makes sure the path is set before creation of reg key 
        if (Test-Path $Args.KeyPath1) { 
            New-ItemProperty -Path $Args.KeyPath1 -Name $Args.MyNewKeyName -Value $Args.MyNewKeytysValue -PropertyType $Args.MyKeyDataType -Force -ErrorAction Stop | Out-Null 
            return '$Env:COMPUTERNAME - $KeyPath1 path found and key created' 
        } 
        else { 
            New-Item -Path $Args.KeyPath1 -Force | Out-Null -ErrorAction Continue 
            New-ItemProperty -Path $Args.KeyPath1 -Name $Args.MyNewKeyName -Value $Args.MyNewKeytysValue -PropertyType $Args.MyKeyDataType -Force -ErrorAction Stop | Out-Null -ErrorAction Continue 
            return '$Env:COMPUTERNAME - $KeyPath1 path had to be created and key value was set' 
        } 
    } 
    Catch { 
        return $_.Exception 
    }
}

#Command to Exexute Scriptbock $MyScript 
Invoke-Command -ErrorVariable MyRegErr -ErrorAction SilentlyContinue -ComputerName $Array_Passed -ScriptBlock $MyScript -ArgumentList $MyObj

#Output Errors to TXT Files 
if ($MyRegErr -ne $null) { $My2ndErr | Out-File C:\temp\RegFinalScriptErrors.txt }