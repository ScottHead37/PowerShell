<#  
    .Synopsis  
    Script searchs text file and makes two files one with odd endings and one with even endings.

    .DESCRIPTION  
	I was asked to make a list of each computer for patching and separate by odd and even named systems. 

    .LINK
    Online Website: https://www.scriptsbyscott.com/oddoreven   
#>   
# Get Computers from File
$Computers = Get-Content C:\temp\ODD-Even.txt
#Array of Even Numbers
$EvenArray=@(2,4,6,8,0)
#Array of Odd Numbers
$OddArray=@(1,3,5,7,9)
#---------- Da Loop ---------
Foreach($Comp in $Computers){
    #Get Length of Computer Name Minus 1
    $Length = $Comp.Length - 1
    #Acquire the Substring of the Computer Name
    $Substring =  $($Comp.Substring($Length))
    #Check to see if Substring, last digiat in Computer Name is Even
    if($EvenArray -Contains $Substring){$Comp | Tee-Object C:\temp\Even.txt -Append}
    #Check to See if Substring, Last Digist of COmputer Name is Odd
    if($OddArray -Contains $Substring){$Comp | Tee-Object C:\temp\Odd.txt -Append}
    #Check if Not End in Numeric 
    if(($OddArray -NotContains $Substring) -and ($EvenArray -NotContains $Substring)){
        #If Computer Does Not End with a Number
        $Comp | Tee-Object C:\temp\NotDigit.txt -Append
    }
}

