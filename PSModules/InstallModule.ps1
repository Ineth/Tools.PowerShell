if (!($env:PSModulePath.ToString().Contains($PSScriptRoot))){
    [environment]::SetEnvironmentVariable('PSModulePath',  $env:PSModulePath + ';' + $PSScriptRoot, 'Machine')
    $env:PSModulePath = $env:PSModulePath + ';' + $PSScriptRoot
}

Write-host "Loading PowerShell.Tools.PowerShell..." -ForegroundColor Green
Import-module PowerShell.Tools.PowerShell -Force 
Write-host "Loading PowerShell.Tools.SQL..." -ForegroundColor Green
Import-module PowerShell.Tools.SQL -Force
