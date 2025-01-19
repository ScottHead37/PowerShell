<#
    .SYNOPSIS
    Create a way to easily call a logging system to incorporate in all my scripts
    This is the template script that calls the logger module for use

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

\Logger.ps1