## Install module if not installed, this is a one time install.
Install-Module SqlServer

## Input Variables
$csvPath = "C:\PowerShell\Book1.csv"
$csvDelimiter = ";"
$serverName = "Blacky\SQLExpress"
$databaseName = "Test"
$tableSchema = "dbo"
$tableName = "Customer_Info"

$myCred = Get-Credential

## Import CSV into SQL
Import-Csv -Path $csvPath -Delimiter $csvDelimiter | Write-SqlTableData -ServerInstance $serverName -DatabaseName $databaseName -SchemaName $tableSchema -TableName $tableName -Force -Credential $myCred