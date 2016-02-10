$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$Host.UI.RawUI.WindowTitle = "Nova Live Install 1.0"
# Live Install Script

# Create PowerShell Profile & Refresh Profile
cd $ScriptDir\Run
. .\Tweaks.ps1; Lang "PassVarSetup"; .$profile

# Load Variables
. .\InstallRec.ps1
compvar > variables.txt

Write-Host ----------------- Nova Live Install 1.0 ----------------
Write-Host

# Nova Settings
if ($NovaMod -eq "True"){
Write-Host Nova Settings
. .\Nova.ps1
Write-Host}

# Privacy Settings
Write-Host Nova Privacy Settings
Start-Process PowerShell -ArgumentList $Privacy -Wait

# Load Apps script and Run Setup Method
Write-Host
Write-Host App Install Start
. .\Apps.ps1; Apps "Setup"; Apps "PostInstall"

# Load Tweaks script and Run Setup Method
Write-Host
Write-Host Windows Tweaks
. .\Tweaks.ps1; Tweaks "Setup";  Tweaks "PostInstall" 

# Python Script Sample
if ($Python -eq "True"){
Write-Host
Write-Host Python Script Sample
Python Sample.py}

# Run Server Script and Module check
if (($ServerPrepMod -eq "True") -and ($ServerMod -eq "True")){
Write-Host
Write-Host Server Workstation Install
. .\Server.ps1; Server "ServerPrep"; Server "ServerConv"}

# Shortcuts
Write-Host
Write-Host Shortcuts
. .\Shortcuts.ps1

pause

# Clean up
Write-Host
Write-Host Cleanup
. .\Clean.ps1