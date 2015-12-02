# Server Prep module for Setup
#
# Load Variables
cd $env:windir\Setup\Scripts\Run
. .\GlobalVars.ps1
#
# Disable IE ESC Mode
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Force | out-null
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value "0" -PropertyType "DWORD" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value "0" -PropertyType "DWORD" -Force | out-null
Rundll32 iesetup.dll, IEHardenLMSettings
Rundll32 iesetup.dll, IEHardenUser
Rundll32 iesetup.dll, IEHardenAdmin
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Force | out-null
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\Main" -Name "Default_Page_URL" -Value "https://www.google.com/" -PropertyType "String" -Force | out-null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\Main" -Name "Start Page" -Value "https://www.google.com/" -PropertyType "String" -Force | out-null
#
# ============================================================================================================================================================================
#																Prepare for Server Workstation Converstion
# ============================================================================================================================================================================
#
cd $default\Server
#
# Universal to Server 2008 / Server 2008 R2 and Server 2012 / Server 2012 R2
Set-Service Audiosrv -startupType automatic
Set-Service AudioEndpointBuilder -startupType automatic
#
# Server 2008 / Server 2008 R2 Specific
if (($edition -match "Server 2008") -and ($winver -ge "6.0.6002")){
start-process "2008r2\Cursors.exe" -ArgumentList "$s_small" -wait
start-process "2008r2\System32.exe" -ArgumentList "$s_small" -wait
start-process "2008r2\SysWow64.exe" -ArgumentList "$s_small" -wait}
#
# Server 2012 / Server 2012 R2 Specific
if (($edition -match "Server 2012") -and ($winver -ge "6.2.9200")){
start-process "2012r2\Cursors.exe" -ArgumentList "$s_small" -wait
start-process "2012r2\System32.exe" -ArgumentList "$s_small" -wait
start-process "2012r2\SysWow64.exe" -ArgumentList "$s_small" -wait}
#
# Server 2016 Specifc
if (($edition -match "Server") -and ($winver -like "10.*")){


}
#
# ============================================================================================================================================================================
#																Server Registry Area
# ============================================================================================================================================================================
#
# Change Location to Server Registry File Location
cd $default\Reg\Server
#
if ($edition -match "Server"){
reg import "Universal\Server.reg"}
#
# Registry Imports for Server 2008 / R2
if (($edition -match "Server 2008") -and ($winver -ge "6.0.6002")){
reg import "Serv2008r2\bda.reg"
reg import "Serv2008r2\mpeg2enc.reg"
reg import "Serv2008r2\iccvid.reg"
reg import "Serv2008r2\desktop.reg"
reg import "Serv2008r2\srv2008r2.reg"}
#
# Registry Imports for Server 2012 / R2
if (($edition -match "Server 2012") -and ($winver -ge "6.2.9200")){
reg import "Serv2012r2\enable_wstore_admin.reg"
reg import "Serv2012r2\aero_intel_cursors_current_user.reg"
reg import "Serv2012r2\aero_w8_current_user.reg"
reg import "Serv2012r2\aero_mouse_pointers.reg"
reg import "Serv2012r2\mpeg2enc.reg"
reg import "Serv2012r2\srv2012.reg"}
#
# Registry Imports for Server 2016
if (($edition -match "Server") -and ($winver -like "10.*")){

}
#
# ============================================================================================================================================================================
#																Server Enable Features for Server OS
# ============================================================================================================================================================================
#
# Server 2008 ONLY
if ($winver -like "6.0.*"){
servermanagercmd -install Desktop-Experience
servermanagercmd -install Wireless-Networking
servermanagercmd -install Net-Framework -allSubFeatures
servermanagercmd -install Backup-Features}
#
# Server 2008 R2 - Server 2016
if (($winver -ge "6.1.*") -or ($winver -like "10.*")){
Import-Module ServerManager
Add-WindowsFeature -Name Wireless-Networking
Add-WindowsFeature -Name Desktop-Experience -IncludeAllSubFeature
#
if ($winver -like "6.1.*"){
Add-WindowsFeature -Name Ink-Handwriting
Add-WindowsFeature -Name Net-Framework -IncludeAllSubFeature
Add-WindowsFeature -Name Backup-Features}
#
if (($winver -ge "6.2.*") -or ($winver -like "10.*")){
Add-WindowsFeature -Name Server-Media-Foundation
Add-WindowsFeature -Name Windows-Server-Backup
Add-WindowsFeature -Name Net-Framework-Core}}