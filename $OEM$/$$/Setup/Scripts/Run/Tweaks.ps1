# Post Install Tweaks and Fix Pack for Windows
function Tweaks($Action){
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

pause

# Set the location
cd $default

if ($Action -eq "Setup"){

# Add Python to the Path in the Registry (needs restart)
if ($Python -eq "True"){
$RegPath = Get-ItemProperty $SystemVar
$RegValue = $RegPath.Path+$PythonPath
Set-ItemProperty -path $SystemVar -Name Path -Value $RegValue}

# Windows Universal Tweaks (V - 10 / Server 2008 - Server 2016)
regedit /s "Reg\Windows\disable_uac.reg"
regedit /s "Reg\Windows\Takeown.reg"
regedit /s "Reg\Windows\WMPConfig.reg"

} # End Method

# ============================================================================================================================================================================
#															Registry Prep phase to add Keys (folders)
# ============================================================================================================================================================================
if ($Action -eq "PostInstall"){

# Prep Registry by adding items for Universal
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Force | out-null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force | out-null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | out-null

# Prep Registry by adding items (Windows 8)
if ($winver -like "6.2.*") {
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Force | out-null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Force | out-null}

# Prep Registry by adding items (Windows 8.1)
if ($winver -like "6.3.*") {
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Force | out-null}

# Prep Registry by adding items (Windows 8.1 / 10)
if (($winver -like "6.3.*") -or ($winver -like "10.*")){
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\MiniNT" -Force | out-null}

# Prep Registry by adding items (Windows 10)
if ($winver -like "10.*") {
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Force | out-null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Force | out-null}

# Prep Registry by adding items (Custimzations to Programs)
if (($AppsModHandy -eq "True") -and (($winver -ge "6.2.*") -or ($winver -like "10.*"))){
New-Item -Path "HKLM:\Software\IvoSoft" -Force | out-null
New-Item -Path "HKLM:\Software\IvoSoft\ClassicStartMenu" -Force | out-null}

if ($AppsModUtil -eq "True"){
New-Item -Path "HKCU:\Software\Sysinternals" -Force | out-null
New-Item -Path "HKCU:\Software\Sysinternals\Process Explorer" -Force | out-null}

# ============================================================================================================================================================================
#															Add the Registry modifications to Windows
# ============================================================================================================================================================================

# Registry Tweaks for all Windows Versions (Universal)
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name AutoEndTasks -Value 1 -Force | out-null
New-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name PaddedBorderWidth -Value -20 -PropertyType "String" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideDrivesWith-NameMedia -Value 0 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name EnableBalloonTips -Value 0 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ExtendedUIHoverTime -Value 0 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name HideSCAHealth -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoRebootWithLoggedOnUsers -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAUAsDefaultShutdownOption -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" -Name LastAccess -Value 3 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name VerboseStatus -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Name C:\Windows\System32\cmd.exe -Value "~ RUNASADMIN" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -PropertyType "DWORD" -Force | out-null

# Vista Tweaks
if (($winver -like "6.0.*") -and ($edition -match "Vista")){
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsWelcomeCenter" 
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Sidebar"}

# Windows 7 Tweaks
if ($winver -like "6.1.*"){}

# Windows 8 Tweaks
if ($winver -like "6.2.*") {
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Name "DisableHelpSticker" -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" -Name "OpenAtLogon" -Value 0 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "DisableCharmsHint" -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "-NoLockScreen" -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Value 0 -PropertyType "DWORD" -Force | out-null}

# Windows 8.1 Tweaks
if ($winver -like "6.3.*") {
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "MotionAccentId_v1.00" -Value "219" -PropertyType "DWORD" -Force | out-null}

# Windows 8.1 / Windows 10
if (($winver -like "6.3.*") -or ($winver -like "10.*")){
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\MiniNT" -Name "AllowRefsFormatOverNonmirrorVolume" -Value "1" -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\FileSystem" -Name "RefsDisableLastAccessUpdate" -Value "1" -PropertyType "DWORD" -Force | out-null}

# Windows 10 Tweaks
if ($winver -like "10.*") {
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Value "0" -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "EnableProactive" -Value "0" -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value "0" -PropertyType "DWORD" -Force | out-null}

# ============================================================================================================================================================================
#															Add the Registry modifications to Windows
# ============================================================================================================================================================================

# Customizations specific to Windows versions
if (($AppsModHandy -eq "True") -and (($winver -ge "6.2.*") -or ($winver -like "10.*"))){
New-ItemProperty -Path "HKLM:\Software\IvoSoft\ClassicStartMenu" -Name MenuStyle_Default -Value "Win7" -PropertyType "String" -Force | out-null}

if ($AppsModUtil -eq "True"){
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Sysinternals\Process Explorer" -Name EulaAccepted -Value 1 -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" -Name Debugger -Value "C:\PROCEXP.EXE" -PropertyType String -Force | out-null}

# ============================================================================================================================================================================
#															Add registry imports (the big changes)
# ============================================================================================================================================================================

# Registry Tweaks for Windows

# Windows Legacy
regedit /s "Reg\Windows\Right_click_cmd.reg"
regedit /s "Reg\Windows\Right_click_pwr.reg"
regedit /s "Reg\Windows\FirstRunIE.reg"

# Win 7 and Win Vista
if (($winver -like "6.0.*") -or ($winver -like "6.1.*")){
regedit /s "Reg\Windows\Pane_Off.reg"}

# Win 8 and Win 8.1
if (($winver -ge "6.2.*") -or ($winver -like "10.*")){
regedit /s "Reg\Windows\MetroIE.reg"
regedit /s "Reg\Windows\AddLibrariesToNavi.reg"
regedit /s "Reg\Windows\BackColor.reg"
regedit /s "Reg\Windows\RemoveFoldersMyComp.reg"
regedit /s "Reg\Windows\DisableAC.reg"
regedit /s "Reg\Windows\Preview_Pane.reg"}

	}# End Method
	cd $default\run
}# End Function
 
# External Language Prep
function Lang($Action){

if ($Action -eq "PassVarSetup"){
New-item -type file -force $profile | out-null
$filter = '$AutomaticVariables = Get-Variable'
$filterfunc = 'function compvar {
    Compare-Object (Get-Variable) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables"
}'
ac $profile $filter | out-null; ac $profile $filterfunc | out-null
	}
} # End Function