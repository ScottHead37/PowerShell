<# 
    .SYNOPSIS
    Script to create new registry key.

    .DESCRIPTION    
    This checks for key path and then creates the key path if needed.
    This is used to create registry value on multiple remote systems.

    .EXAMPLE
    Fill in the values as shown below in the script to customize your registry key.   
    KeyPath1='HKLM:\HARDWARE\DESCRIPTION\System'  
    MyNewKeyName='MyNewKeyName'  
    MyNewKeytysValue='245'  
    MyKeyDataType='DWORD' 

    .NOTES
    !!!! You must use the prefix abbreviations as show below: !!!!
    Incorrect Syntax:    HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System
    Correct Syntax:      HKLM:\HARDWARE\DESCRIPTION\System  
    HKEY_LOCAL_MACHINE (HKLM)
    HKEY_CURRENT_CONFIG (HKCC)
    HKEY_CLASSES_ROOT (HKCR)
    HKEY_USERS (HKU)
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

#Object that is passed to remote systems
$MyObj = [PSCustomObject]@{
    KeyPath1         = 'HKLM:\HARDWARE\DESCRIPTION\System25'  
    MyNewKeyName     = 'MyNewKeyName'  
    MyNewKeytysValue = '245'  
    MyKeyDataType    = 'DWORD' 
}    

#Script that is excuted on remote systems
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

#Command that executes the MyScript section and can 
#easily be modified to run on many systems just change
#"Client" to a list of computer names stored in a variable.
Invoke-Command -ComputerName "Client" -ScriptBlock $MyScript -ArgumentList $MyObj