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
if (!$Handy){$Handy=@{}}

# Grab the Newest Classic Shell Setup
if (!$Handy.Classic){$Handy["Classic"] = @{}}
if (!$Handy.Classic.Version) {$Handy.Classic.Version = 0}

$WebResponse = Invoke-WebRequest http://www.classicshell.net/downloads/ -UseBasicParsing
$ClassicRev = ($WebResponse.links | Where-Object {$_ -match "English" -and $_ -match "[0-9].[0-9].[0-9]"}  | Measure-Object -Maximum).Maximum; $ClassicLnk = $Matches[0]; $ClassicRev = $ClassicLnk.replace("_",".")
$ClassicRevKey = $WebResponse.links.href | Where-Object {$_ -match "setup" -and $_ -notmatch "-[a-z][a-z]"}
$ClassicRevKey = $ClassicRevKey.Split("/") | Where-Object {$_.length -eq 15 }

$URL = 'http://www.mediafire.com/download/' + $ClassicRevKey + '/ClassicShellSetup_' + $ClassicLnk + '.exe'
$Setup = 'ClassicShellSetup_' + $ClassicLnk + '.exe'

if ($ClassicRev -gt $Handy.Classic.Version){
Write-host "Updating Classic Shell"
	if ($Handy.Classic.Setup) {rm $Handy.Classic.Setup -Force}
Download $URL $Setup; $Count++}

# Grab the Newest MPC-HC Setup
if (!$Handy.MPC){$Handy["MPC"] = @{}}
if (!$Handy.MPC.Version32) {$Handy.MPC.Version32 = 0}
if (!$Handy.MPC.Version64) {$Handy.MPC.Version64 = 0}
$WebResponse = Invoke-WebRequest https://mpc-hc.org/downloads/ -UseBasicParsing
$MPCRev =  ($WebResponse.Links.href | Where-Object {$_ -match "exe"} | Measure-Object -Maximum).Maximum
$MPCRev = $MPCRev.Split("_"); $MPCRev = $MPCRev[1]; $MPCRev = $MPCRev.replace("v","")

$URLx32 = 'https://binaries.mpc-hc.org/MPC HomeCinema - Win32/MPC-HC_v' + $MPCRev + '_x86/MPC-HC.' + $MPCRev + '.x86.exe'
$URLx64 = 'https://binaries.mpc-hc.org/MPC HomeCinema - x64/MPC-HC_v' + $MPCRev + '_x64/MPC-HC.' + $MPCRev + '.x64.exe'
$Setupx32 = 'MPC-HC.' + $MPCRev + '.x86.exe' 
$Setupx64 = 'MPC-HC.' + $MPCRev + '.x64.exe'

if ($MPCRev -gt $Handy.MPC.Version32 -and $arc -eq "32-bit"){
Write-host "Updating Media Player Classic 32 bit"
	if ($Handy.MPC.Setup32) {rm $Handy.MPC.Setup32 -Force} 
Download $URLx32 $Setupx32; $Count++} 

if ($MPCRev -gt $Handy.MPC.Version64 -and $arc -eq "64-bit"){
Write-host "Updating Media Player Classic 64 bit"
	if ($Handy.MPC.Setup64) {rm $Handy.MPC.Setup64 -Force}
Download $URLx64 $Setupx64; $Count++}
 
# Grab the newest Chrome Setup
if (!$Handy.Chrome){$Handy["Chrome"] = @{}}
if (!$Handy.Chrome.Version32){$Handy.Chrome.Version32 = 0}
if (!$Handy.Chrome.Version64){$Handy.Chrome.Version64 = 0}
$WebURL = 'https://www.whatismybrowser.com/guides/the-latest-version/chrome'
$WebResponse = Invoke-WebRequest $WebURL -UseBasicParsing
$ChromeRev = $WebResponse.RawContent | Where-Object {$_ -match "Chrome is: [0-9][0-9].*"}; $ChromeRev = $Matches[0]
$ChromeRev = $ChromeRev.Split(" ")[2]; $ChromeRev = $ChromeRev.Substring(0, $ChromeRev.IndexOf('<'))

$URLx32 = 'https://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=3&usagestats=0&appname=Google Chrome&needsadmin=prefers/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi'
$URLx64 = 'https://dl.google.com/tag/s/appguid={00000000-0000-0000-0000-000000000000}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=4&usagestats=0&appname=Google Chrome&needsadmin=true/dl/chrome/install/googlechromestandaloneenterprise64.msi'
$Setupx32 = 'Chrome ' + $ChromeRev + '.msi'
$Setupx64 = 'Chrome64 '+ $ChromeRev +'.msi'

if ($ChromeRev -ne $Handy.Chrome.Version32 -and $arc -eq "32-bit"){
Write-host "Updating Chrome 32 bit"
	if ($Handy.Chrome.Setup32){rm $Handy.Chrome.Setup32}
Download $URLx32 $Setupx32; $Count++} 

if ($ChromeRev -ne $Handy.Chrome.Version64  -and $arc -eq "64-bit"){
Write-host "Updating Chrome 64 bit"
	if ($Handy.Chrome.Setup64){rm $Handy.Chrome.Setup64}
Download $URLx64 $Setupx64; $Count++} 
 
# Grab the newest Firefox Setup
if (!$Handy.Firefox){$Handy["Firefox"] = @{}}
if (!$Handy.Firefox.Version32){$Handy.Firefox.Version32 = 0}
if (!$Handy.Firefox.Version64){$Handy.Firefox.Version64 = 0}
$WebResponse = Invoke-WebRequest https://ftp.mozilla.org/pub/firefox/releases/ -UseBasicParsing
$FirefoxRevA = ($WebResponse.Links.href | Where-Object {$_ -like "*[0-9][0-9].[0-9]*" -and $_ -notlike "*.[0-9][a-z]*"} | Measure-Object -Maximum).Maximum; $FirefoxRevA = $FirefoxRevA | Where-Object {$_ -match "[0-9][0-9].[0-9]"}; $FirefoxRevA = $Matches[0]
$FirefoxRevB = ($WebResponse.Links.href | Where-Object {$_ -like "*[0-9][0-9].[0-9].[0-9]*" -and $_ -notlike "*.[0-9][a-z]*"} | Measure-Object -Maximum).Maximum; $FirefoxRevB = $FirefoxRevB | Where-Object {$_ -match "[0-9][0-9].[0-9].[0-9]"}; $FirefoxRevB = $Matches[0]

# Set the newest Version to Firefox Rev where A is the newest major build (xx.0) and B is (xx.0.1)
if ($FirefoxRevA -gt $FirefoxRevB){$FirefoxRev = $FirefoxRevA} else {$FirefoxRev = $FirefoxRevB}

$URLx32 = 'https://ftp.mozilla.org/pub/firefox/releases/' + $FirefoxRev + '/win32/en-US/Firefox Setup ' + $FirefoxRev + '.exe'
$URLx64 = 'https://ftp.mozilla.org/pub/firefox/releases/' + $FirefoxRev + '/win64/en-US/Firefox Setup ' + $FirefoxRev + '.exe'
$Setupx32 = 'Firefox-' + $FirefoxRev + '.en-US.win32.installer.exe'
$Setupx64 = 'Firefox-' + $FirefoxRev + '.en-US.win64.installer.exe'

if ($FirefoxRev -gt $Handy.Firefox.Version32 -and $arc -eq "32-bit"){
Write-host "Updating Firefox 32 bit"
	if ($Handy.Firefox.Setup32){rm $Handy.Firefox.Setup32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($FirefoxRev -gt $Handy.Firefox.Version64 -and $arc -eq "64-bit"){
Write-host "Updating Firefox 64 bit"
	if ($Handy.Firefox.Setup64){rm $Handy.Firefox.Setup64 -Force}
Download $URLx64 $Setupx64; $Count++} 

# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# =============================================================* Utilities *===================================================================
if (Test-path $Default\Apps\Utilities){cd $Default\Apps\Utilities} else {mkdir $Default\Apps\Utilities | Out-null; cd $Default\Apps\Utilities}
if (!$Util){$Util = @{}}

# Grab the newest Notepad++ Setup
if (!$Util.Notepad){$Util["Notepad"] = @{}}
if (!$Util.Notepad.Version){$Util.Notepad.Version = 0}
$WebResponse = Invoke-WebRequest https://notepad-plus-plus.org/ -UseBasicParsing
$NotepadRev = $WebResponse.Links.href | Where-Object {$_ -match "[0-9].[0-9]" -or $_ -match "[0-9].[0-9].[0-9]" -and $_ -like "*download*"}
$NotepadRev = $NotepadRev.replace("download/v",""); $NotepadRev = $NotepadRev.replace(".html","")
$NotepadBuild = $NotepadRev.Substring(0,2); $NotepadBuild += "x"

$URL = 'https://notepad-plus-plus.org/repository/' + $NotepadBuild + '/' + $NotepadRev + '/npp.' + $NotepadRev + '.Installer.exe'
$Setup = 'npp.' + $NotepadRev + '.Installer.exe'

if ($NotepadRev -gt $Util.Notepad.Version){
Write-host "Updating Notepad++"
	if ($Util.Notepad.Setup){rm $Util.Notepad.Setup -Force}
Download $URL $Setup; $Count++} 

# Grab the newest 7zip Setup
if (!$Util["7zip"]){$Util["7zip"] = @{}}
if (!$Util["7zip"]["Version32"]){$Util["7zip"]["Version32"] = 0}
if (!$Util["7zip"]["Version64"]){$Util["7zip"]["Version32"] = 0}
$WebResponse = Invoke-WebRequest http://www.7-zip.org/ -UseBasicParsing
$7zipRev = ($WebResponse.RawContent -Match "7-zip [0-9][0-9].[0-9][0-9]" | Measure-Object -Maximum).Maximum; $7zipRev = $Matches[0];
$7zipRev = $7zipRev | Where-Object {$_ -Match "[0-9][0-9].[0-9][0-9]"}; $7zipRev = $Matches[0]; 
$7ziplnk = $7zipRev.replace(".","")

$URLx32 = 'http://www.7-zip.org/a/7z' + $7ziplnk + '.exe'
$URLx64 = 'http://www.7-zip.org/a/7z' + $7ziplnk + '-x64.exe'
$Setupx32 = '7z' + $7zipRev + '.exe'
$Setupx64 = '7z' + $7zipRev + '-x64.exe'

if ($7zipRev -gt $Util["7zip"]["Version32"] -and $arc -eq "32-bit"){
Write-host "Updating 7-zip 32 bit"
	if ($Util["7zip"]["Setup32"]){rm $Util["7zip"]["Setup32"] -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($7zipRev -gt $Util["7zip"]["Version64"] -and $arc -eq "64-bit"){
Write-host "Updating 7-zip 64 bit"
	if ($Util["7zip"]["Setup64"]){rm $Util["7zip"]["Setup64"] -Force}
Download $URLx64 $Setupx64; $Count++} 

# Grab the newest CCleaner Setup
if (!$Util.CCleaner){$Util["CCleaner"] = @{}}
if (!$Util.CCleaner.Version){$Util.CCleaner.Version = 0}
$WebResponse = Invoke-WebRequest https://www.piriform.com/ccleaner/download -UseBasicParsing
$CCVer = $WebResponse.RawContent | Where-Object {$_ -match "v[0-9].[0-9][0-9]"} 
$CCRev = $Matches[0]; $CCRev = $CCRev.replace("v",""); $CCRev = $CCRev.replace(".","")

$URL = 'http://download.piriform.com/ccsetup' + $CCRev + '.exe'
$Setup = 'ccsetup' + $CCRev + '.exe.'

if ($CCRev -gt $Util.CCleaner.Version){
Write-host "Updating CCleaner"
	if ($Util.CCleaner.Setup){rm $Util.CCleaner.Setup -Force}
Download $URL $Setup; $Count++} 

# Grab the newest Defraggler Setup
if (!$Util.Defraggler){$Util["Defraggler"] = @{}}
if (!$Util.Defraggler.Version){$Util.Defraggler.Version = 0}
$WebResponse = Invoke-WebRequest https://www.piriform.com/defraggler/download -UseBasicParsing
$DefragRev = $WebResponse.RawContent; $DefragRev -match "v[0-9].[0-9][0-9]" | Out-null; $DefragRev = $Matches[0]
$DefragRev = $DefragRev.replace("v",""); $DefragRev = $DefragRev.replace(".","")

$URL = 'http://download.piriform.com/dfsetup' + $DefragRev + '.exe'
$Setup = 'dfsetup' + $DefragRev + '.exe'

if ($DefragRev -gt $Util.Defraggler.Version){
Write-host "Updating Defraggler"
	if ($Util.Defraggler.Setup){rm $Util.Defraggler.Setup -Force}
Download $URL $Setup; $Count++} 

# Grab the newest Filezilla Setup
if (!$Util.FileZ){$Util["FileZ"] = @{}}
if (!$Util.FileZ.Version32){$Util.FileZ.Version32 = 0}
if (!$Util.FileZ.Version64){$Util.FileZ.Version64 = 0}
$WebResponse = Invoke-WebRequest https://filezilla-project.org/download.php?show_all=1 -UseBasicParsing
$FileRev = $WebResponse.Links | Where-Object {$_ -match "[0-9].[0-9][0-9].[0-9]*"}; $FileRev = $Matches[0]
$Setupx32 = 'FileZilla_' + $FileRev + '_win32-setup.exe'
$Setupx64 = 'FileZilla_' + $FileRev + '_win64-setup.exe'

$URLx32 = 'https://download.filezilla-project.org/client/' + $Setupx32
$URLx64 = 'https://download.filezilla-project.org/client/' + $Setupx64

if ($FileRev -gt $Util.FileZ.Version32 -and $arc -eq "32-bit"){
Write-host "Updating Filezilla 32 bit"
	if ($Util.FileZ.Setup32){rm $Util.FileZ.Setup32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($FileRev -gt $Util.FileZ.Version64 -and $arc -eq "64-bit"){
Write-host "Updating Filezilla 64 bit"
	if ($Util.FileZ.Setup64){rm $Util.FileZ.Setup64 -Force}
Download $URLx64 $Setupx64; $Count++}

# Grab the newest Python Setup
if (!$Util.Python){$Util["Python"] = @{}}
if (!$Util.Python.Version32){$Util.Python.Version32 = 0}
if (!$Util.Python.Version64){$Util.Python.Version64 = 0}
$WebResponse = Invoke-WebRequest https://www.python.org/downloads/ -UseBasicParsing
$PythonRev = ($WebResponse.RawContent | Where-Object { $_ -match "Python [0-9].[0-9].[0-9]"} | Measure-Object -Maximum).Maximum; $PythonRev = $Matches[0]
$PythonRev = $PythonRev | Where-Object { $_ -match "[0-9].[0-9].[0-9]"}; $PythonRev = $Matches[0]

$URLx32 = 'https://www.python.org/ftp/python/' + $PythonRev + '/python-' + $PythonRev + '.exe'
$URLx64 = 'https://www.python.org/ftp/python/' + $PythonRev + '/python-' + $PythonRev + '-amd64.exe'
$Setupx32 = 'python-' + $PythonRev + '.exe'
$Setupx64 = 'python-' + $PythonRev + '-amd64.exe'

if ($PythonRev -gt $Util.Python.Version32 -and $arc -eq "32-bit"){
Write-host "Updating Python 32 bit"
	if ($Util.Python.Setup32){rm $Util.Python.Setup32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($PythonRev -gt $Util.Python.Version64 -and $arc -eq "64-bit"){
Write-host "Updating Python 64 bit"
	if ($Util.Python.Setup64){rm $Util.Python.Setup64 -Force}
Download $URLx64 $Setupx64; $Count++} 


# Grab the newest Process Explorer
if (!$Util.ProcessExp){$Util["ProcessExp"] = @{}}
if (!$Util.ProcessExp.Version){$Util.ProcessExp.Version = 0}
$WebResponse = Invoke-WebRequest https://technet.microsoft.com/en-us/sysinternals/processexplorer.aspx -UseBasicParsing
$ProcRev = $WebResponse.RawContent; $ProcRev -match "v[0-9][0-9].*" | Out-null; $ProcRev = $Matches[0]; 
$ProcRev = $ProcRev.Substring(0, $ProcRev.IndexOf('<')); $ProcRev = $ProcRev.replace("v","")

$Setup = 'ProcessExplorer.zip'
$URL = 'https://download.sysinternals.com/files/' + $Setup

if ($ProcRev -gt $Util.ProcessExp.Version){
Write-host "Updating Process Explorer"
	if ($Util.ProcessExp.Setup){rm $Util.ProcessExp.Setup -Force}
Download $URL $Setup; $Count++ 

	if (Test-path $env:Temp\Process){rm $env:Temp\Process -Recurse}
Unzip $PWD\ProcessExplorer.zip $env:Temp\Process; cp $env:Temp\Process\ProcExp.exe $Default\Apps\Utilities -Force
rm ProcessExplorer.zip} 

# Grab the newest Autoruns
if (!$Util.AutoRuns){$Util["AutoRuns"] = @{}}
if (!$Util.AutoRuns.Version){$Util.AutoRuns.Version = 0}
$WebResponse = Invoke-WebRequest https://technet.microsoft.com/en-us/sysinternals/bb963902.aspx -UseBasicParsing
$AutoRev = $WebResponse.RawContent; $AutoRev -match "v[0-9][0-9].*" | Out-null; $AutoRev = $Matches[0]; 
$AutoRev = $AutoRev.Substring(0, $AutoRev.IndexOf('<')); $AutoRev = $AutoRev.replace("v","")

$Setup = 'Autoruns.zip'
$URL = 'https://download.sysinternals.com/files/' + $Setup

if ($AutoRev -gt $Util.AutoRuns.Version){
Write-host "Updating Autoruns"
	if ($Util.AutoRuns.Setup){rm $Util.AutoRuns.Setup -Force}
Download $URL $Setup; $Count++ 
	if (Test-path $env:Temp\AutoRuns){rm $env:Temp\AutoRuns -Recurse}
Unzip $PWD\AutoRuns.Zip $env:Temp\Autoruns; cp $env:Temp\Autoruns\AutoRuns.exe $Default\Apps\Utilities -Force
rm Autoruns.zip} 
# ==========================================================* Update the Setups  *=============================================================
# =============================================================================================================================================
# ============================================================* WebPlugins *===================================================================
if (Test-path $Default\Apps\WebPlugins){cd $Default\Apps\WebPlugins} else {mkdir $Default\Apps\WebPlugins | Out-null; cd $Default\Apps\WebPlugins}
if (!$WebPlugins){$WebPlugins = @{}}

# Grab the latest JRE	
if (!$WebPlugins.Java){$WebPlugins["Java"] = @{}}
if (!$WebPlugins.Java.Version32){$WebPlugins.Java.Version32 = 0}
if (!$WebPlugins.Java.Version64){$WebPlugins.Java.Version64 = 0}
$WebResponse = Invoke-WebRequest java.com/en/download/manual.jsp -UseBasicParsing
$JavaBuild = $WebResponse.RawContent | Where-Object { $_ -match "[0-9] Update [0-9][0-9]*"}
$JavaBuild = $Matches[0]; $JavaBuild = $JavaBuild.replace(" Update ","u");
$JavaRev = $JavaBuild.Split("u")[0] + ".0." + $JavaBuild.Split("u")[1] 
$JavaKey = $WebResponse.Links | Where-Object {$_.outerhtml -match "Windows Offline" -and $_.outerhtml -notmatch "(64-bit)"}; $JavaKey = $JavaKey[0].outerHTML
$JavaKey = $JavaKey.Split("/") | Where-Object {$_ -match "AutoDL"}; $JavaKey = $JavaKey.Split("="); $JavaKey = $JavaKey.Split([Environment]::NewLine)[1]
$JavaKey32 = $JavaKey.Substring(0,$JavaKey.Length-2)
[int]$Part1 = $JavaKey32.Split("_")[0]; $Part2 = $JavaKey32.Split("_")[1]; $Part64 = $Part1 + 2
$JavaKey64 = [string]$Part64 + '_' + $Part2
$URLx32 = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=' + $JavaKey32
$URLx64 = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=' + $JavaKey64
$Setupx32 = 'jre-' + $JavaBuild + '-windows-i586.exe'
$Setupx64 = 'jre-' + $JavaBuild + '-windows-x64.exe'

if ($JavaRev -gt $WebPlugins.Java.Version32 -and $arc -eq "32-bit"){
Write-host "Updating Java 32 bit"
	if ($WebPlugins.Java.Setup32){rm $WebPlugins.Java.Setup32 -Force}
Download $URLx32 $Setupx32; $Count++} 

if ($JavaRev -gt $WebPlugins.Java.Version64 -and $arc -eq "64-bit"){
Write-host "Updating Java 64 bit"
	if ($WebPlugins.Java.Setup64){rm $WebPlugins.Java.Setup64 -Force}
Download $URLx64 $Setupx64; $Count++} 

# Grab the latest Flash Player
if (!$WebPlugins.Flash){$WebPlugins["Flash"] = @{}}
if (!$WebPlugins.Flash.Version){$WebPlugins.Flash.Version = 0}
$WebResponse = Invoke-WebRequest https://get.adobe.com/flashplayer/ -UseBasicParsing
$FlashRev = $WebResponse.RawContent | Where-Object { $_ -match "Version [0-9][0-9].[0-9].[0-9].[0-9][0-9]"}; $FlashRev = $Matches[0]; $FlashRev = $FlashRev.replace("Version ",""); $Flashlnk = $FlashRev.Substring(0, 2)

$URL = 'https://fpdownload.macromedia.com/pub/flashplayer/updaters/' + $Flashlnk + '/flashplayer_' + $Flashlnk + '_plugin_debug.exe'
$Setup = 'flashplayer_' + $Flashlnk + '_plugin_debug.exe'

if ($FlashRev -gt $WebPlugins.Flash.Version){
Write-host "Updating Flash Player"
	if ($WebPlugins.Flash.Setup){rm $WebPlugins.Flash.Setup -Force}
Download $URL $Setup; $Count++} 

# Update / Download Report
Write-host
Write-host "Performed" $Count "Downloads or Updates to Setups."
Write-host "Update check done on" (Get-Date).ToString()

 # Return to original directory
cd $default\run