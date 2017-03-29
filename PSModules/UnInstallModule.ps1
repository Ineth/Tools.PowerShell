#Remove Module Path
$ModulePaths = $env:PSModulePath -split ';'
$NewModulePaths = @()
foreach ($ModulePath in $ModulePaths){
    if (!($ModulePath.Contains('PowerShell.Tools'))){
        $NewModulePaths += $ModulePath
    }
}

$NewPSModulePath = ($NewModulePaths | select -Unique) -join ';'
[environment]::SetEnvironmentVariable('PSModulePath',  $NewPSModulePath, 'Machine')
$env:PSModulePath = $NewPSModulePath