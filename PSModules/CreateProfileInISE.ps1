param($profilePath = $profile)

Write-Host "Adding settings to $profilePath" -ForegroundColor Green
if (!(test-path $profilePath)) {
    new-item -type file -path $profilePath -force
} Else {
    write-warning 'Profile already existed. Code added at the end.'

    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
    Add-Content -Value '### Added PowerShell.Tools-part ###' -Path $profilePath
    Add-Content -Value '' -Path $profilePath
}


$code = '
# disabled for posh-git use
#function prompt{
#    $Currentlocation = (Get-Location).Path
#    if ($Currentlocation.Length -le 15) {
#        "$($Currentlocation)>>"
#    } else {
#        #$Currentlocation.Substring(0,3) + ".." + $Currentlocation.Substring($Currentlocation.lastIndexOf(''\''),$Currentlocation.Length - $Currentlocation.lastIndexOf(''\'')) + ">>"        
#        "$($Currentlocation)
#PS >"
#    }   
#}

if (-not($psise)) {
    break
} 

$code =
{

$file = $psise.CurrentPowerShellTab.Files.Add()

$Text = ''''
foreach($Item in (Get-History -Count $MaximumHistoryCount)){
    $Text += "$($item.CommandLine.TrimStart()) `n"
}

$file.Editor.Text = $Text
                                 
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add(''Copy History to new file'',$code,$null)

$code =
{
  Start-Steroids
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add(''Start ISE Steroids'',$code,$null)

$code =
{
  Start ''' + $PSScriptRoot + '''
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add(''Open CRS scripts folder'',$code,$null)

$loadPowerShellToolsCmdLetsCodeBlock =
{
  Import-module (Join-Path ''' + $PSScriptRoot + ''' ''LoadModules.ps1'') -Force  
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add(''Force import PowerShell Tools Modules'',$loadPowerShellToolsCmdLetsCodeBlock,$null)

'

Add-Content -Value $code -Path $profilePath

# psEdit $profilePath -ErrorAction SilentlyContinue
