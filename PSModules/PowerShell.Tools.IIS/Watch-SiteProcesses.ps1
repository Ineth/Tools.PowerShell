function Watch-SiteProcesses {
    while ($true) {
        clear
        $currentDate = (Get-Date).ToString()
        Write-Host "Status from: $currentDate"
        Get-SiteProcesses
        Start-Sleep -Seconds 5
    }
}