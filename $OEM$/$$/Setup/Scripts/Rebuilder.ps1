# Nova Smart Rebuilder

# Download Function
function Download($URL, $File){
$wc = New-Object System.Net.WebClient
$File = "$PWD\$File"
$wc.DownloadFile($URL, $File)}	

function WebParse($URL){
	$WebResponse = iwr $URL
	$Filter = $WebResponse.ParsedHtml.body.innerText
	$Filter = $Filter.Substring($Filter.IndexOf("Perm"))
	$Filter = $Filter.Substring(0,$Filter.IndexOf("Contact"))
	$TempA = $Filter.Split("`n"); $TempA = $TempA -match "  "

	# Use ArrayList to hold
	$MyArray = New-Object System.Collections.ArrayList
	for($i=0; $i -le $TempA.length; $i++){
		if ($TempA[$i] -ne $null){
			if ($TempA[$i][0] -eq " " -and $TempA[$i][1] -eq " "){$Temp = $TempA[$i].Substring("2")}
			$Temp = $Temp.Split(" ")[0]
			[void]$MyArray.Add($Temp)
		}
	}
	
	return ,$MyArray
}

# Main Folders
$Main=@{}
$Main["Raw"] = 'https://raw.githubusercontent.com/Smorgan05/Nova/Experimental/%24OEM%24/%24%24/Setup/Scripts'
$Main["URL"] = 'https://github.com/Smorgan05/Nova/tree/Experimental/%24OEM%24/%24%24/Setup/Scripts'
$Main["FoldersArray"] = (gci -Directory).Name
$Main["FilesArray"] = (gci -File).Name

# Get the Files inside the Main dir from Github
$Array = WebParse $Main.URL

# Populate Online Main Associate Array
$Main["Folders"] = $Array | Where-Object {$_ -notmatch ".ps1" -and $_ -notmatch ".cmd"}
$Main["Scripts"] = $Array | Where-Object {$_ -match ".ps1"}

# Get the Missing Files and Folders
$Main["MissingScripts"] = Compare-Object $Main.Scripts $Main.FilesArray | ForEach-Object { $_.InputObject} | Where-Object {$_ -match ".ps1"}
if ($Main.FoldersArray){ $Main["MissingFolders"] = Compare-Object $Main.Folders $Main.FoldersArray | ForEach-Object { $_.InputObject} } else {$Main["MissingFolders"] = $Main.Folders}

# Download Missing Scripts for Main Folder
if ($Main.MissingScripts -ne $null){
	for($i=0; $i -le $Main.MissingScripts.Count; $i++){
		$URL = $Main.Raw + '/' + $Main.MissingScripts[$i]
		Download $URL $Main.MissingScripts[$i]
	}
}

# Create Run Folder if Missing
if ($Main.MissingFolders -contains "Run") {mkdir Run | Out-null; cd Run} else {cd Run}  

# Scripts Folder
$Run=@{}
$Run["Raw"] = $Main.Raw + '/Run'
$Run["URL"] = $Main.URL + '/Run' 
$Run["ScriptsArray"] = (gci -File).Name

# Get the Files inside the Run dir from Github
$Run["Scripts"] = WebParse $Run.URL

# Store Missing Scripts in Array
if ($Run.ScriptsArray){
$Run["MissingScripts"] = Compare-Object $Run.Scripts $Run.ScriptsArray | ForEach-Object { $_.InputObject}} else {$Run["MissingScripts"] = $Run.Scripts}

# Download Missing Run Scripts
if ($Run.MissingScripts -ne $null){
	for($i=0; $i -le $Run.MissingScripts.Count; $i++){
		$URL = $Run.Raw + '/' + $Run.MissingScripts[$i]
		Download $URL $Run.MissingScripts[$i]
	}
}

# Get Global Variables Online
. .\GlobalVars.ps1

# Create ExtRun Folder if Missing
cd $Default
if ($Main.MissingFolders -contains "ExtRun") {mkdir ExtRun | Out-null; cd ExtRun} else {cd ExtRun}

#ExtRun Folder
$ExtRun=@{}
$ExtRun["Raw"] = $Main.Raw + '/ExtRun'
$ExtRun["URL"] = $Main.URL + '/ExtRun' 
$ExtRun["ScriptsArray"] = (gci -File).Name

# Get the Files inside the Run dir from Github
$ExtRun["Scripts"] = WebParse $ExtRun.URL

# Store Missing Scripts in Array
if ($ExtRun.ScriptsArray){
$ExtRun["MissingScripts"] = Compare-Object $ExtRun.Scripts $ExtRun.ScriptsArray | ForEach-Object { $_.InputObject}} else {$ExtRun["MissingScripts"] = $ExtRun.Scripts}

# Download Missing ExtRun Scripts
if ($ExtRun.MissingScripts -ne $null){
	for($i=0; $i -le $ExtRun.MissingScripts.Count; $i++){
		$URL = $ExtRun.Raw + '/' + $ExtRun.MissingScripts[$i]
		Download $URL $ExtRun.MissingScripts[$i]
	}
}
	
# Create Prep Folder if Missing
cd $Default
if ($Main.MissingFolders -contains "Prep") {mkdir Prep | Out-null; cd Prep} else {cd Prep}

# Prep Folder
$Prep=@{}
$Prep["Raw"] = $Main.Raw + '/Prep'
$Prep["URL"] = $Main.URL + '/Prep' 
$Prep["FilesArray"] = (gci -File).Name

# Get the Files inside the Prep dir from Github
$Prep["Files"] = WebParse $Prep.URL

# Store Missing Scripts in Array
if ($Prep.FilesArray){
$Prep["MissingFiles"] = Compare-Object $Prep.Files $Prep.FilesArray | ForEach-Object { $_.InputObject}} else {$Prep["MissingFiles"] = $Prep.Files}

# Download Missing Prep Files
if ($Prep.MissingFiles -ne $null){
	for($i=0; $i -le $Prep.MissingFiles.Count; $i++){
		$URL = $Prep.Raw + '/' + $Prep.MissingFiles[$i]
		Download $URL $Prep.MissingFiles[$i]
	}
}

# Create Reg Folder if Missing
cd $Default
if ($Main.MissingFolders -contains "Reg") {mkdir Reg | Out-null; cd Reg} else {cd Reg}

# Reg Folder
$Reg=@{}
$Reg["Raw"] = $Main.Raw + '/Reg'
$Reg["URL"] = $Main.URL + '/Reg' 
$Reg["FoldersArray"] = (gci -Directory).Name

# Get the Files inside the Reg dir from Github
$Reg["Folders"] = WebParse $Reg.URL

# Store Missing Folders in Array
if ($Reg.FoldersArray){
$Reg["MissingFolders"] = Compare-Object $Reg.Folders $Reg.FoldersArray | ForEach-Object { $_.InputObject}} else {$Reg["MissingFolders"] = $Reg.Folders}

# Create Missing Folders
if ($Reg.MissingFolders -ne $null){
	for($i=0; $i -le $Reg.MissingFolders.Count; $i++){
	mkdir $Reg.MissingFolders[$i] | Out-null
	}
}

# Windows Reg Folder
cd $Default\Reg\Windows
$Win = @{}
$Win["Raw"] = $Reg.Raw + '/Windows'
$Win["URL"] = $Reg.URL + '/Windows' 
$Win["FilesArray"] = (gci -File).Name

# Get the Files inside the Windows Reg dir from Github
$Win["Files"] = WebParse $Win.URL

# Store Missing Files in Array
if ($Win.FilesArray){
$Win["MissingFiles"] = Compare-Object $Win.Files $Win.FilesArray | ForEach-Object { $_.InputObject}} else {$Win["MissingFiles"] = $Win.Files}

# Download Missing Prep Files
if ($Win.MissingFiles -ne $null){
	for($i=0; $i -le $Win.MissingFiles.Count; $i++){
		$URL = $Win.Raw + '/' + $Win.MissingFiles[$i]
		Download $URL $Win.MissingFiles[$i]
	}
}

# Tweaks Reg Folder
cd $Default\Reg\Tweaks
$Tweaks = @{}
$Tweaks["Raw"] = $Reg.Raw + '/Tweaks'
$Tweaks["URL"] = $Reg.URL + '/Tweaks' 
$Tweaks["FilesArray"] = (gci -File).Name

# Get the Files inside the Tweaks Reg dir from Github
$Tweaks["Files"] = WebParse $Tweaks.URL

# Store Missing Files in Array
if ($Tweaks.FilesArray){
$Tweaks["MissingFiles"] = Compare-Object $Tweaks.Files $Tweaks.FilesArray | ForEach-Object { $_.InputObject}} else {$Tweaks["MissingFiles"] = $Tweaks.Files}

# Download Missing Prep Files
if ($Tweaks.MissingFiles -ne $null){
	for($i=0; $i -le $Tweaks.MissingFiles.Count; $i++){
		$URL = $Tweaks.Raw + '/' + $Tweaks.MissingFiles[$i]
		Download $URL $Tweaks.MissingFiles[$i]
	}
}

if (($edition -match "Server") -and (($winver -like "6.*") -or ($winver -like "10.*"))){

	# Server Reg Folder
	cd $Default\Reg\Server
	$Serv = @{}
	$Serv["Raw"] = $Reg.Raw + '/Server'
	$Serv["URL"] = $Reg.URL + '/Server' 
	$Serv["FoldersArray"] = (gci -Directory).Name

	# Get the Folders inside the Server dir from Github
	$Serv["Folders"] = WebParse $Serv.URL

	# Store Missing Folders in Array
	if ($Serv.FoldersArray){
	$Serv["MissingFolders"] = Compare-Object $Serv.Folders $Serv.FoldersArray | ForEach-Object { $_.InputObject}} else {$Serv["MissingFolders"] = $Serv.Folders}

	# Create Missing Folders
	if ($Serv.MissingFolders -ne $null){
		for($i=0; $i -le $Serv.MissingFolders.Count; $i++){
		mkdir $Serv.MissingFolders[$i] | Out-null
		}
	}

	# Server 2008 R2
	cd $Default\Reg\Server\Serv2008r2
	$Serv2008 = @{}
	$Serv2008["Raw"] = $Serv.Raw + '/2008r2'
	$Serv2008["URL"] = $Serv.URL + '/2008r2' 
	$Serv2008["FilesArray"] = (gci -File).Name

	# Get the Files inside the Server 2008R2 dir from Github
	$Serv2008["Files"] = WebParse $Serv2008.URL

	# Store Missing Files in Array
	if ($Serv2008.FilesArray){
	$Serv2008["MissingFiles"] = Compare-Object $Serv2008.Files $Serv2008.FilesArray | ForEach-Object { $_.InputObject}} else {$Serv2008["MissingFiles"] = $Serv2008.Files}

	# Download Missing Server 2008R2 Files
	if ($Serv2008.MissingFiles -ne $null){
		for($i=0; $i -le $Serv2008.MissingFiles.Count; $i++){
			$URL = $Serv2008.Raw + '/' + $Serv2008.MissingFiles[$i]
			Download $URL $Serv2008.MissingFiles[$i]
		}
	}

	# Server 2012 R2
	cd $Default\Reg\Server\Serv2012r2
	$Serv2012 = @{}
	$Serv2012["Raw"] = $Serv.Raw + '/2012r2'
	$Serv2012["URL"] = $Serv.URL + '/2012r2' 
	$Serv2012["FilesArray"] = (gci -File).Name

	# Get the Files inside the Server 2012R2 dir from Github
	$Serv2012["Files"] = WebParse $Serv2012.URL

	# Store Missing Files in Array
	if ($Serv2012.FilesArray){
	$Serv2012["MissingFiles"] = Compare-Object $Serv2012.Files $Serv2012.FilesArray | ForEach-Object { $_.InputObject}} else {$Serv2012["MissingFiles"] = $Serv2012.Files}

	# Download Missing Server 2012R2 Files
	if ($Serv2012.MissingFiles -ne $null){
		for($i=0; $i -le $Serv2012.MissingFiles.Count; $i++){
			$URL = $Serv2012.Raw + '/' + $Serv2012.MissingFiles[$i]
			Download $URL $Serv2012.MissingFiles[$i]
		}
	}

	# Server Universal
	cd $Default\Reg\Server\Universal
	$ServUni = @{}
	$ServUni["Raw"] = $Serv.Raw + '/Universal'
	$ServUni["URL"] = $Serv.URL + '/Universal' 
	$ServUni["FilesArray"] = (gci -File).Name

	# Get the Files inside the Server Universal dir from Github
	$ServUni["Files"] = WebParse $ServUni.URL

	# Store Missing Files in Array
	if ($ServUni.FilesArray){
	$ServUni["MissingFiles"] = Compare-Object $ServUni.Files $ServUni.FilesArray | ForEach-Object { $_.InputObject}} else {$ServUni["MissingFiles"] = $ServUni.Files}

	# Download Missing Server Universal Files
	if ($ServUni.MissingFiles -ne $null){
		for($i=0; $i -le $ServUni.MissingFiles.Count; $i++){
			$URL = $ServUni.Raw + '/' + $ServUni.MissingFiles[$i]
			Download $URL $ServUni.MissingFiles[$i]
		}
	}
	
	# Server Folder
	cd $Default
	if ($Main.MissingFolders -contains "Server") {mkdir Server | Out-null; cd Server} else {cd Server}
	
	$Server = @{}
	$Server["Raw"] = $Main.Raw + '/Server'
	$Server["URL"] = $Main.URL + '/Server' 
	$Server["FoldersArray"] = (gci -Directory).Name

	# Get the Folders inside the Server dir from Github
	$Server["Folders"] = WebParse $Server.URL
	
	# Store Missing Folders in Array
	if ($Server.FoldersArray){
	$Server["MissingFolders"] = Compare-Object $Server.Folders $Server.FoldersArray | ForEach-Object { $_.InputObject}} else {$Server["MissingFolders"] = $Server.Folders}
	
	# Create Missing Folders
	if ($Server.MissingFolders -ne $null){
		for($i=0; $i -le $Server.MissingFolders.Count; $i++){
		mkdir $Server.MissingFolders[$i] | Out-null
		}
	}
	
	# Server 2008 R2
	cd $Default\Server\2008r2
	$Server2008 = @{}
	$Server2008["Raw"] = $Server.Raw + '/2008r2'
	$Server2008["URL"] = $Server.URL + '/2008r2' 
	$Server2008["FilesArray"] = (gci -File).Name
	$Server2008["FoldersArray"] = (gci -Directory).Name

	# Get the Files inside the Serverer 2008R2 dir from Github
	$Array = WebParse $Server2008.URL
	$Server2008["Files"] = $Array | Where-Object {$_ -match ".exe"}
	$Server2008["Folders"] = $Array | Where-Object {$_ -notmatch ".exe"}

	# Store Missing Files in Array
	if ($Server2008.FilesArray){
	$Server2008["MissingFiles"] = Compare-Object $Server2008.Files $Server2008.FilesArray | ForEach-Object { $_.InputObject}} else {$Server2008["MissingFiles"] = $Server2008.Files}
	
	# Store Missing Folders in Array
	if ($Server2008.FoldersArray){
	$Server2008["MissingFolders"] = Compare-Object $Server2008.Folders $Server2008.FoldersArray | ForEach-Object { $_.InputObject}} else {$Server2008["MissingFolders"] = $Server2008.Folders}
	
	# Download Missing Server 2008R2 Files
	if ($Server2008.MissingFiles -ne $null){
		for($i=0; $i -le $Server2008.MissingFiles.Count; $i++){
			$URL = $Server2008.Raw + '/' + $Server2008.MissingFiles[$i]
			Download $URL $Server2008.MissingFiles[$i]
		}
	}
	
	# Create Missing Folders
	if ($Server2008.MissingFolders -ne $null){
		for($i=0; $i -le $Server2008.MissingFolders.Count; $i++){
		mkdir $Server2008.MissingFolders[$i] | Out-null
		}
	}
	
	# Server 2008 R2 Apps Sub Folder
	cd $Default\Server\2008r2\Apps
	$Server2008Apps = @{}
	$Server2008Apps["Raw"] = $Server2008.Raw + '/Apps'
	$Server2008Apps["URL"] = $Server2008.URL + '/Apps' 
	$Server2008Apps["FilesArray"] = (gci -File).Name
	
	# Get the Files inside the Serverer 2008R2 dir from Github
	$Server2008Apps["Files"] = WebParse $Server2008Apps.URL
	
	# Store Missing Files in Array
	if ($Server2008Apps.FilesArray){
	$Server2008Apps["MissingFiles"] = Compare-Object $Server2008Apps.Files $Server2008Apps.FilesArray | ForEach-Object { $_.InputObject}} else {$Server2008Apps["MissingFiles"] = $Server2008Apps.Files}
		
	# Download Missing Server 2008R2 Files
	if ($Server2008Apps.MissingFiles -ne $null){
		for($i=0; $i -le $Server2008Apps.MissingFiles.Count; $i++){
			$URL = $Server2008Apps.Raw + '/' + $Server2008Apps.MissingFiles[$i]
			Download $URL $Server2008Apps.MissingFiles[$i]
		}
	}
	
	# Server 2008 R2 Other Sub Folder
	cd $Default\Server\2008r2\Other
	$Server2008Other = @{}
	$Server2008Other["Raw"] = $Server2008.Raw + '/Other'
	$Server2008Other["URL"] = $Server2008.URL + '/Other' 
	$Server2008Other["FilesArray"] = (gci -File).Name
	
	# Get the Files inside the Serverer 2008R2 dir from Github
	$Server2008Other["Files"] = WebParse $Server2008Other.URL
	
	# Store Missing Files in Array
	if ($Server2008Other.FilesArray){
	$Server2008Other["MissingFiles"] = Compare-Object $Server2008Other.Files $Server2008Other.FilesArray | ForEach-Object { $_.InputObject}} else {$Server2008Other["MissingFiles"] = $Server2008Other.Files}
		
	# Download Missing Server 2008R2 Files
	if ($Server2008Other.MissingFiles -ne $null){
		for($i=0; $i -le $Server2008Other.MissingFiles.Count; $i++){
			$URL = $Server2008Other.Raw + '/' + $Server2008Other.MissingFiles[$i]
			Download $URL $Server2008Other.MissingFiles[$i]
		}
	}
	
	# Server 2008 R2 Other Sub Folder
	cd $Default\Server\2008r2\Packs
	$Server2008Packs = @{}
	$Server2008Packs["Raw"] = $Server2008.Raw + '/Packs'
	$Server2008Packs["URL"] = $Server2008.URL + '/Packs' 
	$Server2008Packs["FilesArray"] = (gci -File).Name
	
	# Get the Files inside the Serverer 2008R2 dir from Github
	$Server2008Packs["Files"] = WebParse $Server2008Packs.URL
	
	# Store Missing Files in Array
	if ($Server2008Packs.FilesArray){
	$Server2008Packs["MissingFiles"] = Compare-Object $Server2008Packs.Files $Server2008Packs.FilesArray | ForEach-Object { $_.InputObject}} else {$Server2008Packs["MissingFiles"] = $Server2008Packs.Files}
		
	# Download Missing Server 2008R2 Files
	if ($Server2008Packs.MissingFiles -ne $null){
		for($i=0; $i -le $Server2008Packs.MissingFiles.Count; $i++){
			$URL = $Server2008Packs.Raw + '/' + $Server2008Packs.MissingFiles[$i]
			Download $URL $Server2008Packs.MissingFiles[$i]
		}
	}
	
	# Server 2012 R2
	cd $Default\Server\2012r2
	$Server2012 = @{}
	$Server2012["Raw"] = $Server.Raw + '/2012r2'
	$Server2012["URL"] = $Server.URL + '/2012r2' 
	$Server2012["FilesArray"] = (gci -File).Name

	# Get the Files inside the Serverer 2012 R2 dir from Github
	$Server2012["Files"] = WebParse $Server2012.URL
	
	# Store Missing Files in Array
	if ($Server2012.FilesArray){
	$Server2012["MissingFiles"] = Compare-Object $Server2012.Files $Server2012.FilesArray | ForEach-Object { $_.InputObject}} else {$Server2012["MissingFiles"] = $Server2012.Files}
	
	# Download Missing Server 2012 R2 Files
	if ($Server2012.MissingFiles -ne $null){
		for($i=0; $i -le $Server2012.MissingFiles.Count; $i++){
			$URL = $Server2012.Raw + '/' + $Server2012.MissingFiles[$i]
			Download $URL $Server2012.MissingFiles[$i]
		}
	}

	# Server Universal
	cd $Default\Server\Universal
	$ServerUniversal = @{}
	$ServerUniversal["Raw"] = $Server.Raw + '/Universal'
	$ServerUniversal["URL"] = $Server.URL + '/Universal' 
	$ServerUniversal["FilesArray"] = (gci -File).Name

	# Get the Files inside the Serverer 2012 R2 dir from Github
	$ServerUniversal["Files"] = WebParse $ServerUniversal.URL
	
	# Store Missing Files in Array
	if ($ServerUniversal.FilesArray){
	$ServerUniversal["MissingFiles"] = Compare-Object $ServerUniversal.Files $ServerUniversal.FilesArray | ForEach-Object { $_.InputObject}} else {$ServerUniversal["MissingFiles"] = $ServerUniversal.Files}
	
	# Download Missing Server 2012 R2 Files
	if ($ServerUniversal.MissingFiles -ne $null){
		for($i=0; $i -le $ServerUniversal.MissingFiles.Count; $i++){
			$URL = $ServerUniversal.Raw + '/' + $ServerUniversal.MissingFiles[$i]
			Download $URL $ServerUniversal.MissingFiles[$i]
		}
	}
	
}

# Return to Defaut Directory
cd $Default