# Global Variables for Scripts

# General Script Variables
$edition = (gwmi Win32_OperatingSystem).Caption
$winver = (gwmi win32_OperatingSystem).Version
$arc = (gwmi win32_OperatingSystem).OSArchitecture
$PSVer = $PSVersionTable.PSVersion.Major
$VidRez = (gwmi win32_videocontroller).CurrentHorizontalResolution
$Temp = $env:temp

# Set Master script directory
if (Test-path "$env:windir\Setup\Scripts"){
$default = "$env:windir\Setup\Scripts"} else {$default = Split-Path (Split-Path $script:MyInvocation.MyCommand.Path) -Parent}

# Set Master Version
$NovaVer = "13.0"

# Set Startup Folder Variable
$Startup = "$env:programdata\Microsoft\Windows\Start Menu\Programs\Startup"
$StartScript = 'Start PowerShell -NoLogo -NoExit -ExecutionPolicy Bypass -NoProfile -File "' + $default + '\LiveX.ps1"'

# Multi-use Variables
$s_big = "/S"
$q = "/q"
$silent = "/silent"
$s_small = "-s"

# Set Variables for Scripts that will create a new instance of PS
$Privacy = "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File Privacy.ps1"

# Shortcut Variables
$StartMenuUser = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

# One Use variables
$Classy = "/qn ADDLOCAL=ClassicStartMenu"
$PythonInst = "/passive InstallAllUsers=1 PrependPath=1"
$Program86 = ${Env:ProgramFiles(x86)}

# Enviromental Variables (Permenant - System / User)
$SystemVar = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
$UserVar = "HKCU:\Environment"

# Privacy Variables (Privacy.ps1)
$WinTasks = "$env:windir\System32\Tasks\Microsoft\Windows"
$OffTasks = "$env:windir\System32\Tasks\Microsoft\Office"
$Diagnostics = "$env:systemdrive\ProgramData\Microsoft\Diagnosis"
$ShutLogger = "ETLLogs\ShutdownLogger\AutoLogger-Diagtrack-Listener.etl" 
$AutoLogger = "ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
$RegRoute = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes"
$DiagTrack = (gsv "DiagTrack" -ea SilentlyContinue)
$Dmwappush = (gsv "dmwappushservice" -ea SilentlyContinue)
 
# Nova Variables
$OEMkey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
$ThemesServ = (Get-WmiObject -Class Win32_Service -Filter "Name='Themes'").State

# Set Directory for Module Variable settings
cd $default

# ============================================================================================================================================================================
#																	 	OEM Pack Internet Check
# ============================================================================================================================================================================

$Connection = (get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" | select netconnectionid, name, InterfaceIndex, netconnectionstatus).netconnectionstatus

If ($Connection -eq "2"){ 
	$Internet = "True"} Else {$Internet = "False"}
	
# ============================================================================================================================================================================
#																	 Set External Language Variables
# ============================================================================================================================================================================

# Set Correct Python path 

if ($arc -eq "64-bit"){
$PythonPath = (ls $env:ProgramFiles | Where-Object { $_ -match "Python"}).FullName} else {$PythonPath = (ls $Program86 | Where-Object { $_ -match "Python"}).FullName}

# Set Python check variable
if (($PythonPath -ne $Null) -and (Test-Path $PythonPath)){
$Python = "True"} else {$Python = "False"}

# ============================================================================================================================================================================
#																		Set Primary Module Variables
# ============================================================================================================================================================================

# Set Nova Module Variable
if (Test-Path "Nova"){
$NovaMod = "True"} else { $NovaMod = "False"}

# Set External Module Variable
if (Test-Path "ExtRun"){
$ExternalMod = "True"} else {$ExternalMod = "False"}

# Set Server Module Variable
if ((Test-Path "Server") -and (Test-Path "Reg\Server") -and ($edition -match "Server") -and (($winver -like "6.*") -or ($winver -like "10.*"))){
$ServerMod = "True" } else { $ServerMod = "False"}


# ============================================================================================================================================================================
#																		Set Apps Module Variables
# ============================================================================================================================================================================

# Set Apps Handy Module Variable
if (Test-Path "Apps\Handy"){
$AppsModHandy = "True"} else { $AppsModHandy = "False"}

# Set Apps Utilities Module Variable
if (Test-Path "Apps\Utilities"){
$AppsModUtil = "True"} else { $AppsModUtil = "False"}

# Set Apps WebPlugins Module Variable
if (Test-Path "Apps\Webplugins"){
$AppsModWebPlugins = "True"} else { $AppsModWebPlugins = "False"}

# ============================================================================================================================================================================ 

# Return to original directory
cd $default\run