<#  
    .SYNOPSIS
    Rename Multiple Files Extension
    
    .DESCRIPTION
    Get list of files by exteneion from folder
    Renames files with new extension you provide
    Works with file ext of any length .txt  .html .doc .docx .shtml etc...
    
    .OUTPUTS
    Logging of files that were changed.
    C:\temp\FilesChanged.txt   

    .NOTES 
    Backup data before making changes.
    I Changed my website from HTML to PHP and needed to change file extensions on all my files.
    Requires user to have correct permissions on the root folder and files.  
#>

Try {

    #============================================
    # Enter folder path and File Ext Typer
    #============================================
    write-host ""
    $MyFolderPath = Read-Host "Enter Folder Path"
    write-host ""
    $Ext = Read-Host "Enter File Extention like .txt"
    write-host ""
    $NewExt = Read-Host "Enter New File Extension like .php"

    #============================================
    # Get List of Files from Folder
    #============================================
    $Myfile = Get-ChildItem $MyFolderPath -ErrorAction Stop

    #============================================
    # Get List of Files only with Extension .html 
    #============================================
    $MyfileNew = @()
    $MyfileNew = $Myfile | Where { $_.Name -like "*$Ext" } -ErrorAction Stop

    #=======================================================
    # Displays list of files to be altered and Logs to File
    #=======================================================    
     Write-Output  "Files to be Chankged: `n"
    Get-Date | Out-File C:\temp\FilesChanged.txt -Append
    $MyfileNew.Name | Tee-Object C:\temp\FilesChanged.txt -Append
    Write-Output ""
    Pause

    #============================================
    # Loop Through All File Names 
    #============================================
    Foreach ($FileName in $MyfileNew.Name) {

        #=============================================================
        # Trim file removing Last 5 char (.html) and Appending .php
        #============================================================     
        $NewFileName = $FileName.Substring(0, $FileName.Length - $Ext.Length) + "$NewExt"

        #=================
        # Renames Files
        #=================    
        Rename-item "$MyFolderPath\$FileName" "$MyFolderPath\$NewFileName" -ErrorAction Stop
    }
}
Catch {

    Write-Output $_.Exception 

}