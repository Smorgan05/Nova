# Nova Pack Settings

# Load Variables
cd $env:windir\Setup\Scripts\Run
. .\GlobalVars.ps1

# Set the location for Scripting
cd $default

# Set date for Master Development Build
$date = Get-Date -format "MM.dd.yyyy"

if ($NovaMod -eq "True"){
New-ItemProperty $OEMkey -Name Manufacturer -Value "Nova Edition" -Force | out-null
New-ItemProperty $OEMkey -Name Model -Value "Nova v12.1 ($date)" -Force | out-null
New-ItemProperty $OEMkey -Name Logo -Value "$home\Nova Pack\Themes\Nova.bmp" -Force | out-null

# Start unpacking of Nova Pack
start-process "Nova\Nova.exe" -ArgumentList "$s_small" -wait

# Start themes for Server side
if ($edition -match "Server"){
Set-Service Themes -startupType automatic
net start Themes
	} # Server Match

# Theme install for Windows (Must be different for V/7/8+)
if (($winver -ge "6.2.9200") -or ($winver -like "10.*")){
start-process "$home\Nova Pack\Themes\Nova v8.themepack"} 
elseif ($winver -like "6.1.*"){
start-process "$home\Nova Pack\Themes\Nova v7.themepack"}
elseif (($winver -like "6.0.*") -or (($winver -like "6.1.*") -and ($edition -ne "Starter") -and ($edition -ne "Home Basic"))){
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "$home\Nova Pack\Themes\Nova.jpg"}
	} # End Nova Module Check

# Return to original directory
cd $default\run