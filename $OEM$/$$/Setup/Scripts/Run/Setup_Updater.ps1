$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Setup Updater to facilitate easy update of Setup Files

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\InstallRec.ps1

# Function to unzip files
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)}
	
# Hash Checking Function
function HashCheck($File){
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File)))}

# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# ===============================================================* Handy *=====================================================================
cd $Default\Apps\Handy

# Grab the Newest Classic Shell Setup

$ClassicVer = $ClassicVer.replace(", ",".")
$WebResponse = Invoke-WebRequest http://www.classicshell.net/downloads/
$ClassicRev = ($WebResponse.links.innerhtml | Where-Object {$_ -match "English"} | Measure-Object -Maximum).Maximum
$ClassicRev = $ClassicRev | Where-Object {$_ -match "[0-9].[0-9].[0-9]"}; $ClassicRev = $Matches.0; $ClassicLnk = $ClassicRev.replace(".","_")
$ClassicRevKey = $WebResponse.links.href | Where-Object {$_ -match "setup" -and $_ -notmatch "-[a-z][a-z]"}
$ClassicRevKey = $ClassicRevKey.Split("/") | Where-Object {$_.length -eq 15 }

$URL = 'http://www.mediafire.com/download/' + $ClassicRevKey + '/ClassicShellSetup_' + $ClassicLnk + '.exe'
$Setup = 'ClassicShellSetup_' + $ClassicLnkm + '.exe'

if ($ClassicRev -gt $ClassicVer){
Write-host "Updating Classic Shell"
	if ($Classic) {rm $Classic}
wget $URL -OutFile $Setup} else {Write-host "Classic Shell is up to Date"}

# Grab the Newest MPC-HC Setup

$WebResponse = Invoke-WebRequest https://mpc-hc.org/downloads/
$MPCRev =  ($WebResponse.Links.href | Where-Object {$_ -match "exe"} | Measure-Object -Maximum).Maximum
$MPCRev = $MPCRev.Split("_"); $MPCRev = $MPCRev[1]; $MPCRev = $MPCRev.replace("v","")

$URLx32 = 'https://binaries.mpc-hc.org/MPC HomeCinema - Win32/MPC-HC_v' + $MPCRev + '_x86/MPC-HC.' + $MPCRev + '.x86.exe'
$URLx64 = 'https://binaries.mpc-hc.org/MPC HomeCinema - x64/MPC-HC_v' + $MPCRev + '_x64/MPC-HC.' + $MPCRev + '.x64.exe'
$Setupx32 = 'MPC-HC.' + $MPCRev + '.x86.exe' 
$Setupx64 = 'MPC-HC.' + $MPCRev + '.x64.exe'

if ($MPCRev -gt $MPC32Ver){
Write-host "Updating Media Player Classic"
	if ($MPC32) {rm $MPC32}
	if ($MPC64) {rm $MPC64}
wget $URLx32 -OutFile $Setupx32
wget $URLx64 -OutFile $Setupx64} else {Write-host "Media Player Classic is up to Date"}
 
# Grab the newest Firefox Setup

$WebResponse = Invoke-WebRequest https://ftp.mozilla.org/pub/firefox/releases/
$FirefoxRev = ($WebResponse.Links.href | Where-Object {$_ -like "*[0-9][0-9].[0-9].[0-9]*" -and $_ -notlike "*.[0-9][a-z]*"} | Measure-Object -Maximum).Maximum
$FirefoxRev = $FirefoxRev | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9]"}; $FirefoxRev = $Matches.0

$URLx32 = 'https://ftp.mozilla.org/pub/firefox/releases/' + $FirefoxRev + '/win32/en-US/Firefox Setup ' + $FirefoxRev + '.exe'
$URLx64 = 'https://ftp.mozilla.org/pub/firefox/releases/' + $FirefoxRev + '/win64/en-US/Firefox Setup ' + $FirefoxRev + '.exe'
$Setupx32 = 'Firefox-' + $FirefoxRev + '.en-US.win32.installer.exe'
$Setupx64 = 'Firefox-' + $FirefoxRev + '.en-US.win64.installer.exe'

if ($FirefoxRev -gt $Firefox32Ver){
Write-host "Updating Firefox"
	if ($Firefox32){rm $Firefox32}
	if ($Firefox64){rm $Firefox64}
wget $URLx32 -OutFile $Setupx32
wget $URLx64 -OutFile $Setupx64} else {Write-host "Firefox is up to Date"}

# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# =============================================================* Utilities *===================================================================
cd $Default\Apps\Utilities

# Grab the newest Notepad++ Setup

$WebResponse = Invoke-WebRequest https://notepad-plus-plus.org/repository
$NotepadBuild = ($WebResponse.links.innerhtml | Where-Object {$_ -match "x"} | Measure-Object -Maximum).Maximum
$WebResponse2 = Invoke-WebRequest https://notepad-plus-plus.org/repository/$NotepadBuild
$NotepadRev = ($WebResponse2.links.innerhtml | Where-Object {$_ -like "*.*"} | Measure-Object -Maximum).Maximum; $NotepadRev = $NotepadRev.Substring(0,$NotepadRev.length-1)

$URL = 'https://notepad-plus-plus.org/repository/' + $NotepadBuild + '/' + $NotepadRev + '/npp.' + $NotepadRev + '.Installer.exe'
$Setup = 'npp.' + $NotepadRev + '.Installer.exe'

if ($NotepadRev -gt $NotepadVer){
Write-host "Updating Notepad++"
	if ($Notepad){rm $Notepad}
wget $URL -Outfile $Setup} else {Write-host "Notepad++ is up to Date"}

# Grab the newest 7zip Setup

$WebResponse = Invoke-WebRequest http://www.7-zip.org/
$7zipRev = ($WebResponse.Links.InnerText -Match "7-zip [0-9]" | Measure-Object -Maximum).Maximum
$7zipRev = $7zipRev | Where-Object {$_ -Match "[0-9][0-9].[0-9][0-9]"}; $7zipRev = $Matches.0; 
$7ziplnk = $7zipRev.replace(".","")

$URLx32 = 'http://www.7-zip.org/a/7z' + $7ziplnk + '.exe'
$URLx64 = 'http://www.7-zip.org/a/7z' + $7ziplnk + '-x64.exe'
$Setupx32 = '7z' + $7zipRev + '.exe'
$Setupx64 = '7z' + $7zipRev + '-x64.exe'

if ($7zipRev -gt $7zipVer){
Write-host "Updating 7-zip"
	if ($7zip32){rm $7zip32}
	if ($7zip64){rm $7zip64}
wget $URLx32 -OutFile $Setupx32
wget $URLx64 -OutFile $Setupx64} else {Write-host "7-zip is up to Date"}

# Grab the newest CCleaner Setup

$WebResponse = Invoke-WebRequest https://www.piriform.com/ccleaner/download
$CCVer = $WebResponse.RawContent | Where-Object {$_ -match "v[0-9].[0-9][0-9]"} 
$CCRev = $Matches.0; $CCRev = $CCRev.replace("v",""); $CCRev = $CCRev.replace(".","")

$URL = 'http://download.piriform.com/ccsetup' + $CCRev + '.exe'
$Setup = 'ccsetup' + $CCRev + '.exe.'

if ($CCRev -gt $CCleanerVer){
Write-host "Updating CCleaner"
	if ($CCleaner){rm $CCleaner}
wget $URL -OutFile $Setup} else {Write-host "CCleaner is up to Date"}

# Grab the newest Defraggler Setup

$WebResponse = Invoke-WebRequest https://www.piriform.com/defraggler/download
$DefragRev = $WebResponse.RawContent; $DefragRev -match "v[0-9].[0-9][0-9]" | Out-null; $DefragRev = $Matches.0
$DefragRev = $DefragRev.replace("v",""); $DefragRev = $DefragRev.replace(".","")

$URL = 'http://download.piriform.com/dfsetup' + $DefragRev + '.exe'
$Setup = 'dfsetup' + $DefragRev + '.exe'

if ($DefragRev -gt $DefragglerVer){
Write-host "Updating Defraggler"
	if ($Defraggler){rm $Defraggler}
wget $URL -OutFile $Setup} else {Write-host "Defraggler is up to Date"}

# Grab the newest Filezilla Setup

$WebResponse = Invoke-WebRequest https://filezilla-project.org/download.php?show_all=1
$Setupx32 = $WebResponse.Links.InnerText | Where-Object {$_ -match "setup" -and $_ -match "Win32"}
$Setupx64 = $WebResponse.Links.InnerText | Where-Object {$_ -match "setup" -and $_ -match "Win64"}
$Setupx32 -match "[0-9].[0-9][0-9].[0-9]" | Out-null; $FileRev = $Matches.0

$URLx32 = 'http://iweb.dl.sourceforge.net/project/filezilla/FileZilla_Client/' + $FileRev + '/' + $Setupx32
$URLx64 = 'http://iweb.dl.sourceforge.net/project/filezilla/FileZilla_Client/' + $FileRev + '/' + $Setupx64

if ($FileRev -gt $FileZ32Ver){
Write-host "Updating Filezilla"
	if ($FileZ32){rm $FileZ32}
	if ($FileZ64){rm $FileZ64}
wget $URLx32 -OutFile $Setupx32
wget $URLx64 -OutFile $Setupx64} else {Write-host "Filezilla is up to Date"}

# Grab the newest Python Setup

$WebResponse = Invoke-WebRequest https://www.python.org/downloads/
$PythonRev = ($WebResponse.links.InnerText | Where-Object { $_ -match "Python [0-9].[0-9]"} | Measure-Object -Maximum).Maximum
$PythonRev = $PythonRev | Where-Object {$_ -match "[0-9].[0-9].[0-9]"}; $PythonRev = $Matches.0

$URLx32 = 'https://www.python.org/ftp/python/' + $PythonVer + '/python-' + $PythonVer + '.exe'
$URLx64 = 'https://www.python.org/ftp/python/' + $PythonVer + '/python-' + $PythonVer + '-amd64.exe'
$Setupx32 = 'python-' + $PythonVer + '.exe'
$Setupx64 = 'python-' + $PythonVer + '-amd64.exe'

if ($PythonRev -gt $Python32Ver){
Write-host "Updating Python"
	if ($Python32){rm $Python32}
	if ($Python64){rm $Python64}
wget $URLx32 -OutFile $Setupx32
wget $URLx64 -OutFile $Setupx64} else {Write-host "Python is up to Date"}

# Grab the newest Process Explorer

$WebResponse = Invoke-WebRequest https://technet.microsoft.com/en-us/sysinternals/processexplorer.aspx
$ProcRev = $WebResponse.RawContent; $ProcRev -match "v[0-9][0-9].[0-9][0-9]" | Out-null; $ProcRev = $Matches.0; $ProcRev = $ProcRev.replace("v","")

$Setup = 'ProcessExplorer.zip'
$URL = 'https://download.sysinternals.com/files/' + $Setup

if ($ProcRev -gt $ProcessExpVer){
Write-host "Updating Process Explorer"
	if ($ProcessExp){rm $ProcessExp}
wget $URL -OutFile $Setup
	if (Test-path $env:Temp\Process){rm $env:Temp\Process -Recurse}
Unzip $PWD\ProcessExplorer.zip $env:Temp\Process; cp $env:Temp\Process\ProcExp.exe $Default\Apps\Utilities -Force
rm ProcessExplorer.zip} else {Write-host "Process Explorer is up to Date"}

# Grab the newest Autoruns
$WebResponse = Invoke-WebRequest https://technet.microsoft.com/en-us/sysinternals/bb963902.aspx
$AutoRev = $WebResponse.RawContent; $AutoRev -match "v[0-9][0-9].[0-9][0-9]" | Out-null; $AutoRev = $Matches.0; $AutoRev = $AutoRev.replace("v","")

$Setup = 'Autoruns.zip'
$URL = 'https://download.sysinternals.com/files/' + $Setup

if ($AutoRev -gt $AutorunsVer){
Write-host "Updating Autoruns"
	if ($AutoRuns){rm $AutoRuns}
wget $URL -OutFile $Setup
	if (Test-path $env:Temp\AutoRuns){rm $env:Temp\AutoRuns -Recurse}
Unzip $PWD\AutoRuns.Zip $env:Temp\Autoruns; cp $env:Temp\Autoruns\AutoRuns.exe $Default\Apps\Utilities -Force
rm Autoruns.zip} else {Write-host "Autoruns is up to Date"}
# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# ============================================================* WebPlugins *===================================================================
cd $default\Apps\WebPlugins

# Grab the latest JRE	

$WebResponse = Invoke-WebRequest java.com/en/download/manual.jsp
$JavaRev = $WebResponse.RawContent | Where-Object { $_ -match "[0-9] Update [0-9][0-9]"}; $JavaRev = $Matches.0; $JavaRev = $JavaRev.replace(" Update ","u")
$JavaKey32 = ($WebResponse.Links | Where-Object {$_.InnerText -eq "Windows Offline"}).outerhtml; $JavaKey32 -match "[0-9][0-9][0-9][0-9][0-9][0-9]" | Out-null; $JavaKey32 = $Matches.0;
$JavaKey64 = ($WebResponse.Links | Where-Object {$_.InnerText -eq "Windows Offline (64-bit)"}).outerhtml; $JavaKey64 -match "[0-9][0-9][0-9][0-9][0-9][0-9]" | Out-null; $JavaKey64 = $Matches.0;
$JavaRevA = $JavaRev.Substring(0, 1) + '.0.' + $JavaRev.Substring($JavaRev.length - 2, 2)

$URLx32 = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=' + $JavaKey32
$URLx64 = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=' + $JavaKey64
$Setupx32 = 'jre-' + $JavaRev + '-windows-i586.exe'
$Setupx64 = 'jre-' + $JavaRev + '-windows-x64.exe'

if ($JavaRevA -gt $Java32Ver){
Write-host "Updating Java"
	if ($Java32){rm $Java32}
	if ($Java64){rm $Java64}
wget $URLx32 -OutFile $Setupx32
wget $URLx64 -OutFile $Setupx64} else {Write-host "Java is up to Date"}

# Grab the latest Flash Player

$FlashVer = $FlashVer.replace(",",".")
$WebResponse = Invoke-WebRequest https://get.adobe.com/flashplayer/
$FlashRev = $WebResponse.RawContent | Where-Object { $_ -match "Version [0-9][0-9].[0-9].[0-9].[0-9][0-9]"}; $FlashRev = $Matches.0; $FlashRev = $FlashRev.replace("Version ",""); $Flashlnk = $FlashRev.Substring(0, 2)

$URL = 'https://fpdownload.macromedia.com/pub/flashplayer/updaters/' + $Flashlnk + '/flashplayer_' + $Flashlnk + '_plugin_debug.exe'
$Setup = 'flashplayer_' + $Flashlnk + '_plugin_debug.exe'

if ($FlashRev -gt $FlashVer){
Write-host "Updating Flash Player"
	if ($Flash){rm $Flash}
wget $URL -OutFile $Setup} else {Write-host "Flash is up to Date"}
 
 # Return to original directory
cd $default\run