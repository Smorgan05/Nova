$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Firefox Silent Addons

# Load up Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\GlobalVars.ps1

# Function Download File
function Download($URL, $Setup){
$wc = New-Object System.Net.WebClient
$Setup = "$PWD\$Setup"
$wc.DownloadFile($URL, $Setup)}	

# Set Version Grab Function
function BrowserVer($AddVer){
$Temp = $AddVer -match "[0-9].*"; $Temp = $Matches[0]
$End = $Temp.IndexOf("-")
$Final = $Temp.Substring(0,$End)
Return $Final}

# Set Extension Id Grabber Function
function ExtID($XPI){
7z e $XPI *.rdf -r -y > $null
$xml = [xml](gc .\install.rdf)
$ID = $xml.RDF.ChildNodes.id
rm .\install.rdf
Return $ID}

# Flip to Addons Directory
if (Test-path $Default\Apps\BrowserAddons){cd $Default\Apps\BrowserAddons} else {mkdir $Default\Apps\BrowserAddons | Out-null; cd $Default\Apps\BrowserAddons}

# Define Browser Array
$BrowserArray = ls -name

# Define Hash Table (Offline)
$Firefox=@{}
$Firefox["Adblock"] = @{}
$Firefox["Nimbus"] = @{}
$Firefox["TabMix"] = @{}

# Set Variables for Browser Addons
for($i=0; $i -le $BrowserArray.length; $i++){
	if ($BrowserArray[$i] -match 'Adblock'){ $Firefox.Adblock.Setup = $BrowserArray[$i]; $Firefox.Adblock.Version = BrowserVer $Firefox.Adblock.Setup}
	if ($BrowserArray[$i] -match 'Nimbus'){ $Firefox.Nimbus.Setup = $BrowserArray[$i]; $Firefox.Nimbus.Verison = BrowserVer $Firefox.Nimbus.Setup}
	if ($BrowserArray[$i] -match 'tab_mix'){ $Firefox.TabMix.Setup = $BrowserArray[$i]; $Firefox.TabMix.Version = BrowserVer $Firefox.TabMix.Setup}
}

# Adblock plus
$WebResponse = Invoke-WebRequest 'https://addons.mozilla.org/en-US/firefox/addon/adblock-plus' -UseBasicParsing
$Adblock = ($WebResponse.Links | Where-Object {$_ -match "version"})[1].OuterHtml
$AdblockRev = $Adblock -match "[0-9].*"; $AdblockRev = $Matches[0]; $AdblockRev = $AdblockRev.Substring(0,$AdblockRev.Length-1)
$URL = 'https://addons.mozilla.org/firefox/downloads/latest/adblock-plus'
$Setup = 'adblock_plus-' + $AdblockRev + '-an+fx+sm+tb.xpi'

if (!$Firefox.Adblock.Setup) {$Firefox.Adblock.Version = 0}
if ($AdblockRev -gt $Firefox.Adblock.Version){
	if ($Firefox.Adblock.Setup) {rm $Firefox.Adblock.Setup}
Download $URL $Setup}

# Nimbus
$WebResponse = Invoke-WebRequest 'https://addons.mozilla.org/en-US/firefox/addon/nimbus-screenshot' -UseBasicParsing
$Nimbus = ($WebResponse.Links | Where-Object {$_ -match "version"})[0].OuterHtml
$NimbusRev = $Nimbus -match "[0-9].*"; $NimbusRev = $Matches[0]; $NimbusRev = $NimbusRev.Substring(0,$NimbusRev.Length-1)
$URL = 'https://addons.mozilla.org/firefox/downloads/latest/nimbus-screenshot'
$Setup = 'nimbus_screen_capture_editable_screenshots-' + $NimbusRev + '-fx.xpi'

if (!$Firefox.Nimbus.Setup) {$Firefox.Nimbus.Version = 0}
if ($NimbusRev -gt $Firefox.Nimbus.Version){
	if ($Firefox.Nimbus.Setup) {rm $Firefox.Nimbus.Setup}
Download $URL $Setup}

# Tab Mix Plus
$WebResponse = Invoke-WebRequest 'https://addons.mozilla.org/en-US/firefox/addon/tab-mix-plus' -UseBasicParsing
$TabMix = ($WebResponse.Links | Where-Object {$_ -match "version"})[2].OuterHtml
$TabMixRev = $TabMix -match "[0-9].*"; $TabMixRev = $Matches[0]; $TabMixRev = $TabMixRev.Substring(0,$TabMixRev.Length-1)
$URL = 'https://addons.mozilla.org/firefox/downloads/latest/tab-mix-plus'
$Setup = 'tab_mix_plus-' + $TabMixRev + '-fx.xpi'

if (!$Firefox.TabMix.Setup) {$Firefox.TabMix.Version = 0}
if ($TabMixRev -gt $Firefox.TabMix.Version){
	if ($Firefox.TabMix.Setup) {rm $Firefox.TabMix.Setup}
Download $URL $Setup}

# Extract the Extension ID
$Firefox.Adblock.ExtID = ExtID $Firefox.Adblock.Setup
$Firefox.Nimbus.ExtID = ExtID $Firefox.Nimbus.Setup
$Firefox.TabMix.ExtID = ExtID $Firefox.TabMix.Setup

# Get the Profile
$Profile = (ls $env:appdata\mozilla\firefox\profiles).Name | Where-Object {$_ -like "*default"}
$Extensions = $env:appdata + "\mozilla\firefox\profiles\" + $Profile + "\extensions"

# Copy Extensions into Place
cp $Firefox.Adblock.Setup $Extensions
cp $Firefox.Nimbus.Setup $Extensions
cp $Firefox.TabMix.Setup $Extensions

# Rename to proper Extension
cd $Extensions
ren $Firefox.Adblock.Setup $Firefox.Adblock.ExtID
ren $Firefox.Nimbus.Setup $Firefox.Nimbus.ExtID
ren $Firefox.TabMix.Setup $Firefox.TabMix.ExtID



