# Global Variables for Scripts (REQUIRED)
#
# General Script Variables
$edition = (gwmi Win32_OperatingSystem).Caption
$winver = (gwmi win32_OperatingSystem).Version
$arc = (gwmi win32_OperatingSystem).OSArchitecture
$Temp = $env:temp
$default = "$env:windir\Setup\Scripts"
#
# Multi-use Variables
$s_big = "/S"
$q = "/q"
$silent = "/silent"
$quiet = "/quiet"
$s_small = "-s"
#
# Set Variables for Scripts that will create a new instance of PS
$Privacy = "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File Privacy.ps1"
#
# Shortcut Variables
$StartMenuUser = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
#
# One Use variables
$Classy = "/qn ADDLOCAL=ClassicStartMenu"
#
# Enviromental Variables (Permenant - System / User)
$System = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
$User = "HKCU:\Environment"
#
# Privacy Variables (Privacy.ps1)
$WinTasks = "$env:windir\System32\Tasks\Microsoft\Windows"
$OffTasks = "$env:windir\System32\Tasks\Microsoft\Office"
$Diagnostics = "$env:systemdrive\ProgramData\Microsoft\Diagnosis"
$ShutLogger = "ETLLogs\ShutdownLogger\AutoLogger-Diagtrack-Listener.etl" 
$AutoLogger = "ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
$RegRoute = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes"
$DiagTrack = (gsv "DiagTrack")
$Dmwappush = (gsv "dmwappushservice")
#
# Set Directory for Module Variable settings
cd $default
#
# ============================================================================================================================================================================
#																		Set Primary Module Variables
# ============================================================================================================================================================================
#
# Set Server Prep Module Variable
if ((Test-Path "Server") -and (Test-Path "Reg\Server") -and ($edition -match "Server") -and (($winver -like "6.*") -or ($winver -like "10.*"))){
$ServerPrepMod = "True" } else { $ServerPrepMod = "False"}
#
# Set Nova Module Variable
if (Test-Path "Nova"){
$NovaMod = "True"} else { $NovaMod = "False"}
#
# Set Server Module Variable
if ((Test-Path "Server") -and ($edition -match "Server") -and (($winver -like "6.*") -or ($winver -like "10.*"))){
$ServerMod = "True" } else { $ServerMod = "False"}
#
# ============================================================================================================================================================================
#																		Set Apps Module Variables
# ============================================================================================================================================================================
#
# Set Apps Handy Module Variable
if (Test-Path "Apps\Handy"){
$AppsModHandy = "True"} else { $AppsModHandy = "False"}
#
# Set Apps Microsoft Module Variable
if (Test-Path "Apps\Microsoft"){
$AppsModMS = "True"} else { $AppsModMS = "False"}
#
# Set Apps Utilities Module Variable
if (Test-Path "Apps\Utilities"){
$AppsModUtil = "True"} else { $AppsModUtil = "False"}
#
# Set Apps WebPlugins Module Variable
if (Test-Path "Apps\Webplugins"){
$AppsModWebPlugins = "True"} else { $AppsModWebPlugins = "False"}
#
# ============================================================================================================================================================================ 
#
# Return to original directory
cd $default\run