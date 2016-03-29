$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
#$ScriptDirPar = Split-Path (Split-Path $script:MyInvocation.MyCommand.Path) -Parent
$Host.UI.RawUI.WindowTitle = "Nova Live Install Controller"
# Live Install Script

# Check for Pending Install / Reboot then wait
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\ExtRun} else {cd $ScriptDir\ExtRun}
. .\Get-PendingReboot.ps1
if ((Get-PendingReboot).RebootPending -eq "True"){Restart-Computer -Force}

# Create PowerShell Profile & Refresh Profile
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\Tweaks.ps1; Lang "PassVarSetup"; .$profile

# Load Variables & Store in Txt
. .\GlobalVars.ps1
compvar | Format-Table -Auto | Out-File variables.txt -Width 10000

Write-Host ----------------- Nova Live Install $NovaVer ---------------
Write-Host --------------------------------------------------------------
Write-Host ------ Per Ardua Ad Astra, From Adversity to the Stars --------

# Server Install

if (($ServerMod -eq "True") -and (!(Test-Path $Startup\Starter.bat))){
Write-Host
Write-Host Server Workstation Install
. .\Server.ps1; Server "ServerPrep"

# Change Location to the Start Up Folder
cd $Startup

# Create Starter
sc Starter.bat '@echo off' -en ASCII
ac starter.bat 'echo Starter for Nova Module Controller'
ac starter.bat 'Start PowerShell -NoLogo -NoExit -ExecutionPolicy Bypass -NoProfile -File $default\LiveX.ps1'

Restart-Computer -Force
exit}

# Nova Settings
if ($NovaMod -eq "True"){
Write-Host Nova Settings
. .\Nova.ps1
Write-Host}

# Privacy Settings
Write-Host Nova Privacy Settings
Start-Process PowerShell -ArgumentList $Privacy -Wait

# Load Tweaks script and Run Setup Method
Write-Host
Write-Host Windows Tweaks
. .\Tweaks.ps1; Tweaks "Setup";  Tweaks "PostInstall" 

# Run Setup Updater
if ($Internet -eq "True"){
start-transcript -path $env:userprofile\Setup_Update.log
. .\Setup_Updater.ps1
Stop-Transcript}

# Load Apps script and Run Setup Method
Write-Host
Write-Host App Install Start
. .\Apps.ps1; Apps "Setup"; Apps "PostInstall"

# Run Server Script and Module check
if ($ServerMod -eq "True"){
Write-Host
Write-Host Server Workstation Install
. .\Server.ps1; Server "ServerConv"}

# Python Script Sample
if ($Python -eq "True"){
Write-Host
Write-Host Python Script Sample
Python Sample.py}

# Shortcuts
Write-Host
Write-Host Shortcuts
. .\Shortcuts.ps1

# Clean up
Write-Host
Write-Host Cleanup
. .\Clean.ps1