#Requires -RunAsAdministrator

Write-Host "`n-----------------------------------------------------------------------------------------------" -ForegroundColor cyan
Write-Host "--------------------- Initializing Mei Windows Fresh Install Setup Script ---------------------" -ForegroundColor cyan
Write-Host "-----------------------------------------------------------------------------------------------`n" -ForegroundColor cyan

$shouldInstallBaseApps = (Read-Host "Do you want to install the base app selection? [y/N]") -eq 'y'
$shouldInstallDevelopmentApps = (Read-Host "Do you want to set up this machine for development? [y/N]") -eq 'y'
$shouldInstallGamingApps = (Read-Host "Do you want to set up this machine for gaming? [y/N]") -eq 'y'
$shouldInstallWorkApps = (Read-Host "Do you want to set up this machine for work? [y/N]") -eq 'y'
$shouldInstallFonts = (Read-Host "Do you want to install fonts? [y/N]") -eq 'y'
$shouldInstallAdminTools = (Read-Host "Do you want to install system admin tools? [y/N]") -eq 'y'

# Installing Git and reloading system and user environment variables
winget install --id=Git.Git -e -h
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Installing scoop command-line installer
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"

# Adding required buckets and updating scoop
scoop bucket add games
scoop bucket add extras
scoop bucket add java
scoop bucket add nerd-fonts
scoop update

# Base Installs
if ($shouldInstallBaseApps) {
    Write-Host "`n---------------------------------- Installing Base Apps -----------------------------------`n" -ForegroundColor cyan
    scoop install 7zip
    regedit /s $home\scoop\apps\7zip\current\install-context.reg # Adding 7-Zip as a context menu option
    scoop install discord
    scoop install deluge
    winget install --id=Parsec.Parsec -e -h
    winget install --id=Stremio.Stremio -e -h
    winget install --id=Ytmdesktop.Ytmdesktop -e -h
    winget install TeamViewer.TeamViewer
    Write-Output "`n- Installing all Visual C++ Redistributable runtime libraries`n"
    scoop install vcredist
    scoop uninstall vcredist2005 vcredist2008 vcredist2010 vcredist2012 vcredist2013 vcredist # Cleaning installers after installing VC++ Redistributable on the system
    Write-Host "`n- All Visual C++ Redistributable runtime libraries were installed successfully" -ForegroundColor green
}

# Development
if ($shouldInstallDevelopmentApps) {
    Write-Host "`n------------------------------- Installing Development Tools ------------------------------`n" -ForegroundColor cyan
    scoop install nodejs
    scoop install yarn
    scoop install openjdk
    scoop install openjdk8-redhat-jre
    scoop install android-studio
    winget install --id=Microsoft.VisualStudioCode -e -h
    winget install --id=Axosoft.GitKraken -e -h
    regedit /s $home\scoop\apps\vscode\current\install-context.reg # Adding Visual Studio Code as a context menu option
    winget install --id=UnityTechnologies.UnityHub -e -h
}

# Gaming
if ($shouldInstallGamingApps) {
    Write-Host "`n------------------------- Installing Game Launchers and Emulators -------------------------`n" -ForegroundColor cyan
    scoop install retroarch
    scoop install pcsx2-dev
    scoop install dolphin-beta
    scoop install cemu
    scoop install cemuhook
    winget install --id=Valve.Steam -e -h
    winget install --id=EpicGames.EpicGamesLauncher -e -h
    winget install --id=Ubisoft.Connect -e -h --force
    winget install --id=NexusMods.Vortex -e -h
}

# Work
if ($shouldInstallWorkApps) {
    Write-Host "`n----------------------------- Installing Work Apps and Tools ------------------------------`n" -ForegroundColor cyan
    winget install --id=Microsoft.Teams -e -h
    scoop install caffeine

    # Configuring Caffeine to start at login and keep the screen awake during active hours (9 AM - 7 PM)
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Caffeine.lnk")
    $Shortcut.TargetPath = "$home\scoop\apps\caffeine\current\caffeine64.exe"
    $Shortcut.Arguments = "-activehours:.........xxxxxxxxxx....."
    $Shortcut.Save()
    Write-Host "- Caffeine is now configured to automatically keep the screen awake during active hours (9 AM - 7 PM)" -ForegroundColor green
}

# Fonts
if ($shouldInstallFonts) {
    Write-Host "`n------------------------------------- Installing Fonts ------------------------------------`n" -ForegroundColor cyan
    scoop install sudo
    sudo scoop install -g Cascadia-Code
    sudo scoop install -g Open-Sans
    sudo scoop install -g Raleway
    sudo scoop install -g Ubuntu-NF
    sudo scoop install -g SourceCodePro-NF
    sudo scoop install -g SourceCodePro-NF-Mono
}

# System Admin Tools
if ($shouldInstallAdminTools) {
    Write-Host "`n------------------------------- Installing System Admin Tools -----------------------------`n" -ForegroundColor cyan
    scoop install winaero-tweaker
    scoop install rufus
    scoop install cru
    scoop install cpu-z
    scoop install gpu-z
    scoop install hwmonitor
}

# Creating a Symbolic Link of the scoop apps folder on C: drive root
New-Item -Path C:\Apps -ItemType SymbolicLink -Value $home\scoop\apps | Out-Null
Write-Host "`n- A shortcut for the apps folder is now created at 'C:\Apps'" -ForegroundColor green
Write-Output "nonportable apps were installed at the default location provided by each installer"

Write-Host "`n-----------------------------------------------------------------------------------------------" -ForegroundColor cyan
Write-Host "-------------------------------------- Setup Complete! ----------------------------------------" -ForegroundColor cyan
Write-Host "-----------------------------------------------------------------------------------------------`n" -ForegroundColor cyan