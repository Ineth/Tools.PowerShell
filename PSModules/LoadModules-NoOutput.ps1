Write-Progress -Activity 'Loading PowerShell.Tools.PowerShell ...' -PercentComplete 50
Import-module (join-path $PSScriptRoot 'PowerShell.Tools.PowerShell\PowerShell.Tools.PowerShell.psm1') -DisableNameChecking -Force  -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module PowerShell.Tools.PowerShell -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Write-Progress -Activity 'Loading PowerShell.Tools.SQL ...' -PercentComplete 100
Import-module (join-path $PSScriptRoot 'PowerShell.Tools.SQL\PowerShell.Tools.SQL.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module PowerShell.Tools.SQL -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Write-Progress -Activity 'Loading PowerShell.Tools.IIS ...' -PercentComplete 100
Import-module (join-path $PSScriptRoot 'PowerShell.Tools.IIS\PowerShell.Tools.IIS.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module PowerShell.Tools.SQL -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue