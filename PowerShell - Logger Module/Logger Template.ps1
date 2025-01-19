<#
    .SYNOPSIS
    Create a way to easily call a logging system to incorporate in all my scripts
    This is the template script that calls the logger module for use
    Create Folder and Copy PSM1 file to C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Logger\

    .DESCRIPTION
    Logging is critical in seeing what happened and when.
    I have many scripts that run in scheduled tasks and I want to re-work them to have detailed logging and error trapping.
    This not only helps with reviewing results but can assist others that come after me see what has happened. 

    .INPUTS
    N/A

    .OUTPUTS
    I will desing outputs to be unique to each script writting to currnet directory as the script execution.
    I will also include that date-time stamp in the filename. 

    .LINK
    Online Website: https://www.scriptsbyscott.com/
#>
# Module for Logging
Import-Module Logger

# Construct to have log to same DIR as script path
# Example of a script run for logging to file 
$LogFile = Join-Path -Path $PSScriptRoot -ChildPath 'MyLog.Log'

try {
    # Import the ActiveDirectory module
    get-Service -ErrorAction Stop # Basic Test Command Executes
    LogMessage "Get-Service Command Executed"
} catch {    
    HandleError "Failed Get-Service. $_"
    exit
}

# Example of a script ERROR run for logging to file 
try {
    # Import the ActiveDirectory module
    Get-Service "RemoteRegistryX" -ErrorAction Stop # Basic Test Command Executes
    LogMessage "Get-Service Command Executed RemoteRegistryX"
} catch {    
    HandleError "Failed Get-Service RemoteRegistryX. $_"
    exit
}