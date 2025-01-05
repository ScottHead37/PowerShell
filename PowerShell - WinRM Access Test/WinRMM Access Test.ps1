# Requires the Active Directory Modle 
# Requires Export Folder C:\Temp
# Requires PowerShell version 3+
# Requires Windows Remote Management Running on Remote Systems
# Webiste - https://www.scriptsbyscott.com/check-connections

# Get list of enabled computers from Active Directory
$ComputerList= Get-Adcomputer -filter * | Where-Object{$_.Enabled -eq $True} | Select-Object -ExpandProperty Name

# Command to Check for Systems online that respond to WinRM
$ComputersConnected=Invoke-Command -ComputerName $ComputerList -ScriptBlock {$Env:COMPUTERNAME}

# Compare full list to see if any did not respond
$Tested=Compare-Object -ReferenceObject $ComputerList -DifferenceObject $ComputersConnected -IncludeEqual

# Filter to get systems that were accessible
$TestPassConn=$Tested |  Where-Object{$_.SideIndicator -eq "=="} | Select-Object -ExpandProperty InputObject

# Filter to get systems that are NOT accessible
$TestFailConn=$Tested |  Where-Object{$_.SideIndicator -eq "<="} | Select-Object -ExpandProperty InputObject

# Results Out to screen and file
Write-Host '--Failed--'
$TestFailConn | Tee-Object C:\temp\TestFailedRInRM.txt

# Results Out to screen and file
Write-Host '--Passed--'
$TestPassConn | Tee-Object C:\temp\TestPassWinRM.txt