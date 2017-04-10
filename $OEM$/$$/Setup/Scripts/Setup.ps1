$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Powershell Setup to install all Applications (REQUIRED)

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\InstallRec.ps1

# Change Location to the Start Up Folder
cd $Startup

# Write the starter to run at post install 
sc Starter.bat '@echo off' -en ASCII
ac starter.bat 'echo Starter for Nova Module Controller'
ac starter.bat 'Start PowerShell -NoLogo -NoExit -ExecutionPolicy Bypass -NoProfile -File C:\Windows\Setup\Scripts\Starter.ps1'

# Remove RunOnce
Remove-ItemProperty -Name 'Starter' -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Force

# Set for Script Execution
cd $default\Run

# Run Setup Updater if Internet is connected & greater than 15 mbps
if ($Internet -eq "True"){
. .\Setup_Updater.ps1}

# Run Server Script and Module check
if ($ServerMod -eq "True"){
. .\Server.ps1; Server "ServerPrep"}

# Load Apps Script and Run Setup Method
. .\Apps.ps1; Apps "Setup"

# Load Tweaks Script and Run Setup Method
. .\Tweaks.ps1; Tweaks "Setup"
exit