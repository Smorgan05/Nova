$Host.UI.RawUI.WindowTitle = "Nova Module Controller 1.35"
# Nova Module Controller (REQUIRED)
# Coded By Morgan Overman for the Nova Project
# Multilingual Script Controller

# Check for Vmware Setup
Get-Process | Where-object { $_.Company -eq "Vmware, Inc." } -ea SilentlyContinue | Stop-Process

# Load Variables & Store in Txt
cd $env:windir\Setup\Scripts\Run
. .\GlobalVars.ps1
#cmpv > variables.txt 

# Check for Pending Install 
cd $default\Extrun;
. .\Get-PendingReboot.ps1
if ((Get-PendingReboot).RebootPending -eq "True"){Restart-Computer -Force}; cd $default\Run

Write-Host ----------------- Nova Module Controller 1.35 ----------------
Write-Host --------------------------------------------------------------
Write-Host ------ Per Ardua Ad Astra, From Adversity to the Stars --------
Write-Host
if ($NovaMod -eq "True"){
Write-Host Nova Settings
. .\Nova.ps1}
Write-Host
Write-Host Nova Privacy Settings
Start-Process PowerShell -ArgumentList $Privacy -Wait
Write-Host
Write-Host Install Windows Tweaks
. .\Tweaks.ps1; Tweaks "PostInstall"
Write-Host
if ($ServerMod -eq "True"){
Write-Host Server Workstation Install Start
. .\Server.ps1; Server "ServerConv"
Write-Host} 
Write-Host App Install Start
. .\Apps.ps1; Apps "PostInstall"
Write-Host
if ($Python -eq "True"){
Write-Host Python Script Sample
Python Sample.py
Write-Host}
Write-Host Shortcuts Start
. .\Shortcuts.ps1
Write-Host
Write-Host Cleanup
. .\Clean.ps1