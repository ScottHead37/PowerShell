<#
        .SYNOPSIS
        Create a way to easily call a logging system to incorporate in all my scripts
        This is the logger custom PowerShell module that will be called by PS script 
        
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