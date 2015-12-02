# Apps Module for Post Install
#
# Load Variables
cd $env:windir\Setup\Scripts\Run
. .\InstallRec.ps1
#
function Apps($Action){
#
# Set the location
cd $default
#
# Apps Module for Install
if ($Action -eq "Setup"){
#
# Applications Module (Multi - ARC)
if ($AppsModHandy -eq "True"){
if ($arc -eq "64-bit"){ 
start-process "Apps\Handy\$Chrome64" -ArgumentList "$q" -wait 
start-process "Apps\Handy\$MPC64" -ArgumentList "$silent" -wait } else { 
start-process "Apps\Handy\$Chrome32" -ArgumentList "$q" -wait
start-process "Apps\Handy\$MPC32" -ArgumentList "$silent" -wait}}
#
# Utilities / Tools Module
if ($AppsModUtil -eq "True"){
copy "Apps\Utilities\$AutoRuns" "$env:homedrive\"
copy "Apps\Utilities\$ProcessExp" "$env:homedrive\"
start-process "Apps\Utilities\$CCleaner" -ArgumentList "$s_big" -wait
start-process "Apps\Utilities\$Defraggler" -ArgumentList "$s_big" -wait
start-process "Apps\Utilities\$Notepad" -ArgumentList "$s_big" -wait}
#
# Utilities / Tools Module (Multi - Arc)
if ($arc -eq "64-bit"){
start-process "Apps\Utilities\$FileZ64" -ArgumentList "$s_big" -wait } else {
start-process "Apps\Utilities\$FileZ32" -ArgumentList "$s_big" -wait}
#
	} # End Method for Setup
#
# ============================================================================================================================================================================
#																Setup
# ============================================================================================================================================================================
#
if ($Action -eq "PostInstall"){
#
# Windows 8 & 8.1 & 10 (***Classic Shell Start Button***)
if (($AppsModHandy -eq "True") -and (($winver -ge "6.2.9200") -or ($winver -like "10.*"))){
start-process "Apps\Handy\$Classic" -ArgumentList "$Classy" -wait
start-process "Apps\Handy\$Buttons" -ArgumentList "$s_small" -wait
regedit /s "Reg\Tweaks\Classicshell.reg"}
#
# Utilities / Tools Module (Multi - ARC)
if ($AppsModUtil -eq "True"){
if ($arc -eq "64-bit"){start-process "Apps\Utilities\$7zip64" -ArgumentList "$s_big" -wait} else { start-process "Apps\Utilities\$7zip32" -ArgumentList "$s_big" -wait}}
#
# Web Plugins Module
if ($AppsModWebPlugins -eq "True"){
start-process "Apps\Webplugins\$Flash" -ArgumentList "-install" -wait
#
# Web Plugins Module (Multi - ARC)
if ($arc -eq "64-bit"){start-process "Apps\Webplugins\$Java64" -ArgumentList "/s" -wait} else { start-process "Apps\Webplugins\$Java32" -ArgumentList "/s" -wait}}
#	
	} # End Method for Post Install
	cd $default\run	
} #End Function