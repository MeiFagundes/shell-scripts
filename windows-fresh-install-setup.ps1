#Requires -RunAsAdministrator

# install scoop command-line installer
iwr -useb get.scoop.sh | iex;

# Add required buckets
scoop bucket add games;
scoop bucket add extras;
scoop bucket add java;

scoop update;
scoop install aria2; # Scoop uses aria2c for multi-connection downloads

# Default App installs
scoop install 7zip;
regedit /s $ENV:UserProfile\scoop\apps\7zip\current\install-context.reg;
scoop install deluge;
scoop install rufus;
scoop install teamviewer;
scoop install gimp;
scoop install discord
winget install --id=Microsoft.Teams -e -h --force; 
winget install --id=da2x.EdgeDeflector -e -h --force; 
winget install --id=MiniTool.PartitionWizard.Free -e -h --force; 
winget install --id=Parsec.Parsec -e -h --force; 
winget install --id=Stremio.Stremio -e -h --force; 

# Gaming Apps
scoop install retroarch;
scoop install pcsx2-dev;
scoop install dolphin-beta;
scoop install cpu-z;
scoop install gpu-z;
scoop install hwmonitor;
scoop install vortex;
winget install --id=Valve.Steam -e -h --force; 
winget install --id=EpicGames.EpicGamesLauncher -e -h --force; 
winget install --id=Ubisoft.Connect -e -h --force;

# Development Apps
scoop install git;
scoop install gitkraken
scoop install nodejs;
scoop install yarn;
scoop install openjdk;
scoop install openjdk8-redhat-jre;
scoop install android-studio;
scoop install vscode;
# Add Visual Studio Code as a context menu option:
regedit /s $ENV:UserProfile\scoop\apps\vscode\current\install-context.reg;

# ECHO Y | scoop install android-sdk;
# # reload system and user environment variables
# $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");
# sdkmanager --install "cmdline-tools;latest";
# cmd.exe /c  "$ENV:UserProfile\scoop\apps\android-sdk\current\tools\bin\sdkmanager.bat";

# ECHO Y | scoop install flutter;
# # accept all SDK package licenses
# , 'y' * 10  | flutter doctor --android-licenses;

winget install --id=UnityTechnologies.UnityHub -e -h --force; 

# Finalizing

# Creates a Symbolic Link for the apps folder on C:
New-Item -Path C:\Apps -ItemType SymbolicLink -Value $ENV:UserProfile\scoop\apps;

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');