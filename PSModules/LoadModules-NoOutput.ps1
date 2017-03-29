Write-Progress -Activity 'Loading PowerShell.Tools.PowerShell ...' -PercentComplete 50
Import-module (join-path $PSScriptRoot 'PowerShell\PowerShell.Tools.PowerShell.psm1') -DisableNameChecking -Force  -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module PowerShell.Tools.PowerShell -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Write-Progress -Activity 'Loading PowerShell.Tools.SQL ...' -PercentComplete 100
Import-module (join-path $PSScriptRoot 'SQL\PowerShell.Tools.SQL.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module PowerShell.Tools.SQL -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue