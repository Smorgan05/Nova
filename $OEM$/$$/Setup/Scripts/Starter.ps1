$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$Host.UI.RawUI.WindowTitle = "Nova Module Controller 1.35"
$FormatEnumerationLimit = "-1"
# Nova Module Controller (REQUIRED)
# Coded By Morgan Overman for the Nova Project
# Multilingual Script Controller

# Check for Pending Install / Reboot then wait
if ($ExternalMod -eq "True"){cd $env:windir\Setup\Scripts\ExtRun} else {cd $ScriptDir\ExtRun}
. .\Get-PendingReboot.ps1
if ((Get-PendingReboot).RebootPending -eq "True"){Restart-Computer -Force}

# Create PowerShell Profile & Refresh Profile
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\Tweaks.ps1; Lang "PassVarSetup"; .$profile

# Load Variables & Store in Txt
. .\GlobalVars.ps1
compvar | Ft -autosize -wrap > variables.txt

Write-Host ----------------- Nova Module Controller 1.35 ----------------
Write-Host --------------------------------------------------------------
Write-Host ------ Per Ardua Ad Astra, From Adversity to the Stars --------
Write-Host
if ($NovaMod -eq "True"){
Write-Host Nova Settings
. .\Nova.ps1
Write-Host}
Write-Host Nova Privacy Settings
Start-Process PowerShell -ArgumentList $Privacy -Wait
Write-Host
Write-Host Windows Tweaks
. .\Tweaks.ps1; Tweaks "PostInstall"
Write-Host
if ($ServerMod -eq "True"){
Write-Host Server Workstation Install
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
pause
Write-Host
Write-Host Cleanup
. .\Clean.ps1