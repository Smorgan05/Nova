# Post Install Pack for Server Workstation

function Server($Action){

if ($Action -eq "ServerConv"){

# Setting Passwords to NOT Expire ...
NET ACCOUNTS /MAXPWAGE:UNLIMITED

# Miscellanious
cd $default
start-process "Server\Universal\gppc.exe" -ArgumentList "/disable"
start-process "Server\Universal\directx.exe" -ArgumentList "$s_small" -wait
start-process "$env:temp\directx_Jun2010_redist\DXSETUP.exe" -ArgumentList "$silent" -wait

# ============================================================
#		  All Server Versions (2008 R2 - Server 2016)
# ============================================================

# Adding Features to SRV2008 / 2008 R2 Workstation Specific

if (($winver -like "6.0.*") -or ($winver -like "6.1.*")){

# Register System32 side
cd "$env:SystemRoot\System32"
regsvr32 /s "bdaplgin.ax"
regsvr32 /s "kstvtune.ax"
regsvr32 /s "ksxbar.ax"
regsvr32 /s "Mpeg2Data.ax"
regsvr32 /s "MSDvbNP.ax"
regsvr32 /s "MSNP.ax"
regsvr32 /s "MSVidCtl.dll"
regsvr32 /s "psisdecd.dll"
regsvr32 /s "psisrndr.ax"
regsvr32 /s "VBICodec.ax"
regsvr32 /s "vbisurf.ax"
regsvr32 /s "WSTPager.ax"
regsvr32 /s "EncDec.dll"

# Register the Dlls on the SysWow64
cd "$env:SystemRoot\SysWow64"
regsvr32 /s "bdaplgin.ax"
regsvr32 /s "kstvtune.ax"
regsvr32 /s "ksxbar.ax"
regsvr32 /s "Mpeg2Data.ax"
regsvr32 /s "MSDvbNP.ax"
regsvr32 /s "MSNP.ax"
regsvr32 /s "MSVidCtl.dll"
regsvr32 /s "psisdecd.dll"
regsvr32 /s "psisrndr.ax"
regsvr32 /s "VBICodec.ax"
regsvr32 /s "vbisurf.ax"
regsvr32 /s "WSTPager.ax"
regsvr32 /s "EncDec.dll"

# Visual C++ 2010 Install
cd "$default\Server\2008r2"
start-process "Apps\2010x32.exe" -wait
start-process "Apps\2010x64.exe" -wait}

# Server 2008 R2 Workstation Install
if ($winver -like "6.1.*"){
start-process "Other\Uxth64.exe"}

# ============================================================
#			   Section Ender for 2008 / 2008 R2 
# ============================================================
# Adding Features to SRV2012/R2 Workstation Specific

if (($winver -like "6.2.*") -or ($winver -like "6.3.*")){

# Registering gameux.dll...

cd "$env:SystemRoot\System32"
regsvr32 /s "gameux.dll"

cd "$env:SystemRoot\SysWOW64"
regsvr32 /s "gameux.dll"

# Installing 64bit dmusic.dll...

cd "$env:SystemRoot\System32"
regsvr32 /s "dmusic.dll"
regsvr32 /s "dmloader.dll"
regsvr32 /s "dmsynth.dll"
regsvr32 /s "dswave.dll"

# Installing 32bit dmusic.dll...

cd "$env:SystemRoot\SysWOW64"
regsvr32 /s "dmusic.dll"
regsvr32 /s "dmband.dll"
regsvr32 /s "dmcompos.dll"
regsvr32 /s "dmime.dll"
regsvr32 /s "dmloader.dll"
regsvr32 /s "dmscript.dll"
regsvr32 /s "dmstyle.dll"
regsvr32 /s "dmsynth.dll"
regsvr32 /s "dswave.dll"
pushd $env:windir\SysWOW64
rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 132 .\dmusic.inf}

# ============================================================
#				Section Ender for 2012 / 2012 R2
# ============================================================
	} #End Server Conversion (Post Install)

if ($Action -eq "ServerPrep"){

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

# ============================================================
#		   Prepare for Server Workstation Converstion
# ============================================================

cd $default\Server

# Universal to Server 2008 / Server 2008 R2 and Server 2012 / Server 2012 R2
Set-Service Audiosrv -startupType automatic
Set-Service AudioEndpointBuilder -startupType automatic

# Server 2008 / Server 2008 R2 Specific
if (($edition -match "Server 2008") -and ($winver -ge "6.0.6002")){
start-process "2008r2\Cursors.exe" -ArgumentList "$s_small" -wait
start-process "2008r2\System32.exe" -ArgumentList "$s_small" -wait
start-process "2008r2\SysWow64.exe" -ArgumentList "$s_small" -wait}

# Server 2012 / Server 2012 R2 Specific
if (($edition -match "Server 2012") -and ($winver -ge "6.2.9200")){
start-process "2012r2\Cursors.exe" -ArgumentList "$s_small" -wait
start-process "2012r2\System32.exe" -ArgumentList "$s_small" -wait
start-process "2012r2\SysWow64.exe" -ArgumentList "$s_small" -wait}

# Server 2016 Specifc
if (($edition -match "Server") -and ($winver -like "10.*")){

}

# ============================================================
#					Server Registry Area
# ============================================================

# Change Location to Server Registry File Location
cd $default\Reg\Server

if ($edition -match "Server"){
regedit /s "Universal\Server.reg"}

# Registry Imports for Server 2008 / R2
if (($edition -match "Server 2008") -and ($winver -ge "6.0.6002")){
regedit /s "Serv2008r2\bda.reg"
regedit /s "Serv2008r2\mpeg2enc.reg"
regedit /s "Serv2008r2\iccvid.reg"
regedit /s "Serv2008r2\desktop.reg"
regedit /s "Serv2008r2\srv2008r2.reg"}

# Registry Imports for Server 2012 / R2
if (($edition -match "Server 2012") -and ($winver -ge "6.2.9200")){
regedit /s "Serv2012r2\enable_wstore_admin.reg"
regedit /s "Serv2012r2\aero_intel_cursors_current_user.reg"
regedit /s "Serv2012r2\aero_w8_current_user.reg"
regedit /s "Serv2012r2\aero_mouse_pointers.reg"
regedit /s "Serv2012r2\mpeg2enc.reg"
regedit /s "Serv2012r2\srv2012.reg"}

# Registry Imports for Server 2016
if (($edition -match "Server") -and ($winver -like "10.*")){

}

# ============================================================
#			Server Enable Features for Server OS
# ============================================================

# Server 2008 ONLY
if ($winver -like "6.0.*"){
servermanagercmd -install Desktop-Experience
servermanagercmd -install Wireless-Networking
servermanagercmd -install Net-Framework -allSubFeatures
servermanagercmd -install Backup-Features}

# Server 2008 R2 - Server 2016
if (($winver -ge "6.1.*") -or ($winver -like "10.*")){
Import-Module ServerManager
Add-WindowsFeature -Name Wireless-Networking
Add-WindowsFeature -Name Desktop-Experience -IncludeAllSubFeature

if ($winver -like "6.1.*"){
Add-WindowsFeature -Name Ink-Handwriting
Add-WindowsFeature -Name Net-Framework -IncludeAllSubFeature
Add-WindowsFeature -Name Backup-Features}

if (($winver -ge "6.2.*") -or ($winver -like "10.*")){
Add-WindowsFeature -Name Server-Media-Foundation
Add-WindowsFeature -Name Windows-Server-Backup
Add-WindowsFeature -Name Net-Framework-Core}}
	
	} #End Server Prep (Setup Phase)
	cd $default\run	
}#End Script Function