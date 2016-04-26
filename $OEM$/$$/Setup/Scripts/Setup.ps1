$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Powershell Setup to install all Applications (REQUIRED)

# Run Speed Checker (use # to comment out)
cd $env:windir\Setup\Scripts\ExtRun
#if (($Internet -eq "True") -and ($winver -notlike "6.0.*")){
#. .\SpeedTest.ps1}

# Load Variables
cd $env:windir\Setup\Scripts\Run
. .\InstallRec.ps1

# Change Location to the Start Up Folder
cd $Startup

# Write the starter to run at post install 
sc Starter.bat '@echo off' -en ASCII
ac starter.bat 'echo Starter for Nova Module Controller'
ac starter.bat 'Start PowerShell -NoLogo -NoExit -ExecutionPolicy Bypass -NoProfile -File C:\Windows\Setup\Scripts\Starter.ps1'

# Remove RunOnce
Remove-ItemProperty -Name 'Starter' -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Force

# Run Vista / Server 2008 Fix
if ($winver -like "6.0.*"){
takeown /f "$env:windir\System32\runonce.exe"
icacls "$env:windir\System32\runonce.exe" /Grant Administrators:'(F)'
REN "$env:windir\System32\runonce.exe" "runonce.exe.dis"}

# Set for Script Execution
cd $default\Run

# Run Setup Updater if Internet is connected & greater than 15 mbps
if (($Internet -eq "True") -and ($PSVer -ge "3.0")){
#if (($Internet -eq "True") -and ($PSVer -ge "3.0") -and ($Speed -ge "15")){
. .\Setup_Updater.ps1}

# Run Server Script and Module check
if ($ServerMod -eq "True"){
. .\Server.ps1; Server "ServerPrep"}

# Load Apps script and Run Setup Method
. .\Apps.ps1; Apps "Setup"

# Load Tweaks script and Run Setup Method
. .\Tweaks.ps1; Tweaks "Setup"
exit