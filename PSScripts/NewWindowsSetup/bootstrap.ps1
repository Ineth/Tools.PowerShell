Set-ExecutionPolicy Bypass

#Install PowerShell Tools
. (Join-Path $PSscriptRoot './aliases.ps1')
. ('./../../PSModules/CreateProfileInISE.ps1')
. ('./../../PSModules/InstallModule.ps1')


# Install chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# System setup
choco install googlechrome -y
choco install 7zip.install -y
choco install notepadplusplus.install -y
choco install spotify -y
choco install f.lux -y

# Tools
choco install windirstat -y
choco install nmap -y
choco install rdcman -y
choco install cmder -y
choco install slack -y

# Dev Tools
choco install poshgit -y
choco install visualstudiocode -y
choco install sourcetree -y
choco install git.install -y
choco install ilspy -y
choco install git-credential-manager-for-windows -y

# Dev dependencies
choco install nodejs.install -y
choco install nunit.install -y
choco install mysql.workbench -y
choco install mysql-connector
choco install resharper-platform -y
choco install linqpad -y

