param($profilePath = $profile.CurrentUserAllHosts)

Write-Host "Adding aliases to $profilePath" -ForegroundColor Green
if (!(Test-Path $profilePath)) {
    New-Item -type file -path $profilePath -force
    Add-Content -Value '### Added Aliases ###' -Path $profilePath
}
Else {
    Write-Warning 'Profile already existed. Code added at the end.'

    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '### Added Aliases ###' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
}

$code = '
set-alias g git
set-alias .. Move-UpOneFolder
set-alias gg Move-ToGitFolder

function start-powershell {
    start powershell
}
set-alias stp start-powershell
'
Add-Content -Value $code -Path $profilePath