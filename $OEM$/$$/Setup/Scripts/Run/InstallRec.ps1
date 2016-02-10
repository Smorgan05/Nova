$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Install Recognizer for Scanning of Apps Sub Folders

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Set Location
cd $Default

# Set Arrays for App Modules
if ($AppsModHandy -eq "True"){$HandyArray = ls Apps\Handy -name}
if ($AppsModMS -eq "True"){$MSArray = ls Apps\Microsoft -name}
if ($AppsModUtil -eq "True") {$UtilArray = ls Apps\Utilities -name}
if ($AppsModWebPlugins -eq "True") {$WebPluginArray = ls Apps\WebPlugins -name}

# ===========================* Define Apps Variables *===============================
# ===================================================================================
# ==================================* Handy *========================================
if ($AppsModHandy -eq "True"){

# Set Variables for Handy
for($i=0; $i -le $HandyArray.length; $i++){
if ($HandyArray[$i] -match 'Button'){$Buttons = $HandyArray[$i]}
if ($HandyArray[$i] -match 'ClassicShell'){$Classic = $HandyArray[$i]}
if (($HandyArray[$i] -match 'MPC') -and ($HandyArray[$i] -like '*x86*')){$MPC32 = $HandyArray[$i]}
if (($HandyArray[$i] -match 'MPC') -and ($HandyArray[$i] -like '*x64*')){$MPC64 = $HandyArray[$i]}
if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -notmatch '64')){$Chrome32 = $HandyArray[$i]}
if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -match '64')){$Chrome64 = $HandyArray[$i]}}

}
# ==================================* MS *===========================================
if ($AppsModMS -eq "True"){

# Set Variables for MS
for($i=0; $i -le $MSArray.length; $i++){
if ($MSArray[$i] -match 'dotNet'){$dotNet = $MSArray[$i]}}	

}
# ================================* Utilities *======================================
if ($AppsModUtil -eq "True"){

# Set Variables for Utilities
for ($i=0; $i -le $UtilArray.length; $i++){
if ($UtilArray[$i] -match 'cc'){$CCleaner = $UtilArray[$i]}
if ($UtilArray[$i] -match 'df'){$Defraggler = $UtilArray[$i]}
if ($UtilArray[$i] -match 'npp'){$Notepad = $UtilArray[$i]}
if ($UtilArray[$i] -match 'Auto'){$AutoRuns = $UtilArray[$i]}
if ($UtilArray[$i] -match 'exp'){$ProcessExp = $UtilArray[$i]}
if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -notmatch 'x64')){$7zip32 = $UtilArray[$i]}
if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -match 'x64')){$7zip64 = $UtilArray[$i]}
if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win32*')){$FileZ32 = $UtilArray[$i]}
if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win64*')){$FileZ64 = $UtilArray[$i]}
if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -notmatch 'amd64')){$Python32 = $UtilArray[$i]}
if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -match 'amd64')){$Python64 = $UtilArray[$i]}}

}
# ==============================* Web Plugins *======================================
if ($AppsModWebPlugins -eq "True"){

# Set Variables for WebPlugins
for ($i=0; $i -le $WebPluginArray.length; $i++){
if ($WebPluginArray[$i] -match 'flash'){$Flash = $WebPluginArray[$i]}
if (($WebPluginArray[$i] -match 'jre') -and ($WebPluginArray[$i] -match 'i586')){$Java32 = $WebPluginArray[$i]}
if (($WebPluginArray[$i] -match 'jre') -and ($WebPluginArray[$i] -match 'x64')){$Java64 = $WebPluginArray[$i]}}

}
# ===================================================================================

# Return to original directory
cd $default\run