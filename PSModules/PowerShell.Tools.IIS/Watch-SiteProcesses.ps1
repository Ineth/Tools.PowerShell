function Watch-SiteProcesses($interval = 5) {
    while ($true) {
        clear
        $currentDate = (Get-Date).ToString()
        Write-Host "Status from: $currentDate"
        Get-SiteProcesses
        Start-Sleep -Seconds $interval
    }
}