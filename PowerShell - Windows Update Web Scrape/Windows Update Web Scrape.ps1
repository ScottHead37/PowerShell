#------------------------------- 2016 Server -----------------------------------
# Set Counters for Loop for Each Month of the Year
# Run after Patch Tuesday
$X=1
$MaxCounter=Get-Date -Format "MM"

Do{
    # Instnatiate Array
    $Lines=@()
    # Get Webpage Data
    (Invoke-WebRequest -Uri "https://www.catalog.update.microsoft.com/Search.aspx?q=2025-0$x Cumulative Update for Windows Server 2016 for x64-based Systems").Content | Out-File C:\temp\2016-$X.txt
    #Export Data Out to File
    $Lines= Get-Content C:\temp\2016-$X.txt  
    #Loop Through Each File to Get KB Output
    Foreach($Line in $Lines){

        If($Line -like "*(KB*"){$Line.Trim()}

    }
    #Incriment Counter
    $x=$X+1


}While($x -le $MaxCounter)

 
#------------------------------- 2019 Server -----------------------------------
$X=1

Do{
    # Instnatiate Array
    $Lines=@()
    # Get Webpage Data
    (Invoke-WebRequest -Uri "https://www.catalog.update.microsoft.com/Search.aspx?q=2025-0$x Cumulative Update for Windows Server 2019 for x64-based Systems").Content | Out-File C:\temp\2019-$X.txt
    #Export Data Out to File
    $Lines= Get-Content C:\temp\2019-$X.txt  
    #Loop Through Each File to Get KB Output
    Foreach($Line in $Lines){

        If($Line -like "*(KB*"){$Line.Trim()}

    }

    #Incriment Counter
    $x=$X+1

}While($x -le $MaxCounter)

#------------------------------- 2022 Server -----------------------------------
$X=1

Do{
    # Instnatiate Array
    $Lines=@()
    # Get Webpage Data
    (Invoke-WebRequest -Uri "https://www.catalog.update.microsoft.com/Search.aspx?q=2025-0$X Cumulative Update for Microsoft server operating system version 21H2 for x64-based Systems").Content | Out-File C:\temp\2022-$X.txt
    #Export Data Out to File
    $Lines= Get-Content C:\temp\2022-$X.txt  
    #Loop Through Each File to Get KB Output
    Foreach($Line in $Lines){

        If($Line -like "*(KB*"){$Line.Trim()}

    }

    #Incriment Counter
    $x=$X+1

}While($x -le $MaxCounter)