$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Powershell Setup to install all Applications (REQUIRED)

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\InstallRec.ps1

# Change Location to the Start Up Folder & Delete RunOnce
cd "$env:programdata\Microsoft\Windows\Start Menu\Programs\Startup"

# Write the starter to run at post install 
sc Starter.bat '@echo off' -en ASCII
ac starter.bat 'echo Starter for Nova Module Controller'
ac starter.bat 'Start PowerShell -NoLogo -NoExit -ExecutionPolicy Bypass -NoProfile -File C:\Windows\Setup\Scripts\Starter.ps1'

# Set for Dot net InstallRec
cd $default

# Windows 7 and Vista Specific
if (($AppsModMS -eq "True") -and (($winver -like "6.0.*") -or ($winver -like "6.1.*"))){
start-process "Apps\Microsoft\$dotNet" -ArgumentList "/q /norestart" -wait}

# Run Vista / Server 2008 Fix
if ($winver -like "6.0.*"){
PowerShell Remove-ItemProperty -Name 'Starter' -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Force
takeown /f "$env:windir\System32\runonce.exe"
icacls "$env:windir\System32\runonce.exe" /Grant Administrators:'(F)'
REN "$env:windir\System32\runonce.exe" "runonce.exe.dis"}

# Set for Script Execution
cd $default\Run

if ($Internet -eq "True"){
. .\Setup_Updater.ps1}

# Run Server Script and Module check
if ($ServerMod -eq "True"){
. .\Server.ps1; Server "ServerPrep"}

# Load Apps script and Run Setup Method
. .\Apps.ps1; Apps "Setup"

# Load Tweaks script and Run Setup Method
. .\Tweaks.ps1; Tweaks "Setup"
exit