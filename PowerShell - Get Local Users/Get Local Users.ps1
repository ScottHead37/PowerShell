<#  
	.SYNOPSIS
		Check List of Local Accounts on Systems 
	
	.DESCRIPTION
		Script queries AD for active computer objects and then checks for WinRM access.        
        If the WinRM access is successful then it pulls a list of local user accounts for each machine.
        This will then export results for validation of accounts. 
	
	.NOTES  
		Author: Scott Head

    .LINK 
        Https://Scriptsbyscott.com 				
#>

#Get List of Computers
$MyComputers=Get-ADComputer -filter * -Properties * | Where-Object{($_.Enabled -eq $True) -and ($_.Operatingsystem -like "Windows*")} | Select-Object -ExpandProperty Name 

#Instantiate Array
$MyArray=@()

#Check Access for Each Computers 
Foreach($Comp in $MyComputers){

    If((Invoke-Command -ErrorAction SilentlyContinue –ComputerName $comp –ScriptBlock {1}) –eq 1){
        $MyArray+=$Comp
    }
}
      
#Local Account Listing 
$MyCommand={
   # Get Local Users using WMI Call
   Get-WmiObject -Class Win32_UserAccount -Filter  {LocalAccount='True' and Disabled='False'} | Select-Object Caption

   # Opional Use of other Cmdlet
   # Get-LocalUser | Where-Object{$_.Enabled -eq $true}
    
}

#Excution of Local Account Lookup     
Invoke-Command $MyArray -ScriptBlock $MyCommand | Out-File C:\temp\Enabled_LocalAccounts.csv -Append         