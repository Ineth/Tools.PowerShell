
<# 
 .Synopsis
  Execute SQL command to a MySQL database.

 .Description
  Execute SQL Commands to a MySQL database providing a connection string or login and server info.

 .Parameter Query
  The query to execute.

 .Parameter ConnectionString
  The prefered connection string. When provided individual parameters (userName, ...) will be ignored>

 .Parameter UserName
 .Parameter Password
 .Parameter DatabaseName
 .Parameter Server
 .Parameter ServerPort
 The database port, default 3306

 .Example
   # Execute query using connection string.
   Invoke-MySql -ConnectionString "server=localhost;port=3306;uid=test;pwd=test;database=test" -Query "Select * from Test"

 .Example
   # Execute query using individual parameters (default port).
   Invoke-MySql -UserName test -Password "Test" -DatabaseName test -Server localhost -Query "Select * from Test"

 .Example
  # Execute query using individual parameters and custom port.
   Invoke-MySql -UserName test -Password "Test" -DatabaseName test -Server localhost -Port 6060 -Query "Select * from Test"
#>
function Invoke-MySql {

    Param(
      [Parameter(
      Mandatory = $true,
      ParameterSetName = '',
      ValueFromPipeline = $true)]
      [string] $Query,
      
      
      [string] $ConnectionString,
      [string] $UserName,
      [SecureString] $Password,
      [string] $DatabaseName,
      [string] $Server,
      [int] $ServerPort = 3306
      )

    if($ConnectionString -eq '') {
      $ConnectionString = "server=$Server;port=$ServerPort;uid=$UserName;pwd=$Password;database=$DatabaseName"        
    }

    Try {
      [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
      $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
      $Connection.ConnectionString = $ConnectionString
      $Connection.Open()

      $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
      $DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
      $DataSet = New-Object System.Data.DataSet
      $RecordCount = $dataAdapter.Fill($dataSet, "data")
      $DataSet.Tables[0]
      }

    Catch {
      Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
     }

    Finally {
      $Connection.Close()
  }
}