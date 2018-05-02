function Test-SqlConnectionString($connectionString) {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = $connectionString

    # If no error occurs here, then connection was successful.
    Write-Host "Trying to connect..." -ForegroundColor Gray
    $conn.Open();
    $conn.Close();
    Write-Host "Connection success" -ForegroundColor Green
}
