# Clean up Script

# Remove startup items, set UAC back to normal, and Remove InstallVar
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 1 -PropertyType "DWORD" -Force | out-null
Rename-Item "$env:programdata\Microsoft\Windows\Start Menu\Programs\StartUp\Starter.bat" "temp.TMP"
Remove-Item "$env:programdata\Microsoft\Windows\Start Menu\Programs\StartUp\temp.TMP"

# Fix Run Once for Vista / Server 2008
if ($winver -like "6.0.*"){
REN "$env:windir\system32\runonce.exe.dis" "runonce.exe"}

# Last Minute Install on Server 2008 R2
cd "$default\Server\2008r2"
if (($ServerMod -eq "True") -and ($winver -like "6.1.*") -and ($edition -match "Server")){
start-process "Packs\W7packsR2.exe" -ArgumentList "/silent" -wait}

# Delete Scripts Folder & PowerShell Profile
cd $env:temp
sc wipe.ps1 'rm -r -force "$env:windir\Setup\Scripts"'
ac wipe.ps1 'rm -r -force $env:userprofile\documents\WindowsPowerShell'
. .\wipe.ps1

Restart-Computer -Force
exit