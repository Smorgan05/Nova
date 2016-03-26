function Measure-DownloadSpeed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Please enter a URL to download.")]
        [string] $Url
        ,
        [Parameter(Mandatory = $true, HelpMessage = "Please enter a target path to download to.")]
        [string] $Path
    )

    function Get-ContentLength {
        [CmdletBinding()]
        param (
            [string] $Url
        )

        $Req = [System.Net.HttpWebRequest]::CreateHttp($Url);
        $Req.Method = 'HEAD';
        $Req.Proxy = $null;
        $Response = $Req.GetResponse();
        #Write-Output -InputObject $Response.ContentLength;
        Write-Output -InputObject $Response;
    }

    $FileSize = (Get-ContentLength -Url $Url).ContentLength;

    if (!$FileSize) {
    throw 'Download URL is invalid!';
    }

    # Resolve the fully qualified path to the target file on the filesystem
    # $Path = Resolve-Path -Path $Path;

    if (Test-Path -Path $Path) {
    # throw ('File already exists: {0}' -f $Path);
    }

    # Instantiate a System.Net.WebClient object
    $wc = New-Object System.Net.WebClient;

    # Invoke asynchronous download of the URL specified in the -Url parameter
    $wc.DownloadFileAsync($Url, $Path);

    # While the WebClient object is busy, continue calculating the download rate.
    # This could potentially be broken off into its own function, but hey there's procrastination for that.
    while ($wc.IsBusy) {
    # Get the current time & file size
    #$OldSize = (Get-Item -Path $TargetPath).Length;
    $OldSize = (New-Object -TypeName System.IO.FileInfo -ArgumentList $Path).Length;
    $OldTime = Get-Date;

    # Wait a second
    Start-Sleep -Seconds 1;

    # Get the new time & file size
    $NewSize = (New-Object -TypeName System.IO.FileInfo -ArgumentList $Path).Length;
    $NewTime = Get-Date;

    # Calculate time difference and file size.
    $SizeDiff = $NewSize - $OldSize;
    $TimeDiff = $NewTime - $OldTime;

    # Recalculate download rate based off of actual time difference since
    # we can't assume precisely 1 second time difference due to file IO.
    $UpdatedSize = $SizeDiff / $TimeDiff.TotalSeconds;

    # Write-Host -Object $TimeDiff.TotalSeconds, $SizeDiff, $UpdatedSize;

    Write-Host -Object ("Download speed is: {0:N2}MB/sec" -f ($UpdatedSize/1MB));

    }
}

Measure-DownloadSpeed -Url http://dl.google.com/android/installer_r20.0.1-windows.exe -Path ('{0}\{1}' -f $env:TEMP, 'installer_r20.0.1-windows.exe');