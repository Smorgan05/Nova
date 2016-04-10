$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Install Recognizer for Scanning of Apps Sub Folders

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Set Location
cd $Default

# MS Array fix
if ((Get-ChildItem Apps\Microsoft).Count -eq "1"){echo $null >> Apps\Microsoft\temp}

# Set Arrays for App Modules
if ($AppsModHandy -eq "True"){$HandyArray = ls Apps\Handy -name}
if ($AppsModMS -eq "True"){$MSArray = dir Apps\Microsoft -name}
if ($AppsModUtil -eq "True"){$UtilArray = ls Apps\Utilities -name}
if ($AppsModWebPlugins -eq "True"){$WebPluginArray = ls Apps\WebPlugins -name}
if ($ExternalMod -eq "True"){$ExtModArray = ls ExtRun -name}

# Set Version Grab Function
function SetupVer($Setup){
((gi $Setup).VersionInfo).ProductVersion}

# ===========================* Define Apps Variables *===============================
# ===================================================================================
# ==================================* Speed *========================================
if ($ExternalMod -eq "True"){
cd ExtRun

for($i=0; $i -le $ExtModArray.length; $i++){
if (($ExtModArray[$i] -match "speedtest") -and ($ExtModArray[$i] -like '*32*')){$Speed32 = $ExtModArray[$i]}
if (($ExtModArray[$i] -match "speedtest") -and ($ExtModArray[$i] -like '*64*')){$Speed64 = $ExtModArray[$i]}}

}
# ==================================* Handy *========================================
if ($AppsModHandy -eq "True"){
cd $Default\Apps\Handy

# Set Variables for Handy
for($i=0; $i -le $HandyArray.length; $i++){
if ($HandyArray[$i] -match 'ClassicShell'){$Classic = $HandyArray[$i]; $ClassicVer = SetupVer "$Classic"}
if (($HandyArray[$i] -match 'Firefox') -and ($HandyArray[$i] -like '*win32*')){$Firefox32 = $HandyArray[$i]; $Firefox32Ver = $Firefox32 -match "[0-9][0-9].[0-9].[0-9]" -or $Firefox32 -match "[0-9][0-9].[0-9]"; $Firefox32Ver = $Matches.0}	
if (($HandyArray[$i] -match 'Firefox') -and ($HandyArray[$i] -like '*win64*')){$Firefox64 = $HandyArray[$i]; $Firefox64Ver = $Firefox64 -match "[0-9][0-9].[0-9].[0-9]" -or $Firefox64 -match "[0-9][0-9].[0-9]"; $Firefox64Ver = $Matches.0}
if (($HandyArray[$i] -match 'MPC') -and ($HandyArray[$i] -like '*x86*')){$MPC32 = $HandyArray[$i]; $MPC32Ver = SetupVer "$MPC32"}
if (($HandyArray[$i] -match 'MPC') -and ($HandyArray[$i] -like '*x64*')){$MPC64 = $HandyArray[$i]; $MPC64Ver = SetupVer "$MPC64"}
if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -notmatch '64')){$Chrome32 = $HandyArray[$i]; $Chrome32Ver = $Chrome32 | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9]*"}; $Chrome32Ver = $Matches.0}
if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -match '64')){$Chrome64 = $HandyArray[$i]; $Chrome64Ver = $Chrome64 | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9]*"}; $Chrome64Ver = $Matches.0}}

}
# ==================================* MS *===========================================
if ($AppsModMS -eq "True"){
cd $Default\Apps\Microsoft

# Set Variables for MS
for($i=0; $i -le $MSArray.length; $i++){
if ($MSArray[$i] -match 'dotNet'){$dotNet = $MSArray[$i]}}	

# Remove Temp File
if (Test-path temp){rm temp}

}
# ================================* Utilities *======================================
if ($AppsModUtil -eq "True"){
cd $Default\Apps\Utilities

# Set Variables for Utilities
for ($i=0; $i -le $UtilArray.length; $i++){
if ($UtilArray[$i] -match 'cc'){$CCleaner = $UtilArray[$i]; $CCleanerVer = $CCleaner -match "[0-9][0-9][0-9]"; $CCleanerVer = $Matches.0}
if ($UtilArray[$i] -match 'df'){$Defraggler = $UtilArray[$i]; $DefragglerVer = $Defraggler -match "[0-9][0-9][0-9]"; $DefragglerVer = $Matches.0}
if ($UtilArray[$i] -match 'npp'){$Notepad = $UtilArray[$i]; $NotepadVer = $Notepad -match "[0-9].[0-9].[0-9]"; $NotepadVer = $Matches.0}
if ($UtilArray[$i] -match 'Auto'){$AutoRuns = $UtilArray[$i]; $AutorunsVer = SetupVer "$AutoRuns"}
if ($UtilArray[$i] -match 'exp'){$ProcessExp = $UtilArray[$i]; $ProcessExpVer = SetupVer "$ProcessExp" }
if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -notmatch 'x64')){$7zip32 = $UtilArray[$i]; $7zip32Ver = SetupVer "$7zip32"}
if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -match 'x64')){$7zip64 = $UtilArray[$i]; $7zip64Ver = SetupVer "$7zip64"}
if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win32*')){$FileZ32 = $UtilArray[$i]; $FileZ32Ver = SetupVer "$FileZ32"}
if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win64*')){$FileZ64 = $UtilArray[$i]; $FileZ64Ver = SetupVer "$FileZ64"}
if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -notmatch 'amd64')){$Python32 = $UtilArray[$i]; $Python32Ver = SetupVer "$Python32"}
if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -match 'amd64')){$Python64 = $UtilArray[$i]; $Python64Ver = SetupVer "$Python64"}}

}
# ==============================* Web Plugins *======================================
if ($AppsModWebPlugins -eq "True"){
cd $Default\Apps\WebPlugins

# Set Variables for WebPlugins
for ($i=0; $i -le $WebPluginArray.length; $i++){
if ($WebPluginArray[$i] -match 'flash'){$Flash = $WebPluginArray[$i]; $FlashVer = SetupVer "$Flash"}
if (($WebPluginArray[$i] -match 'jre') -and ($WebPluginArray[$i] -match 'i586')){$Java32 = $WebPluginArray[$i]; $Java32Ver = SetupVer "$Java32"}
if (($WebPluginArray[$i] -match 'jre') -and ($WebPluginArray[$i] -match 'x64')){$Java64 = $WebPluginArray[$i]; $Java64Ver = SetupVer "$Java64"}}

}
# ===================================================================================

# Return to original directory
cd $default\run