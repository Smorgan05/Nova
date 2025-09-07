# Install Recognizer for Scanning of Apps Sub Folders
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Set Location
cd $Default

# Set Arrays for App Modules
if ($AppsModHandy -eq "True"){$HandyArray = ls Apps\Handy -name}
if ($AppsModUtil -eq "True"){$UtilArray = ls Apps\Utilities -name}

# Set Version Grab Function
function SetupVer($Setup){
((gi $Setup).VersionInfo).FileVersion}

# Get Version for Chrome
function ChromeVer($File){
$MetaDataObject = New-Object System.Object
$shell = New-Object -COMObject Shell.Application
$shellfolder = $shell.Namespace($PWD.Path)
$shellfile = $shellfolder.ParseName($File)
return $shellfolder.GetDetailsOf($shellfile, 24).split(" ")[0]}

# ===========================* Define Apps Variables *===============================
# ===================================================================================
# ==================================* Handy *========================================
if ($AppsModHandy -eq "True"){
cd $Default\Apps\Handy

# Setup Handy Hash Table

$Handy=@{}
$Handy["Classic"] = @{}
$Handy["Firefox"] = @{} 
$Handy["Chrome"] = @{}

	# Set Variables for Handy
	for($i=0; $i -le $HandyArray.length; $i++){
	if ($HandyArray[$i] -match 'ClassicShell'){ $Handy["Classic"]["Setup"] = $HandyArray[$i]; $Handy["Classic"]["Version"] = SetupVer $Handy.Classic.Setup; $Handy.Classic.Version = $Handy.Classic.Version.replace(", ",".")}
	if (($HandyArray[$i] -match 'Firefox') -and ($HandyArray[$i] -like '*win32*')){$Handy["Firefox"]["Setup32"] = $HandyArray[$i]; $Handy["Firefox"]["Version32"] = $Handy.Firefox.Setup32.Substring($Handy.Firefox.Setup32.IndexOf("-")+1,$Handy.Firefox.Setup32.IndexOf(".e")-8)}	
	if (($HandyArray[$i] -match 'Firefox') -and ($HandyArray[$i] -like '*win64*')){$Handy["Firefox"]["Setup64"] = $HandyArray[$i]; $Handy["Firefox"]["Version64"] = $Handy.Firefox.Setup64.Substring($Handy.Firefox.Setup64.IndexOf("-")+1,$Handy.Firefox.Setup64.IndexOf(".e")-8)}
	if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -notmatch '64')){$Handy["Chrome"]["Setup32"] = $HandyArray[$i]; $Handy["Chrome"]["Version32"] = ChromeVer $Handy.Chrome.Setup32}
	if (($HandyArray[$i] -match 'chrome') -and ($HandyArray[$i] -match '64')){$Handy["Chrome"]["Setup64"] = $HandyArray[$i]; $Handy["Chrome"]["Version64"] = ChromeVer $Handy.Chrome.Setup64}}

}
# ================================* Utilities *======================================
if ($AppsModUtil -eq "True"){
cd $Default\Apps\Utilities

# Setup Util Hash Table

$Util = @{};
$Util["CCleaner"] = @{}
$Util["Notepad"] = @{}
$Util["AutoRuns"] = @{}
$Util["ProcessExp"] = @{}
$Util["7zip"] = @{}
$Util["FileZ"] = @{}
$Util["Python"] = @{}
$Util["Qbit"] = @{}

	# Set Variables for Utilities
	for ($i=0; $i -le $UtilArray.length; $i++){
	if ($UtilArray[$i] -match 'cc'){$Util["CCleaner"]["Setup"] = $UtilArray[$i]; $Util["CCleaner"]["Version"] = SetupVer $Util.CCleaner.Setup}
	if ($UtilArray[$i] -match 'npp'){$Util["Notepad"]["Setup"] = $UtilArray[$i]; $Temp = $Util.Notepad.Setup.Substring(4);  $Util["Notepad"]["Version"] = $Temp.Substring(0,$Temp.IndexOf("I")-1)}
	if ($UtilArray[$i] -match 'Auto'){$Util["AutoRuns"]["Setup"] = $UtilArray[$i]; $Util["AutoRuns"]["Version"] = SetupVer $Util.AutoRuns.Setup}
	if ($UtilArray[$i] -match 'exp'){$Util["ProcessExp"]["Setup"] = $UtilArray[$i]; $Util["ProcessExp"]["Version"] = SetupVer $Util.ProcessExp.Setup}
	if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -notmatch 'x64')){$Util["7zip"]["Setup32"] = $UtilArray[$i]; $Util["7zip"]["Version32"] = SetupVer $Util["7zip"]["Setup32"]}
	if (($UtilArray[$i] -match '7z') -and ($UtilArray[$i] -match 'x64')){$Util["7zip"]["Setup64"] = $UtilArray[$i]; $Util["7zip"]["Version64"] = SetupVer $Util["7zip"]["Setup64"]}
	if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win32*')){$Util["FileZ"]["Setup32"] = $UtilArray[$i]; $Util["FileZ"]["Version32"] = SetupVer $Util.FileZ.Setup32}
	if (($UtilArray[$i] -match 'FileZilla') -and ($UtilArray[$i] -like '*win64*')){$Util["FileZ"]["Setup64"] = $UtilArray[$i]; $Util["FileZ"]["Version64"] = SetupVer $Util.FileZ.Setup64}
	if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -notmatch 'amd64')){$Util["Python"]["Setup32"] = $UtilArray[$i]; $Util["Python"]["Version32"] = SetupVer $Util.Python.Setup32}
	if (($UtilArray[$i] -match 'python') -and ($UtilArray[$i] -match 'amd64')){$Util["Python"]["Setup64"] = $UtilArray[$i]; $Util["Python"]["Version64"] = SetupVer $Util.Python.Setup64}
	if (($UtilArray[$i] -match 'qbit') -and ($UtilArray[$i] -notlike '*x64*')){$Util["Qbit"]["Setup32"] = $UtilArray[$i]; $Util["Qbit"]["Version32"] = $Util.Qbit.Setup32.Split("_")[1]}
	if (($UtilArray[$i] -match 'qbit') -and ($UtilArray[$i] -like '*x64*')){$Util["Qbit"]["Setup64"] = $UtilArray[$i]; $Util["Qbit"]["Version64"] = $Util.Qbit.Setup64.Split("_")[1]}}
}

# Return to original directory
cd $default\run