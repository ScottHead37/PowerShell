<#  
    .SYNOPSIS
    Simple Connect and Read SQL Data
    
    .DESCRIPTION
    Script connected to a SQL Instance and Executes a Query.
    Query is then displayed out to page. 
    
    .NOTES 
    Uses the SQL Authetication for accessing SQL Instance. I assume it works for domain or local user accounts.
#>

# Load the .NET assembly
Add-Type -AssemblyName 'System.Data'

# Define the connection string
$connectionString = 'Server=Blacky\SQLExpress;Database=Test; User Id=SA;Password=YourPassword;'

# Initialize the connection
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

# Open the connection
$connection.Open()


# Define the SQL query
$query = 'SELECT * FROM Customer_Info'

# Initialize the command
$command = $connection.CreateCommand()
$command.CommandText = $query

# Execute the command and load results
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
$dataSet = New-Object System.Data.DataSet
$adapter.Fill($dataSet)

# Display the results
$dataSet.Tables[0]

# Close the connection
$connection.Close()
