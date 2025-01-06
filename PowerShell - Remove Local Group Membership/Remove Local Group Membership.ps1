<#  
	.SYNOPSIS
		Local Admin Account Review and Removal        
	
	.DESCRIPTION
		Script that lists local admins and allows for choice to remove a specific user from group. 
	
	.NOTES  
		Author: Scott Head

    .LINK 
        Https://Scriptsbyscott.com 				
#>
$Local_Admins=Get-LocalGroupMember Administrators | Select-Object Name
$X=0

cls

Foreach($Account in $Local_Admins){

    Write-Output "$X $($Account.name)"
    $X=$X+1

}

$User_Input = Read-Host "`n Enter Number to Remove From Group"
$Counter=$Local_Admins.count -1


try{
        if(($counter -ge 0) -and ($Counter -le $counter)){
            #Perform Task
          Remove-LocalGroupMember -Group Administrators -Member  $Local_Admins[$User_Input].name -ErrorAction Continue
          Write-Host "`nAccount Has Been Removed, See Below for New Group Membership Listing:"
          Get-LocalGroupMember Administrators | Select-Object Name
          Write-Host "`n Note:Account was removed from group not deleted from system."
            }
            Else{
                #"Post Error Mesage
                write-host "Invalid Selection Please Try Again"
            }
    }
catch{

    Write-Output "`n An error occurred: $($_.Exception.Message)"
    
}
