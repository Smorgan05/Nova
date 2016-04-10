$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
# Setup Updater to facilitate easy update of Setup Files

# Load Variables
if (Test-path "$env:windir\Setup\Scripts"){cd $env:windir\Setup\Scripts\Run} else {cd $ScriptDir}
. .\InstallRec.ps1

# ===========================* Perform Speed Check *===============================
cd $default\ExtRun

#Check for Speed Exectuables
if (!(Test-path report.txt) -and ($Speed32 -and $Speed64)){

	if ($arc -eq "64-bit"){
	. .\$Speed64 > report.txt
	} else {
	. .\$Speed32 > report.txt
	}

}

if (Test-path report.txt){ 

$Report = [IO.File]::ReadAllText("$PWD\report.txt")
$Speed = ($report -match "[0-9][0-9][0-9].[0-9][0-9] Mbps" -or $report -match "[0-9][0-9].[0-9][0-9] Mbps" -or $report -match "[0-9].[0-9][0-9] Mbps")
$Speed = $Matches[0]; $Speed = $Speed.Substring(0,$Speed.Length-4)

}

# Return to original directory
cd $default\run