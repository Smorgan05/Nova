$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Privacy Script

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

<# # External Scripts Run
if (($ExternalMod -eq "True") -and ($winver -like "10.*")){
cd $default\ExtRun
. .\Kill-Edge.ps1
. .\Kill-Cortana.ps1}#>

# Disable Windows 10 upgrade
if ($winver -notlike "10.*"){
New-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Name DisableOSUpgrade -Value "1" -PropertyType "DWord"  -Force | out-null}

# Disable Windows 10 Specific
if ($winver -like "10.*"){
New-NetFirewallRule -DisplayName "MS Telemetry" -Direction Outbound -Program "$env:Windir\SystemApps\Microsoft\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe" -Action Block}

# Host
cd $env:windir\System32\drivers\etc
TAKEOWN /F "hosts"; ICACLS "hosts" /reset /T /Q; attrib -R hosts;
function Host($IPAddress){
	$local = "0.0.0.0"
	ac hosts "$local $IPAddress"}

# Add IPs to Host File
Host "vortex.data.microsoft.com"; Host "vortex-win.data.microsoft.com"; Host "telecommand.telemetry.microsoft.com"; Host "telecommand.telemetry.microsoft.com.nsatc.net"
Host "oca.telemetry.microsoft.com"; Host "oca.telemetry.microsoft.com.nsatc.net"; Host "sqm.telemetry.microsoft.com"; Host "sqm.telemetry.microsoft.com.nsatc.net"
Host "watson.telemetry.microsoft.com"; Host "watson.telemetry.microsoft.com.nsatc.net"; Host "redir.metaservices.microsoft.com"; Host "choice.microsoft.com"
Host "choice.microsoft.com.nsatc.net"; Host "df.telemetry.microsoft.com"; Host "reports.wes.df.telemetry.microsoft.com"; Host "wes.df.telemetry.microsoft.com"
Host "services.wes.df.telemetry.microsoft.com"; Host "sqm.df.telemetry.microsoft.com"; Host "telemetry.microsoft.com"; Host "watson.ppe.telemetry.microsoft.com"
Host "telemetry.appex.bing.net"; Host "telemetry.urs.microsoft.com";Host "telemetry.appex.bing.net:443"; Host "settings-sandbox.data.microsoft.com"
Host "vortex-sandbox.data.microsoft.com"; Host "survey.watson.microsoft.com"; Host "watson.live.com"; Host "watson.microsoft.com"; Host "statsfe2.ws.microsoft.com"
Host "corpext.msitadfs.glbdns2.microsoft.com"; Host "compatexchange.cloudapp.net"; Host "cs1.wpc.v0cdn.net"; Host "a-0001.a-msedge.net"; Host "statsfe2.update.microsoft.com.akadns.net"
Host "sls.update.microsoft.com.akadns.net"; Host "fe2.update.microsoft.com.akadns.net"; Host "diagnostics.support.microsoft.com"; Host "corp.sts.microsoft.com"; Host "statsfe1.ws.microsoft.com"
Host "pre.footprintpredict.com"; Host "i1.services.social.microsoft.com"; Host "i1.services.social.microsoft.com.nsatc.net"; Host "feedback.windows.com"; Host "feedback.microsoft-hohm.com"
Host "feedback.search.microsoft.com"; Host "rad.msn.com"; Host "preview.msn.com"; Host "ad.doubleclick.net"; Host "ads.msn.com"; Host "ads1.msads.net"; Host "ads1.msn.com"
Host "a.ads1.msn.com"; Host "a.ads2.msn.com"; Host "adnexus.net"; Host "adnxs.com"; Host "aidps.atdmt.com"; Host "az361816.vo.msecnd.net"; Host "az512334.vo.msecnd.net"
Host "a.rad.msn.com"; Host "a.ads2.msads.net"; Host "ac3.msn.com"; Host "aka-cdn-ns.adtech.de"; Host "b.rad.msn.com"; Host "b.ads2.msads.net"; Host "b.ads1.msn.com"
Host "bs.serving-sys.com"; Host "c.msn.com"; Host "cdn.atdmt.com"; Host "cds26.ams9.msecn.net"; Host "c.atdmt.com"; Host "db3aqu.atdmt.com"; Host "ec.atdmt.com"; Host "flex.msn.com"
Host "g.msn.com"; Host "h2.msn.com"; Host "h1.msn.com"; Host "live.rads.msn.com"; Host "msntest.serving-sys.com"; Host "m.adnxs.com"; Host "m.hotmail.com"; Host "preview.msn.com"
Host "rad.msn.com"; Host "rad.live.com"; Host "secure.flashtalking.com"; Host "static.2mdn.net"; Host "s.gateway.messenger.live.com"; Host "secure.adnxs.com"; Host "sO.2mdn.net"
Host "view.atdmt.com"; Host "msnbot-65-55-108-23.search.msn.com"; Host "settings-win.data.microsoft.com"; Host "schemas.microsoft.akadns.net"; Host "a-0001.a-msedge.net"
Host "a-0002.a-msedge.net"; Host "a-0003.a-msedge.net"; Host "a-0004.a-msedge.net"; Host "a-0005.a-msedge.net"; Host "a-0006.a-msedge.net"; Host "a-0007.a-msedge.net"
Host "a-0008.a-msedge.net"; Host "a-0009.a-msedge.net"; Host "msedge.net"; Host "a-msedge.net"; Host "lb1.www.ms.akadns.net"; Host "pre.footprintpredict.com"
Host "vortex-bn2.metron.live.com.nsatc.net"; Host "vortex-cy2.metron.live.com.nsatc.net"; Host "BN1WNS2011508.wns.windows.com"; Host "a1095.g2.akamai.net"; Host "a1856.g2.akamai.net"
Host "a1961.g.akamai.net"; Host "a569.g.akamai.net"; Host "a973.g.akamai.net"; Host "act-3-blu.mesh.com"; Host "df.telemetry.microsoft.com"; Host "dns.msftncsi.com"
Host "oca.telemetry.microsoft.com.nsatc.net"; Host "reports.wes.df.telemetry.microsoft.com"; Host "sqm.telemetry.microsoft.com.nsatc.net"; Host "wes.df.telemetry.microsoft.com"

# Router
function Route($Route){
	$def = ",255.255.255.255,0.0.0.0,1"
	$Regkey = $Route + $def
	New-ItemProperty -Path $RegRoute -Name $Regkey -PropertyType "String" -Force | out-null}

# Route Telemetry IP's (function)
Route "111.221.29.177"; Route "111.221.29.253"; Route "131.253.40.37"; Route "134.170.30.202"; Route "134.170.115.60"
Route "134.170.165.248"; Route "134.170.165.253"; Route "134.170.185.70"; Route "137.116.81.24"; Route "137.117.235.16"
Route "157.55.129.21"; Route "157.55.133.204"; Route "157.56.121.89"; Route "157.56.91.77"; Route "168.63.108.233"
Route "191.232.139.254"; Route "191.232.80.58"; Route "191.232.80.62"; Route "191.237.208.126"; Route "204.79.197.200"
Route "207.46.101.29"; Route "207.46.114.58"; Route "207.46.223.94"; Route "207.68.166.254"; Route "212.30.134.204"
Route "212.30.134.205"; Route "23.102.21.4"; Route "23.99.10.11"; Route "23.218.212.69"; Route "64.4.54.22"
Route "64.4.54.32"; Route "64.4.6.100"; Route "65.39.117.230"; Route "65.52.100.11"; Route "65.52.100.7"
Route "65.52.100.9"; Route "65.52.100.91"; Route "65.52.100.92"; Route "65.52.100.93"; Route "65.52.100.94"
Route "65.52.108.29"; Route "65.55.108.23"; Route "65.55.138.114"; Route "65.55.138.126"; Route "65.55.138.186"
Route "65.55.252.63"; Route "65.55.252.71"; Route "65.55.252.92"; Route "65.55.252.93"; Route "65.55.29.238"
Route "65.55.39.10"; Route "96.6.122.184"; Route "96.6.122.218"; Route "96.6.122.216"; Route "96.6.122.144"
Route "96.6.122.67"; Route "96.6.122.73"; Route "94.245.121.177"; Route "94.245.121.178"; Route "94.245.121.176"
Route "94.245.121.179"; Route "216.38.172.128"; Route "96.6.122.169"; Route "96.6.122.224"; Route "96.6.122.74"
Route "93.184.215.200"; Route "68.67.152.94"; Route "68.67.153.87"; Route "68.67.153.37"; Route "131.107.255.255"
Route "65.55.194.241"; Route "68.67.152.174"; Route "68.67.152.173"; Route "68.67.152.110"; Route "68.67.152.120"
Route "68.67.152.172"; Route "65.52.108.11"; Route "204.79.197.201"; Route "204.79.197.203"; Route "204.79.197.206"
Route "204.79.197.204"; Route "204.79.197.208"; Route "204.79.197.209"; Route "204.79.197.210"; Route "204.79.197.211"
Route "207.68.166.254"; Route "168.61.24.141"; Route "65.55.252.43"; Route "65.54.226.187"; Route "157.56.100.83"
Route "157.56.17.248"; Route "65.55.138.112"; Route "65.55.44.109"; Route "65.55.29.238"; Route "134.170.165.249"
Route "65.55.252.43"; 

# Registry entry to disable Allow Telemtry
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Value 0 -PropertyType "DWORD" -Force | out-null

# Query to find scheduled tasks and disable if present
cd $WinTasks
if (Test-Path "Customer Experience Improvement Program"){
SCHTASKS /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable}

if (Test-Path "Power Efficiency Diagnostics\AnalyzeSystem"){
SCHTASKS /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable}

if (Test-Path Shell){
SCHTASKS /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Shell\FamilySafetyRefresh" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable}

if (Test-Path "Application Experience"){
SCHTASKS /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
SCHTASKS /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable}

if (Test-Path Autochk){
SCHTASKS /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable}

if (Test-Path AppID){
SCHTASKS /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable}

if (Test-Path DiskDiagnostic){
SCHTASKS /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable}

if (Test-Path NetTrace){
SCHTASKS /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable}

if (Test-Path PI){
SCHTASKS /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable}

if (Test-Path FileHistory){
SCHTASKS /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable}

if (Test-Path DiskFootprint){
SCHTASKS /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable}

if (Test-Path CloudExperienceHost){
SCHTASKS /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable}

if (Test-Path "Windows Error Reporting"){
SCHTASKS /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable}

if (Test-Path $OffTasks){
cd $OffTasks
SCHTASKS /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
SCHTASKS /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
SCHTASKS /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable
SCHTASKS /change /TN "Microsoft\Office\OfficeTelemetry\AgentFallBack2016" /Disable
SCHTASKS /Change /TN "Microsoft\Office\OfficeTelemetry\OfficeTelemetryAgentLogOn2016" /Disable}

#Telemtry query for running services to delete
if ($DiagTrack){
SC stop DiagTrack; SC delete DiagTrack}
if ($Dmwappush){
SC stop dmwappushservice; SC delete dmwappushservice}

# Disable if present Diagnosis folder and .etl file locations for telemetry logging
if (Test-Path $Diagnostics){
TAKEOWN /F $Diagnostics; ICACLS $Diagnostics /reset /T /Q
CMD /C "ICACLS $Diagnostics /remove:g SYSTEM /inheritance:r /deny SYSTEM:(OI)(CI)F"}

if (Test-Path $Diagnostics\$AutoLogger){
$FullAutoLogger = $Diagnostics +"\"+ $AutoLogger
TAKEOWN /F $FullAutoLogger; ICACLS $FullAutoLogger /reset /T /Q; rm $FullAutoLogger}

if (Test-Path $Diagnostics\$ShutLogger){
$FullShutLogger = $Diagnostics +"\"+ $ShutLogger
TAKEOWN /F $FullShutLogger; ICACLS $FullShutLogger /reset /T /Q; rm $FullShutLogger}

# Flush to bypass reboot after hosts file entries
nbtstat -R
ipconfig /flushdns
ipconfig /registerdns
sc stop dnscache; sc start dnscache

# ====================================================

# Return to original directory
cd $default\run