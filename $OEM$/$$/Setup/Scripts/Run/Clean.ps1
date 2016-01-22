# Clean up Script
#
# Load Variables
cd $env:windir\Setup\Scripts\Run
. .\GlobalVars.ps1
#
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 1 -PropertyType "DWORD" -Force | out-null
Rename-Item "$env:programdata\Microsoft\Windows\Start Menu\Programs\StartUp\Starter.bat" "temp.TMP"
Remove-Item "$env:programdata\Microsoft\Windows\Start Menu\Programs\StartUp\temp.TMP"
#
# Fix Run Once for Vista / Server 2008
if ($winver -like "6.0.*"){
REN "$env:windir\system32\runonce.exe.dis" "runonce.exe"}
#
# Last Minute Install on Server 2008 R2
cd "$default\Server\2008r2"
if (($ServerMod -eq "True") -and ($winver -like "6.1.*") -and ($edition -match "Server")){
start-process "Packs\W7packsR2.exe" -ArgumentList "/silent" -wait}
#
Restart-Computer -Force
exit