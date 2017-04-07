param($profilePath = $profile.AllUsersCurrentHost)

Write-Host "Adding aliases to $profilePath" -ForegroundColor Green
if (!(test-path $profilePath)) {
    new-item -type file -path $profilePath -force
} Else {
    write-warning 'Profile already existed. Code added at the end.'

    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '### Added Aliases ###' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
}

$code = '
    set-alias g git
    set-alias .. Move-UpOneFolder
'
Add-Content -Value $code -Path $profilePath