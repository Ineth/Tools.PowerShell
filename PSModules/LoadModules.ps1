write-host 'Loading PowerShell Tools...'

. (Join-Path $PSScriptRoot 'LoadModules-NoOutput.ps1')

Clear-host
write-host -ForegroundColor Yellow 'Get-Command -Module ''PowerShell.Tools.*'''
get-command -Module 'PowerShell.Tools.*'
