$Host.UI.RawUI.WindowTitle = "Nova Module Controller 1.30"
# Nova Module Controller (REQUIRED)
# Coded By Morgan Overman for the Nova Project
Start-Sleep -s 3
#
# Load Variables
cd $env:windir\Setup\Scripts\Run
. .\GlobalVars.ps1
#
Write-Host ----------------- Nova Module Controller 1.30 ----------------
Write-Host --------------------------------------------------------------
Write-Host ------ Per Ardua Ad Astra, From Adversity to the Stars --------
Write-Host
Write-Host Nova Settings
if ($NovaMod -eq "True"){
. .\Nova.ps1}
else {Write-Host Nova Module not Detected}
Write-Host
Write-Host Nova Privacy Settings
Start-Process PowerShell -ArgumentList $Privacy -Wait
Write-Host
Write-Host Install Windows Tweaks
. .\Tweaks.ps1; Tweaks "PostInstall"
Write-Host
if ($ServerMod -eq "True"){
Write-Host Server Workstation Install Start
. .\Server.ps1; Server "ServerConv"} 
else {Write-Host "Server OS not detected."}
Write-Host
Write-Host App Install Start
. .\Apps.ps1; Apps "PostInstall"
Write-Host
Write-Host Python Script Sample
Python Sample.py
Write-Host
Write-Host Shortcuts Start
. .\Shortcuts.ps1
Write-Host
Write-Host Cleanup
. .\Clean.ps1