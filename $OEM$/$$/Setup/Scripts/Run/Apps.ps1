$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Apps Module for Post Install

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\InstallRec.ps1

function Apps($Action){

# Set the location
cd $default

# Apps Module for Install
if ($Action -eq "Setup"){

	# Applications Module (Multi - ARC)
	if ($AppsModHandy -eq "True"){
	cd $default\Apps\Handy
	
		if ($arc -eq "64-bit"){
		start-process $Handy.Chrome.Setup64 -ArgumentList "$q" -wait
		start-process $Handy.Firefox.Setup64 -ArgumentList "-ms" -wait } else {
		start-process $Handy.Chrome.Setup32 -ArgumentList "$q" -wait
		start-process $Handy.Firefox.Setup32 -ArgumentList "-ms" -wait}
		
		#Neutral
		start-process $Handy.MediaMonkey.Setup -ArgumentList "$silent" -wait
	}

	# Utilities / Tools Module
	if ($AppsModUtil -eq "True"){
	cd $default\Apps\Utilities
	
	copy $Util.AutoRuns.Setup "$env:homedrive\"
	copy $Util.ProcessExp.Setup "$env:homedrive\"
	start-process $Util.CCleaner.Setup -ArgumentList "$s_big" -wait
	start-process $Util.Notepad.Setup -ArgumentList "$s_big" -wait

	# Utilities / Tools Module (Multi - Arc)
	if ($arc -eq "64-bit"){
	start-process $Util.Python.Setup64 -ArgumentList "$PythonInst" -wait 
	start-process $Util.FileZ.Setup64 -ArgumentList "$s_big" -wait 
	start-process $Util.Qbit.Setup64 -ArgumentList "$s_big" -wait } else {
	start-process $Util.Python.Setup32 -ArgumentList "$PythonInst" -wait
	start-process $Util.FileZ.Setup32 -ArgumentList "$s_big" -wait
	start-process $Util.Qbit.Setup32 -ArgumentList "$s_big" -wait}}

} # End Method for Setup

# ============================================================================================================================================================================
#																Setup
# ============================================================================================================================================================================

if ($Action -eq "PostInstall"){

	# Applications Module
	if ($AppsModHandy -eq "True"){
	cd $default\Apps\Handy

	# Windows 8 & 8.1 & 10 (***Classic Shell Start Button***)
	if (($AppsModHandy -eq "True") -and (($winver -ge "6.2.9200") -or ($winver -like "10.*"))){
	cd $default\Apps\Handy
	
	start-process $Handy.OpenShell.Setup -ArgumentList "$Classy" -wait
	regedit /s "$default\Reg\Tweaks\Classicshell.reg"}

	# Utilities / Tools Module (Multi - ARC)
	if ($AppsModUtil -eq "True"){
	cd $default\Apps\Utilities
	
		if ($arc -eq "64-bit"){start-process $Util["7zip"]["Setup64"] -ArgumentList "$s_big" -wait} else 
		{ start-process $Util["7zip"]["Setup32"] -ArgumentList "$s_big" -wait}
	}

	# Web Plugins Module
	if ($AppsModWebPlugins -eq "True"){
	cd $default\Apps\Webplugins

	# Web Plugins Module (Multi - ARC)
	if ($arc -eq "64-bit"){start-process $WebPlugins.Java.Setup64 -ArgumentList "/s" -wait} else { start-process $WebPlugins.Java.Setup32 -ArgumentList "/s" -wait}}
	
	} # End Method for Post Install
	cd $default\run	
} #End Function