# Install Recognizer for Scanning of Apps Sub Folders
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Set Location
cd $Default

# Set Prep Array
$PrepArray = ls Prep -name

# Set Arrays for App Modules
if ($AppsModHandy -eq "True"){$HandyArray = ls Apps\Handy -name}
if ($AppsModUtil -eq "True"){$UtilArray = ls Apps\Utilities -name}
if ($AppsModWebPlugins -eq "True"){$WebPluginArray = ls Apps\WebPlugins -name}

# Set Version Grab Function
function SetupVer($Setup){
((gi $Setup).VersionInfo).ProductVersion}

# ===========================* Define Apps Variables *===============================
# ===================================================================================
# ==================================* Speed *========================================
cd $Default\Prep

$Prep=@{}
$Prep["Speed"] = @{}

for($i=0; $i -le $PrepArray.length; $i++){
if (($PrepArray[$i] -match "speedtest") -and ($PrepArray[$i] -like '*32*')){$Prep["Speed"]["Speed32"] = $PrepArray[$i]}
if (($PrepArray[$i] -match "speedtest") -and ($PrepArray[$i] -like '*64*')){$Prep["Speed"]["Speed64"] = $PrepArray[$i]}}

# ==================================* Handy *========================================
if ($AppsModHandy -eq "True"){
cd $Default\Apps\Handy

$Handy=@{}
$Handy["Classic"] = @{}
$Handy["Firefox"] = @{} 
$Handy["MPC"] = @{}
$Handy["Chrome"] = @{}

	# Set Variables for Handy
	for($i=0; $i -le $HandyArray.length; $i++){
	if ($HandyArray[$i] -match 'ClassicShell'){ $Handy["Classic"]["Setup"] = $HandyArray[$i]; $Handy["Classic"]["Version"] = SetupVer $Handy.Classic.Setup; $Handy.Classic.Version = $Handy.Classic.Version.replace(", ",".")}
	if (($HandyArray[$i] -match 'Firefox') -and ($HandyArray[$i] -like '*win32*')){$Handy["Firefox"]["Setup32"] = $HandyArray[$i]; $Handy["Firefox"]["Version32"] = $Handy.Firefox.Setup32 -match "[0-9][0-9].[0-9].[0-9]" -or $Handy.Firefox.Setup32 -match "[0-9][0-9].[0-9]"; $Handy["Firefox"]["Version32"] = $Matches[0]}	
	if (($HandyArray[$i] -match 'Firefox') -and ($HandyArray[$i] -like '*win64*')){$Handy["Firefox"]["Setup64"] = $HandyArray[$i]; $Handy["Firefox"]["Version64"] = $Handy.Firefox.Setup64 -match "[0-9][0-9].[0-9].[0-9]" -or $Handy.Firefox.Setup64 -match "[0-9][0-9].[0-9]"; $Handy["Firefox"]["Version64"] = $Matches[0]}
	if (($HandyArray[$i] -match 'MPC') -and ($HandyArray[$i] -like '*x86*')){$Handy["MPC"]["Setup32"] = $HandyArray[$i]; $Handy["MPC"]["Version32"] = SetupVer $Handy.MPC.Setup32}
	if (($HandyArray[$i] -match 'MPC') -and ($HandyArray[$i] -like '*x64*')){$Handy["MPC"]["Setup64"] = $HandyArray[$i]; $Handy["MPC"]["Version64"] = SetupVer $Handy.MPC.Setup64}
	if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -notmatch '64')){$Handy["Chrome"]["Setup32"] = $HandyArray[$i]; $Chrome32Ver = $Handy.Chrome.Setup32 | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9]*"}; $Handy["Chrome"]["Version32"] = $Matches[0]}
	if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -match '64')){$Handy["Chrome"]["Setup64"] = $HandyArray[$i]; $Chrome64Ver = $Handy.Chrome.Setup64 | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9]*"}; $Handy["Chrome"]["Version64"] = $Matches[0]}}

}
# ================================* Utilities *======================================
if ($AppsModUtil -eq "True"){
cd $Default\Apps\Utilities

$Util = @{};
$Util["CCleaner"] = @{}
$Util["Defraggler"] = @{}
$Util["Notepad"] = @{}
$Util["AutoRuns"] = @{}
$Util["ProcessExp"] = @{}
$Util["7zip"] = @{}
$Util["FileZ"] = @{}
$Util["Python"] = @{}

	# Set Variables for Utilities
	for ($i=0; $i -le $UtilArray.length; $i++){
	if ($UtilArray[$i] -match 'cc'){$Util["CCleaner"]["Setup"] = $UtilArray[$i]; $Util["CCleaner"]["Version"] = $Util.CCleaner.Setup -match "[0-9][0-9][0-9]"; $Util["CCleaner"]["Version"] = $Matches[0]}
	if ($UtilArray[$i] -match 'df'){$Util["Defraggler"]["Setup"] = $UtilArray[$i]; $Util["Defraggler"]["Version"] = $Util.Defraggler.Setup -match "[0-9][0-9][0-9]"; $Util["Defraggler"]["Version"] = $Matches[0]}
	if ($UtilArray[$i] -match 'npp'){$Util["Notepad"]["Setup"] = $UtilArray[$i]; $NotepadRevA = $Util.Notepad.Setup -match "[0-9].[0-9]"; $NotepadRevA = $Matches[0]; $NotepadRevB = $Util.Notepad.Setup -match "[0-9].[0-9].[0-9]"; $NotepadRevB = $Matches[0]; if ($NotepadRevA -gt $NotepadRevB){$Util["Notepad"]["Version"] = $NotepadRevA} else {$Util["Notepad"]["Version"] = $NotepadRevB} }
	if ($UtilArray[$i] -match 'Auto'){$Util["AutoRuns"]["Setup"] = $UtilArray[$i]; $Util["AutoRuns"]["Version"] = SetupVer $Util.AutoRuns.Setup}
	if ($UtilArray[$i] -match 'exp'){$Util["ProcessExp"]["Setup"] = $UtilArray[$i]; $Util["ProcessExp"]["Version"] = SetupVer $Util.ProcessExp.Setup}
	if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -notmatch 'x64')){$Util["7zip"]["Setup32"] = $UtilArray[$i]; $Util["7zip"]["Version32"] = SetupVer $Util["7zip"]["Setup32"]}
	if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -match 'x64')){$Util["7zip"]["Setup64"] = $UtilArray[$i]; $Util["7zip"]["Version64"] = SetupVer $Util["7zip"]["Setup64"]}
	if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win32*')){$Util["FileZ"]["Setup32"] = $UtilArray[$i]; $Util["FileZ"]["Version32"] = SetupVer $Util.FileZ.Setup32}
	if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win64*')){$Util["FileZ"]["Setup64"] = $UtilArray[$i]; $Util["FileZ"]["Version64"] = SetupVer $Util.FileZ.Setup64}
	if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -notmatch 'amd64')){$Util["Python"]["Setup32"] = $UtilArray[$i]; $Util["Python"]["Version32"] = SetupVer $Util.Python.Setup32}
	if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -match 'amd64')){$Util["Python"]["Setup64"] = $UtilArray[$i]; $Util["Python"]["Version64"] = SetupVer $Util.Python.Setup64}}

}
# ==============================* Web Plugins *======================================
if ($AppsModWebPlugins -eq "True"){
cd $Default\Apps\WebPlugins

$WebPlugins = @{}
$WebPlugins["Flash"] = @{}
$WebPlugins["Java"] = @{}

	# Set Variables for WebPlugins
	for ($i=0; $i -le $WebPluginArray.length; $i++){
	if ($WebPluginArray[$i] -match 'flash'){$WebPlugins["Flash"]["Setup"] = $WebPluginArray[$i]; $WebPlugins["Flash"]["Version"] = SetupVer $WebPlugins.Flash.Setup; $WebPlugins["Flash"]["Version"] = $WebPlugins["Flash"]["Version"].replace(",",".")}
	if (($WebPluginArray[$i] -match 'jre') -and ($WebPluginArray[$i] -match 'i586')){$WebPlugins["Java"]["Setup32"] = $WebPluginArray[$i]; $WebPlugins["Java"]["Version32"] = SetupVer $WebPlugins.Java.Setup32}
	if (($WebPluginArray[$i] -match 'jre') -and ($WebPluginArray[$i] -match 'x64')){$WebPlugins["Java"]["Setup64"] = $WebPluginArray[$i]; $WebPlugins["Java"]["Version64"] = SetupVer $WebPlugins.Java.Setup64}}

}
# ===================================================================================

# Return to original directory
cd $default\run