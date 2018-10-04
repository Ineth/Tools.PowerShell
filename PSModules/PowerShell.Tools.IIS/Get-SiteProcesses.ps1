function Get-SiteProcesses {
    $processes = & c:\Windows\System32\inetsrv\appcmd.exe list wp
    $Processes | foreach { @{ Application = $_ } } | foreach { New-Object -TypeName PSObject -Property $_ }   
}