<# 
Password Reset Process 
Step 1 Gather Computer Info and Test Access

Take this script output and create Excel sheet with new passwords
Should have Sheet with 3 columns with headers consisting of:
Computer	Account	    Password
#>

# Query AD and Output to File
$Computers=Get-ADComputer -properties * -Filter * | Where-object{($_.OperatingSystem -like "Windows*") -and ($_.Enabled -eq $True) -and ($_.CanonicalName -notlike "*Domain Controllers*") } | Select-Object -ExpandProperty Name | tee-object C:\temp\Org_Computers.txt
$MyCAPComputers=$Computers.ToUpper()

#Test WINRM Access on all Enabled AD Systems in Scope 
$MyComputersPassWinRM=@()
Foreach ($Comp in $MyCAPComputers)
{
	if ((Test-Connection -ErrorAction SilentlyContinue –ComputerName $Comp –Quiet –Count 1) –and ((Invoke-Command -ErrorAction SilentlyContinue –ComputerName $comp –ScriptBlock { 1 }) –eq 1))
	{
		$MyComputersPassWinRM+=$Comp
	}
}

#Compare Originl AD List and WINRM Pass List
$MyComputersFiledWinRM=Compare-Object -ReferenceObject $MyCapComputers -DifferenceObject $MyComputersPassWinRM  | Select-Object -ExpandProperty inputobject -ErrorAction Stop

#Output Results of Server Checks Out to File
$MyComputersPassWinRM | Out-File C:\temp\PassWinRM.txt
$MyComputersFiledWinRM | Out-File C:\temp\FailedWinRM.txt
