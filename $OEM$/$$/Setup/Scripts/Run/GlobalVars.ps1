# Global Variables for Scripts (REQUIRED)

# General Script Variables
$edition = (gwmi Win32_OperatingSystem).Caption
$winver = (gwmi win32_OperatingSystem).Version
$arc = (gwmi win32_OperatingSystem).OSArchitecture
$Temp = $env:temp

# Set Master script directory
if (Test-path "$env:windir\Setup\Scripts"){
$default = "$env:windir\Setup\Scripts"} else {$default = Split-Path (Split-Path $script:MyInvocation.MyCommand.Path) -Parent}

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
$PythonInst = "/passive InstallAllUsers=1"
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
 
# OEM Variables
$OEMkey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"

# Set Directory for Module Variable settings
cd $default

# ============================================================================================================================================================================
#																	 	OEM Pack Internet Check
# ============================================================================================================================================================================

$HTTP_Request = [System.Net.WebRequest]::Create('http://google.com')
$HTTP_Response = $HTTP_Request.GetResponse()
$HTTP_Status = [int]$HTTP_Response.StatusCode

If ($HTTP_Status -eq 200) { 
	$Internet = "True"} Else {$Internet = "False"
}
$HTTP_Response.Close() 

# ============================================================================================================================================================================
#																	 Set External Language Variables
# ============================================================================================================================================================================

# Check Arc and set Correct Python path 
if ($arc -eq "64-bit"){ $PythonPath = ";$env:ProgramFiles\Python 3.5" } else { $PythonPath = ";$Program86\Python 3.5" }

# Set Python check variable
if (Test-Path $PythonPath.substring(1)){
$Python = "True"} else {$Python = "False"}

# ============================================================================================================================================================================
#																		Set Primary Module Variables
# ============================================================================================================================================================================

# Set Server Prep Module Variable
if ((Test-Path "Server") -and (Test-Path "Reg\Server") -and ($edition -match "Server") -and (($winver -like "6.*") -or ($winver -like "10.*"))){
$ServerPrepMod = "True" } else { $ServerPrepMod = "False"}

# Set Nova Module Variable
if (Test-Path "Nova"){
$NovaMod = "True"} else { $NovaMod = "False"}

# Set Server Module Variable
if ((Test-Path "Server") -and ($edition -match "Server") -and (($winver -like "6.*") -or ($winver -like "10.*"))){
$ServerMod = "True" } else { $ServerMod = "False"}

# ============================================================================================================================================================================
#																		Set Apps Module Variables
# ============================================================================================================================================================================

# Set Apps Handy Module Variable
if (Test-Path "Apps\Handy"){
$AppsModHandy = "True"} else { $AppsModHandy = "False"}

# Set Apps Microsoft Module Variable
if (Test-Path "Apps\Microsoft"){
$AppsModMS = "True"} else { $AppsModMS = "False"}

# Set Apps Utilities Module Variable
if (Test-Path "Apps\Utilities"){
$AppsModUtil = "True"} else { $AppsModUtil = "False"}

# Set Apps WebPlugins Module Variable
if (Test-Path "Apps\Webplugins"){
$AppsModWebPlugins = "True"} else { $AppsModWebPlugins = "False"}

# ============================================================================================================================================================================ 

# Return to original directory
cd $default\run