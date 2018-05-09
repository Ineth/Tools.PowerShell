$projectPath = 'C:\\git\\X2B\\Xerius.Partner.Portaal\\Xerius.Partner.Portaal'
$vsPath = 'C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Enterprise\\Common7\\IDE\\devenv.exe'


code $projectPath
start powershell -WorkingDirectory $projectPath
. $vsPath "C:\git\X2B\Xerius.Partner.Portaal\Xerius.Partner.Portaal.sln" 

