$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Clean up Script

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Copy Setup Log to User Folder
if (Test-path Setup_Update.log){mv "Setup_Update.log" "$env:UserProfile"}

# Set UAC back to normal
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 1 -PropertyType "DWORD" -Force | out-null

# Remove startup items if necessary
if (Test-path "$Startup\Starter.bat"){ 
	Rename-Item "$Startup\Starter.bat" "temp.TMP"
	Remove-Item "$Startup\temp.TMP"}

# Fix Run Once for Vista / Server 2008
if ($winver -like "6.0.*"){
REN "$env:windir\system32\runonce.exe.dis" "runonce.exe"}

# Last Minute Install on Server 2008 R2
if (($ServerMod -eq "True") -and ($winver -like "6.1.*")){
cd "$default\Server\2008r2"
start-process "Packs\W7packsR2.exe" -ArgumentList "/silent" -wait}

# Delete Scripts Folder & PowerShell Profile
if (test-path "$env:windir\Setup\Scripts"){
	cd $env:temp
	sc wipe.ps1 'rm -r -force "$env:windir\Setup\Scripts"'
	. .\wipe.ps1}
	
Restart-Computer -Force
exit