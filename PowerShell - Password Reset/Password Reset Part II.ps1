<# 
    Password Reset Process - Step 2
    Should have Sheet with 3 columns with headers consisting of:
    Computer	Account	    Password
#>

#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#     Import Preset Account Data for Changing Password          |||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
$ImportResetData=Import-CSV C:\temp\Sheet.csv

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#       Command Acutall Executed on Remote Systems       |||
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
$MyCommand={

    #Paramater for inbound Array
    Param($Item)

    $TimeStamp=Get-Date    
    
    #Reset Password
    Try {
      $account = [ADSI]("WinNT://$Env:ComputerName/$($Item.Account),user")
      $account.psbase.invoke("setpassword","$($Item.Password)")     
    }
    Catch {      
     Return "$Env:Computername | $($Item.Account) | --ERROR-- | $TimeStamp | $_"
    }
       

    #Test-Password Reset
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $obj = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine',$Env:Computername)
    $PasswordResetResult=$obj.ValidateCredentials($Item.Account,"$($Item.Password)") 
    
    #Return Results of Password Test
    If($PasswordResetResult){
        Return "$Env:Computername | $($Item.Account) | $($Item.Password) | $TimeStamp | Admin Password Reset Passed"
    }Else{
        Return "$Env:Computername | $($Item.Account)  | --ERROR-- | $TimeStamp | Admin Password Reset FAILED "
    }
}


#|||||||||||||||||||||||||||||||||||||||||||||||||||||||
#      Loops Through Array of Inputted Data from     |||
#      Excel and Passed Array Data to MyCommand      |||
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||
Foreach($Item in $ImportResetData){

    Invoke-Command $Item.Computer -ScriptBlock $MyCommand -ArgumentList @(,$Item) | Tee-Object C:\temp\Results.txt -Append
    
}





