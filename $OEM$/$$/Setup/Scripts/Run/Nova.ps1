$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Nova Pack Settings

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Set the location for Scripting
cd $default

# Set date for Master Development Build
$date = Get-Date -format "MM.dd.yyyy"

# Apply Theme packs and Start button
if (($NovaMod -eq "True") -and (($PSVer -eq "2.0") -or ($winver -ge "6.1") -or ($winver -like "10.*"))){
	
	#UnPack Nova themes and background
	start-process "Nova\Nova.exe" -ArgumentList "$s_small" -wait
	
	if (($winver -ge "6.1") -or ($winver -like "10.*")){
	
	# Set information in System Information
	New-ItemProperty $OEMkey -Name Manufacturer -Value "Nova Edition" -Force | out-null
	New-ItemProperty $OEMkey -Name Model -Value "Nova $NovaVer ($date)" -Force | out-null
	New-ItemProperty $OEMkey -Name Logo -Value "$home\Nova Pack\Themes\NovaMini.bmp" -Force | out-null

		# Unpack Buttons for Classic Shell
		if (($AppsModHandy -eq "True") -and (($winver -ge "6.2.*") -or ($winver -like "10.*"))){
		start-process "Nova\Buttons.exe" -ArgumentList "$s_small" -wait}

		# Start themes for Server side
		if (($ServerMod -eq "True") -and ($ThemesServ -ne "Running")){
		Set-Service Themes -startupType automatic
		net start Themes}

		# Theme install for Windows (Must be different for V/7/8+)
		if (($winver -ge "6.2.9200") -or ($winver -like "10.*")){
		start-process "$home\Nova Pack\Themes\Nova v8.themepack"} 
		elseif ($winver -like "6.1.*"){
		start-process "$home\Nova Pack\Themes\Nova v7.themepack"}
	}
	
	if (($PSVer -eq "2.0") -or (($winver -like "6.1.*") -and ($edition -ne "Starter") -and ($edition -ne "Home Basic"))){
	Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "$env:userprofile\Nova Pack\Themes\Nova.bmp"}
	
	} # End Nova Module Check

# Return to original directory
cd $default\run