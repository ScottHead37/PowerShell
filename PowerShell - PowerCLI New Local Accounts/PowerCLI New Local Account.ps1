# Install-Module -Name VMware.PowerCLI -Scope CurrentUser
# Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
# Website: https://www.scriptsbyscott.com/create-vm-host-account

# Import PowerCLI Module 
Import-Module VMware.PowerCLI
# ----- Name of ESXI Host -----
$VMHost="MyVMHostName"
# ----- Set Account Name ------
$Account="BuAdmin"
#----- Connect to ESXI Host ---
Connect-VIServer -Protocol https -Server $VMHost -User root -Password "YourPassword"

#Create User with Shell Access
Write-Host "Creating User For: $Account"
New-VMHostAccount -Id $Account -Password "YourNewAccountPassword" -GrantShellAccess

#Assign Administrator Permission
$RootFolder = Get-Folder -Name ha-folder-root
New-VIPermission -Entity $RootFolder -Principal $Account -Role Admin
Disconnect-VIServer  $VMHost -Confirm:$false    