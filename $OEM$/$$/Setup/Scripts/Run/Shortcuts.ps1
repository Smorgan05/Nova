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

# Remove Shortcuts command for Universal
Remove-Item $home\desktop\* -include *.lnk

# Remove all Shortcuts on desktop for Modern Operating Systems
if (($winver -like "6.*") -or ($winver -like "10.*")){
	Remove-Item $env:public\Desktop\* -include *.lnk}

# Remove all Shortcuts on desktop for Legacy Systems
if (($PSVer -eq "2.0") -and ($winver -like "5.*")){
	Remove-Item $env:allusersprofile\Desktop\* -include *.lnk}

if ($AppsModUtil -eq "True"){
	New-Item -ItemType directory -Path "$StartMenuUser\SysInternals" | out-null
	Shortcuts "$env:homedrive\$AutoRuns" "$StartMenuUser\SysInternals\Autoruns.lnk"
	Shortcuts "$env:homedrive\$ProcessExp" "$StartMenuUser\SysInternals\Process Explorer.lnk"}

# ========================

# Return to original directory
cd $default\run