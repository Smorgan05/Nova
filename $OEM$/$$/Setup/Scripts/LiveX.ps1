$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
#$ScriptDirPar = Split-Path (Split-Path $script:MyInvocation.MyCommand.Path) -Parent
$Host.UI.RawUI.WindowTitle = "Nova Live Install Controller"
# Coded By Morgan Overman for the Nova Project
# Live Install Script

# Change Directory and gather Automatical Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir\Run}
$AutomaticVariables = Get-Variable

# Load Variables
. .\GlobalVars.ps1

# Pass Variables to the Var file
if ($winver -gt "6.1"){Compare (gv) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables" | Format-Table -Auto | Out-File variables.txt -Width 10000}

# Run Speed Checker (use # to comment out)
#if (($Internet -eq "True") -and ($winver -notlike "6.0.*")){
#. .\SpeedTest.ps1}

cls
Write-Host ------------------- Nova Live Install $NovaVer -------------------
Write-Host --------------------------------------------------------------
Write-Host ------ Per Ardua Ad Astra, From Adversity to the Stars --------

# Server Install
if (($ServerMod -eq "True") -and (!(Test-Path $Startup\Starter.bat))){

# Run Server Workstation Prep
Write-Host
Write-Host Server Workstation Install
. .\Server.ps1; Server "ServerPrep"

# Change Location to the Start Up Folder
cd $Startup

# Create Starter
sc Starter.bat '@echo off' -en ASCII
ac starter.bat 'echo Starter for Nova Module Controller'
ac starter.bat $StartScript

# Load Tweaks script and Run Setup Module
Write-Host
Write-Host Windows Tweaks
cd $default\run; . .\Tweaks.ps1; Tweaks "Setup"

Restart-Computer -Force
exit}

# Nova Settings
if ($NovaMod -eq "True"){
Write-Host
Write-Host Nova Settings
. .\Nova.ps1
Write-Host}

# Privacy Settings
Write-Host Nova Privacy Settings
Start-Process PowerShell -ArgumentList $Privacy -Wait

# Load Tweaks script and Run Setup Method
if ($ServerMod -ne "True"){
Write-Host
Write-Host Windows Tweaks
. .\Tweaks.ps1; Tweaks "Setup"}

# Run Setup Updater if Internet is connected & greater than 15 mbps
if (($Internet -eq "True") -and ($winver -notlike "6.0.*")){
#if (($Internet -eq "True") -and ($Speed -ge "15") -and ($winver -notlike "6.0.*")){
write-host
write-host Setup Updater
. .\Setup_Updater.ps1}

# Load Apps script and Run Setup Method
Write-Host
Write-Host App Install Start
. .\Apps.ps1; Apps "Setup"; Apps "PostInstall"; Tweaks "PostInstall" 

# Run Server Script
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