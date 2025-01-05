<#  
    .SYNOPSIS
    Use PowerShell to search servers services for SQL and IIS installs

    .DESCRIPTION
    Queries Active Directory for Enabled Windows Systems
    Tests Windows Remote Access
    Connects and searches services fro SQL and IIS 
    Cleans results and Exports data to file
    Attaches files and sends in email 

    .NOTES
    Requires rights on remote machines
    Requires Active Directory Module           
#>
#======================================================
# Query Active Directory for Enabled Windows Systems
#======================================================
$Computers=Get-ADComputer -properties * -Filter * | Where{($_.OperatingSystem -like "Windows*") -and ($_.Enabled -eq $True)} | Select -ExpandProperty Name 

# Upper Case System names
$MyCAPComputers=$Computers.ToUpper()

# Instantiate Array
$MyComputersPassWinRM=@()

#====================================================================
# Loop through systems and check for Widows remote managerment access
#====================================================================
Foreach ($Comp in $MyCAPComputers)
{
   if ((Test-Connection -ErrorAction SilentlyContinue –ComputerName $Comp –Quiet –Count 1) –and ((Invoke-Command -ErrorAction SilentlyContinue –ComputerName $comp –ScriptBlock { 1 }) –eq 1))
   {
       $MyComputersPassWinRM+=$Comp
   }
}
#======================================================================
# Set Up SQL Service Check Command and Execute as Job - Export to File 
#======================================================================
$SQL_Services={get-service | where{$_.Displayname -like "SQL Server (*"}}
$SQL_JobID=Invoke-Command $MyComputersPassWinRM -ScriptBlock $SQL_Services -AsJob -ThrottleLimit 50 
Receive-Job -id $SQL_JobID.ID -Wait | Export-CSV 'C:\temp\SQLInstall_X.csv' 

#======================================================================
# Set Up IIS Service Check Command and Execute as Job - Export to File 
#======================================================================
$IIS_Services={get-service | where{$_.name -eq "W3SVC"}}
$IIS_JobID=Invoke-Command $MyComputersPassWinRM -ScriptBlock $IIS_Services -AsJob -ThrottleLimit 50 
Receive-Job -id $IIS_JobID.ID -Wait | Export-CSV 'C:\temp\IISInstall_X.csv'

#=======================================
# Import / Export - Cleanup SQL Dataset
#=======================================
$MySQLOutputfile = Import-CSV 'C:\temp\SQLInstall_X.csv' | Select PSComputername, Name, Displayname, Status
$MySQLOutputfile | Export-CSV -NoTypeInformation 'C:\temp\SQLInstall_Cleaned.csv' 

#======================================
# Import / Export - Cleanup IIS Dataset
#======================================
$MyIISOutputfile = Import-CSV 'C:\temp\IISInstall_X.csv' | Select PSComputername, Name, Displayname, Status
$MyIISOutputfile | Export-CSV -NoTypeInformation 'C:\temp\IISInstall_Cleaned.csv'

#====================================
# Create Array for Attachments
#====================================
$Attach=@()
$Attach+='C:\temp\SQLInstall_Cleaned.csv' 
$Attach+='C:\temp\IISInstall_Cleaned.csv'

#====================================
# Attach Files and Send Email 
#====================================
$smtpServer =  "xxxxxxx.COM" 
$strFrom = "Scripts-IIS-SQL_Install@yourdomain.com"
$strTo = "xxxx@xxxx.com"
$StrCC="xxxx@xxxx.com"
$strSubject = “IIS - SQL Install"
$Body="See Attched Files listing IIS & SQL Instances"
Send-Mailmessage -SmtpServer $SmtpServer -from $strFrom -Attachments $Attach -to $strTo -Cc $StrCC  -Subject $strSubject -BodyasHTML $Body