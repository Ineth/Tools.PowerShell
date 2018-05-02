param($profilePath = $profile.CurrentUserAllHosts)

Write-Host "Adding Module load to $profilePath" -ForegroundColor Green
if (!(test-path $profilePath)) {
    new-item -type file -path $profilePath -force
    Add-Content -Value '### Auto-load modules ###' -Path $profilePath
} Else {
    write-warning 'Profile already existed. Code added at the end.'

    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '### Auto-load modules ###' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
}

$code = '
Import-Module PowerShell.Tools.SQL
Import-Module PowerShell.Tools.PowerShell
'
Add-Content -Value $code -Path $profilePath