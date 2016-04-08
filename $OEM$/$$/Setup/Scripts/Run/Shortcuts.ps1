$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Shortcuts Pack

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\InstallRec.ps1

# Set Location
cd $default

# Desktop Clean up
# ========================

#Shortcut Creation Function
function Shortcuts {
Param ($TargetFile, $ShortcutFileLoco)
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFileLoco)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()}

# Remove all Shortcuts on desktop
Remove-Item $home\desktop\* -include *.lnk
rm $env:public\Desktop\* -include *.lnk

if ($AppsModUtil -eq "True"){
New-Item -ItemType directory -Path "$StartMenuUser\SysInternals" | out-null
Shortcuts "$env:homedrive\$AutoRuns" "$StartMenuUser\SysInternals\Autoruns.lnk"
Shortcuts "$env:homedrive\$ProcessExp" "$StartMenuUser\SysInternals\Process Explorer.lnk"}

# ========================

# Return to original directory
cd $default\run