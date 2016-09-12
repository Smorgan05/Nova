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
Compare (gv) $AutomaticVariables -Property Name -PassThru | Where {$_.Name -ne "AutomaticVariables"} | Format-Table -Auto | Out-File variables.txt -Width 10000

cls
Write-Host ------------------- Nova Live Install $NovaVer -------------------
Write-Host --------------------------------------------------------------
Write-Host ------ Per Ardua Ad Astra, From Adversity to the Stars --------

# Take care of Windows 7 and Server Install
if ((($winver -like "6.1.*") -or ($ServerMod -eq "True")) -and (!(Test-Path $Startup\Starter.bat))){

	if ($ServerMod -eq "True"){
	# Run Server Workstation Prep
	Write-Host
	Write-Host Server Workstation Install
	. .\Server.ps1; Server "ServerPrep"}

# Change Location to the Start Up Folder
cd $Startup

# Create Starter
sc Starter.bat '@echo off' -en ASCII
ac starter.bat 'echo Starter for Nova Module Controller'
ac starter.bat $StartScript

	
	if (($winver -like "6.1.*") -and ($PSVer -eq "2.0")){
	# Live Install 7
	Write-Host
	Write-Host Windows 7 Install
	
	# Change to Prep Directory
	cd $default\prep

	# Install .net 4.5.2
	start-process "NDP461-KB3102436-x86-x64-AllOS-ENU.exe" -ArgumentList "/q /norestart" -wait
		
	if ($arc -eq "64-bit"){
	start-process wusa 'Windows6.1-KB2819745-x64-MultiPkg.msu /quiet /norestart' -wait } else {start-process wusa 'Windows6.1-KB2819745-x86-MultiPkg.msu /quiet /norestart' -wait}}

	
# Load Tweaks script and Run Setup Module
Write-Host
Write-Host Windows Tweaks
cd $default\run; . .\Tweaks.ps1; Tweaks "Setup"

# Force Restart
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
if (($ServerMod -ne "True") -or ($winver -notlike "6.1.*")){
Write-Host
Write-Host Windows Tweaks
. .\Tweaks.ps1; Tweaks "Setup"}

# Run Setup Updater if Internet is connected
if ($Internet -eq "True"){
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