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

# Function Download File
function Download($URL, $Setup){
$wc = New-Object System.Net.WebClient
$Setup = "$PWD\$Setup"
$wc.DownloadFile($URL, $Setup)}	

# Update Download Counter
$Count = 0

# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# ===============================================================* Handy *=====================================================================
if (Test-path $Default\Apps\Handy){cd $Default\Apps\Handy} else {mkdir $Default\Apps\Handy | Out-null; cd $Default\Apps\Handy}

# Grab the Newest Classic Shell Setup

if (!$ClassicVer) {$CCleanerVer = 0} else {$ClassicVer = $ClassicVer.replace(", ",".")}
$WebResponse = Invoke-WebRequest http://www.classicshell.net/downloads/ -UseBasicParsing
$ClassicRev = ($WebResponse.links | Where-Object {$_ -match "English" -and $_ -match "[0-9].[0-9].[0-9]"}  | Measure-Object -Maximum).Maximum; $ClassicLnk = $Matches[0]; $ClassicRev = $ClassicLnk.replace("_",".")
$ClassicRevKey = $WebResponse.links.href | Where-Object {$_ -match "setup" -and $_ -notmatch "-[a-z][a-z]"}
$ClassicRevKey = $ClassicRevKey.Split("/") | Where-Object {$_.length -eq 15 }

$URL = 'http://www.mediafire.com/download/' + $ClassicRevKey + '/ClassicShellSetup_' + $ClassicLnk + '.exe'
$Setup = 'ClassicShellSetup_' + $ClassicLnk + '.exe'

if ($ClassicRev -gt $ClassicVer){
Write-host "Updating Classic Shell"
	if ($Classic) {rm $Classic -Force}
Download $URL $Setup; $Count++}

# Grab the Newest MPC-HC Setup

if (!$MPC32Ver) {$MPC32Ver = 0}
if (!$MPC64Ver) {$MPC64Ver = 0}
$WebResponse = Invoke-WebRequest https://mpc-hc.org/downloads/ -UseBasicParsing
$MPCRev =  ($WebResponse.Links.href | Where-Object {$_ -match "exe"} | Measure-Object -Maximum).Maximum
$MPCRev = $MPCRev.Split("_"); $MPCRev = $MPCRev[1]; $MPCRev = $MPCRev.replace("v","")

$URLx32 = 'https://binaries.mpc-hc.org/MPC HomeCinema - Win32/MPC-HC_v' + $MPCRev + '_x86/MPC-HC.' + $MPCRev + '.x86.exe'
$URLx64 = 'https://binaries.mpc-hc.org/MPC HomeCinema - x64/MPC-HC_v' + $MPCRev + '_x64/MPC-HC.' + $MPCRev + '.x64.exe'
$Setupx32 = 'MPC-HC.' + $MPCRev + '.x86.exe' 
$Setupx64 = 'MPC-HC.' + $MPCRev + '.x64.exe'

if ($MPCRev -gt $MPC32Ver){
Write-host "Updating Media Player Classic 32 bit"
	if ($MPC32) {rm $MPC32 -Force} 
Download $URLx32 $Setupx32; $Count++} 

if ($MPCRev -gt $MPC64Ver){
Write-host "Updating Media Player Classic 64 bit"
	if ($MPC64) {rm $MPC64 -Force}
Download $URLx64 $Setupx64; $Count++}
 
# Grab the newest Chrome Setup

if (!$Chrome32Ver){$Chrome32Ver = 0}
if (!$Chrome64Ver){$Chrome64Ver = 0}
$WebURL = 'https://www.whatismybrowser.com/guides/the-latest-version/chrome'
$WebResponse = Invoke-WebRequest $WebURL -UseBasicParsing
$ChromeRev = $WebResponse.RawContent | Where-Object {$_ -match "Chrome is: [0-9][0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9]*"};
$ChromeRev = $Matches[0]; $ChromeRev = $ChromeRev | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9]*"}; $ChromeRev = $Matches[0];

$URLx32 = 'https://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=3&usagestats=0&appname=Google Chrome&needsadmin=prefers/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi'
$URLx64 = 'https://dl.google.com/tag/s/appguid={00000000-0000-0000-0000-000000000000}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=4&usagestats=0&appname=Google Chrome&needsadmin=true/dl/chrome/install/googlechromestandaloneenterprise64.msi'
$Setupx32 = 'Chrome ' + $ChromeRev + '.msi'
$Setupx64 = 'Chrome64 '+ $ChromeRev +'.msi'

if ($ChromeRev -ne $Chrome32Ver){
Write-host "Updating Chrome 32 bit"
	if ($Chrome32){rm $Chrome32}
Download $URLx32 $Setupx32; $Count++} 

if ($ChromeRev -ne $Chrome64Ver){
Write-host "Updating Chrome 64 bit"
	if ($Chrome64){rm $Chrome64}
Download $URLx64 $Setupx64; $Count++} 
 
# Grab the newest Firefox Setup

if (!$Firefox32Ver){$Firefox32Ver = 0}
if (!$Firefox64Ver){$Firefox64Ver = 0}
$WebResponse = Invoke-WebRequest https://ftp.mozilla.org/pub/firefox/releases/ -UseBasicParsing
$FirefoxRev = ($WebResponse.Links.href | Where-Object {$_ -like "*[0-9][0-9].[0-9].[0-9]*" -and $_ -notlike "*.[0-9][a-z]*"} | Measure-Object -Maximum).Maximum
$FirefoxRev = $FirefoxRev | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9]"}; $FirefoxRev = $Matches[0]

$URLx32 = 'https://ftp.mozilla.org/pub/firefox/releases/' + $FirefoxRev + '/win32/en-US/Firefox Setup ' + $FirefoxRev + '.exe'
$URLx64 = 'https://ftp.mozilla.org/pub/firefox/releases/' + $FirefoxRev + '/win64/en-US/Firefox Setup ' + $FirefoxRev + '.exe'
$Setupx32 = 'Firefox-' + $FirefoxRev + '.en-US.win32.installer.exe'
$Setupx64 = 'Firefox-' + $FirefoxRev + '.en-US.win64.installer.exe'

if ($FirefoxRev -gt $Firefox32Ver){
Write-host "Updating Firefox 32 bit"
	if ($Firefox32){rm $Firefox32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($FirefoxRev -gt $Firefox64Ver){
Write-host "Updating Firefox 64 bit"
	if ($Firefox64){rm $Firefox64 -Force}
Download $URLx64 $Setupx64; $Count++} 

# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# =============================================================* Utilities *===================================================================
if (Test-path $Default\Apps\Utilities){cd $Default\Apps\Utilities} else {mkdir $Default\Apps\Utilities | Out-null; cd $Default\Apps\Utilities}

# Grab the newest Notepad++ Setup

if (!$NotepadVer){$NotepadVer = 0}
$WebResponse = Invoke-WebRequest https://notepad-plus-plus.org/repository -UseBasicParsing
$NotepadBuild = ($WebResponse.links | Where-Object {$_ -match "[0-9].x"} | Measure-Object -Maximum).Maximum; $NotepadBuild = $Matches[0]
$WebResponse2 = Invoke-WebRequest https://notepad-plus-plus.org/repository/$NotepadBuild -UseBasicParsing
$NotepadRevA = ($WebResponse2.links | Where-Object {$_ -match "[0-9].[0-9]"} | Measure-Object -Maximum).Maximum; $NotepadRevA = $Matches[0]
$NotepadRevB = ($WebResponse2.links | Where-Object {$_ -match "[0-9].[0-9].[0-9]"} | Measure-Object -Maximum).Maximum; $NotepadRevA = $Matches[0]

if ($NotepadRevA -gt $NotepadRevB){$NotepadRev = $NotepadRevA} else {$NotepadRev = $NotepadRevB}

$URL = 'https://notepad-plus-plus.org/repository/' + $NotepadBuild + '/' + $NotepadRev + '/npp.' + $NotepadRev + '.Installer.exe'
$Setup = 'npp.' + $NotepadRev + '.Installer.exe'

if ($NotepadRev -gt $NotepadVer){
Write-host "Updating Notepad++"
	if ($Notepad){rm $Notepad -Force}
Download $URL $Setup; $Count++} 

# Grab the newest 7zip Setup

if (!$7zip32Ver){$7zip32Ver = 0}
if (!$7zip64Ver){$7zip64Ver = 0}
$WebResponse = Invoke-WebRequest http://www.7-zip.org/ -UseBasicParsing
$7zipRev = ($WebResponse.RawContent -Match "7-zip [0-9][0-9].[0-9][0-9]" | Measure-Object -Maximum).Maximum; $7zipRev = $Matches[0];
$7zipRev = $7zipRev | Where-Object {$_ -Match "[0-9][0-9].[0-9][0-9]"}; $7zipRev = $Matches[0]; 
$7ziplnk = $7zipRev.replace(".","")

$URLx32 = 'http://www.7-zip.org/a/7z' + $7ziplnk + '.exe'
$URLx64 = 'http://www.7-zip.org/a/7z' + $7ziplnk + '-x64.exe'
$Setupx32 = '7z' + $7zipRev + '.exe'
$Setupx64 = '7z' + $7zipRev + '-x64.exe'

if ($7zipRev -gt $7zip32Ver){
Write-host "Updating 7-zip 32 bit"
	if ($7zip32){rm $7zip32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($7zipRev -gt $7zip64Ver){
Write-host "Updating 7-zip 64 bit"
	if ($7zip64){rm $7zip64 -Force}
Download $URLx64 $Setupx64; $Count++} 

# Grab the newest CCleaner Setup

if (!$CCleanerVer){$CCleanerVer = 0}
$WebResponse = Invoke-WebRequest https://www.piriform.com/ccleaner/download -UseBasicParsing
$CCVer = $WebResponse.RawContent | Where-Object {$_ -match "v[0-9].[0-9][0-9]"} 
$CCRev = $Matches[0]; $CCRev = $CCRev.replace("v",""); $CCRev = $CCRev.replace(".","")

$URL = 'http://download.piriform.com/ccsetup' + $CCRev + '.exe'
$Setup = 'ccsetup' + $CCRev + '.exe.'

if ($CCRev -gt $CCleanerVer){
Write-host "Updating CCleaner"
	if ($CCleaner){rm $CCleaner -Force}
Download $URL $Setup; $Count++} 

# Grab the newest Defraggler Setup

if (!$DefragglerVer){$DefragglerVer = 0}
$WebResponse = Invoke-WebRequest https://www.piriform.com/defraggler/download -UseBasicParsing
$DefragRev = $WebResponse.RawContent; $DefragRev -match "v[0-9].[0-9][0-9]" | Out-null; $DefragRev = $Matches[0]
$DefragRev = $DefragRev.replace("v",""); $DefragRev = $DefragRev.replace(".","")

$URL = 'http://download.piriform.com/dfsetup' + $DefragRev + '.exe'
$Setup = 'dfsetup' + $DefragRev + '.exe'

if ($DefragRev -gt $DefragglerVer){
Write-host "Updating Defraggler"
	if ($Defraggler){rm $Defraggler -Force}
Download $URL $Setup; $Count++} 

# Grab the newest Filezilla Setup

if (!$FileZ32Ver){$FileZ32Ver = 0}
if (!$FileZ64Ver){$FileZ64Ver = 0}
$WebResponse = Invoke-WebRequest https://filezilla-project.org/download.php?show_all=1 -UseBasicParsing
$FileRev = $WebResponse.Links | Where-Object {$_ -match "[0-9].[0-9][0-9].[0-9]*"}; $FileRev = $Matches[0]
$Setupx32 = 'FileZilla_' + $FileRev + '_win32-setup.exe'
$Setupx64 = 'FileZilla_' + $FileRev + '_win64-setup.exe'

$URLx32 = 'http://iweb.dl.sourceforge.net/project/filezilla/FileZilla_Client/' + $FileRev + '/' + $Setupx32
$URLx64 = 'http://iweb.dl.sourceforge.net/project/filezilla/FileZilla_Client/' + $FileRev + '/' + $Setupx64

if ($FileRev -gt $FileZ32Ver){
Write-host "Updating Filezilla 32 bit"
	if ($FileZ32){rm $FileZ32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($FileRev -gt $FileZ64Ver){
Write-host "Updating Filezilla 64 bit"
	if ($FileZ64){rm $FileZ64 -Force}
Download $URLx64 $Setupx64; $Count++}

# Grab the newest Python Setup

if (!$Python32Ver){$Python32Ver = 0}
if (!$Python64Ver){$Python64Ver = 0}
$WebResponse = Invoke-WebRequest https://www.python.org/downloads/ -UseBasicParsing
$PythonRev = ($WebResponse.RawContent | Where-Object { $_ -match "Python [0-9].[0-9].[0-9]"} | Measure-Object -Maximum).Maximum; $PythonRev = $Matches[0]
$PythonRev = $PythonRev | Where-Object { $_ -match "[0-9].[0-9].[0-9]"}; $PythonRev = $Matches[0]

$URLx32 = 'https://www.python.org/ftp/python/' + $PythonRev + '/python-' + $PythonRev + '.exe'
$URLx64 = 'https://www.python.org/ftp/python/' + $PythonRev + '/python-' + $PythonRev + '-amd64.exe'
$Setupx32 = 'python-' + $PythonRev + '.exe'
$Setupx64 = 'python-' + $PythonRev + '-amd64.exe'

if ($PythonRev -gt $Python32Ver){
Write-host "Updating Python 32 bit"
	if ($Python32){rm $Python32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($PythonRev -gt $Python64Ver){
Write-host "Updating Python 64 bit"
	if ($Python64){rm $Python64 -Force}
Download $URLx64 $Setupx64; $Count++} 


# Grab the newest Process Explorer

if (!$ProcessExpVer){$ProcessExpVer = 0}
$WebResponse = Invoke-WebRequest https://technet.microsoft.com/en-us/sysinternals/processexplorer.aspx -UseBasicParsing
$ProcRev = $WebResponse.RawContent; $ProcRev -match "v[0-9][0-9].[0-9][0-9]" | Out-null; $ProcRev = $Matches[0]; $ProcRev = $ProcRev.replace("v","")

$Setup = 'ProcessExplorer.zip'
$URL = 'https://download.sysinternals.com/files/' + $Setup

if ($ProcRev -gt $ProcessExpVer){
Write-host "Updating Process Explorer"
	if ($ProcessExp){rm $ProcessExp -Force}
Download $URL $Setup; $Count++ 
	if (Test-path $env:Temp\Process){rm $env:Temp\Process -Recurse}
Unzip $PWD\ProcessExplorer.zip $env:Temp\Process; cp $env:Temp\Process\ProcExp.exe $Default\Apps\Utilities -Force
rm ProcessExplorer.zip} 

# Grab the newest Autoruns
if (!$AutorunsVer){$AutorunsVer = 0}
$WebResponse = Invoke-WebRequest https://technet.microsoft.com/en-us/sysinternals/bb963902.aspx -UseBasicParsing
$AutoRev = $WebResponse.RawContent; $AutoRev -match "v[0-9][0-9].[0-9][0-9]" | Out-null; $AutoRev = $Matches[0]; $AutoRev = $AutoRev.replace("v","")

$Setup = 'Autoruns.zip'
$URL = 'https://download.sysinternals.com/files/' + $Setup

if ($AutoRev -gt $AutorunsVer){
Write-host "Updating Autoruns"
	if ($AutoRuns){rm $AutoRuns -Force}
Download $URL $Setup; $Count++ 
	if (Test-path $env:Temp\AutoRuns){rm $env:Temp\AutoRuns -Recurse}
Unzip $PWD\AutoRuns.Zip $env:Temp\Autoruns; cp $env:Temp\Autoruns\AutoRuns.exe $Default\Apps\Utilities -Force
rm Autoruns.zip} 
# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# ============================================================* WebPlugins *===================================================================
if (Test-path $Default\Apps\WebPlugins){cd $Default\Apps\WebPlugins} else {mkdir $Default\Apps\WebPlugins | Out-null; cd $Default\Apps\WebPlugins}

# Grab the latest JRE	

if (!$Java32Ver){$Java32Ver = 0}
if (!$Java64Ver){$Java64Ver = 0}
$WebResponse = Invoke-WebRequest java.com/en/download/manual.jsp -UseBasicParsing
$JavaRev = $WebResponse.RawContent | Where-Object { $_ -match "[0-9] Update [0-9][0-9]"}; $JavaRev = $Matches[0]; $JavaRev = $JavaRev.replace(" Update ","u")
$JavaKey32 = $WebResponse.Links | Where-Object {$_.outerhtml -match "Windows Offline" -and $_.outerhtml -notmatch "(64-bit)"}
$JavaKey32 = $JavaKey32 | Where-Object {$_.outerhtml -match "[0-9][0-9][0-9][0-9][0-9][0-9]"}; $JavaKey32 = $Matches[0]
$JavaKey64 = $WebResponse.Links | Where-Object {$_.outerhtml -match "Windows Offline" -and $_.outerhtml -match "(64-bit)"}
$JavaKey64 = $JavaKey64 | Where-Object {$_.outerhtml -match "[0-9][0-9][0-9][0-9][0-9][0-9]"}; $JavaKey64 = $Matches[0]
$JavaRevA = $JavaRev.Substring(0, 1) + '.0.' + $JavaRev.Substring($JavaRev.length - 2, 2)

$URLx32 = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=' + $JavaKey32
$URLx64 = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=' + $JavaKey64
$Setupx32 = 'jre-' + $JavaRev + '-windows-i586.exe'
$Setupx64 = 'jre-' + $JavaRev + '-windows-x64.exe'

if ($JavaRevA -gt $Java32Ver){
Write-host "Updating Java 32 bit"
	if ($Java32){rm $Java32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($JavaRevA -gt $Java64Ver){
Write-host "Updating Java 64 bit"
	if ($Java64){rm $Java64 -Force}
Download $URLx64 $Setupx64; $Count++} 

# Grab the latest Flash Player

if (!$FlashVer){$FlashVer = 0} else {$FlashVer = $FlashVer.replace(",",".")}
$WebResponse = Invoke-WebRequest https://get.adobe.com/flashplayer/ -UseBasicParsing
$FlashRev = $WebResponse.RawContent | Where-Object { $_ -match "Version [0-9][0-9].[0-9].[0-9].[0-9][0-9]"}; $FlashRev = $Matches[0]; $FlashRev = $FlashRev.replace("Version ",""); $Flashlnk = $FlashRev.Substring(0, 2)

$URL = 'https://fpdownload.macromedia.com/pub/flashplayer/updaters/' + $Flashlnk + '/flashplayer_' + $Flashlnk + '_plugin_debug.exe'
$Setup = 'flashplayer_' + $Flashlnk + '_plugin_debug.exe'

if ($FlashRev -gt $FlashVer){
Write-host "Updating Flash Player"
	if ($Flash){rm $Flash -Force}
Download $URL $Setup; $Count++} 

# Update / Download Report
Write-host
Write-host "Performed" $Count "Downloads or Updates to Setups."
Write-host "Update check done on" (Get-Date).ToString()

 # Return to original directory
cd $default\run