@echo off
:: Setupcomplete with PS 4.0 Install for Windows 7 \ Server 2008 R2

:: Check for Internet
Ping www.google.nl -n 1 -w 1000
if errorlevel 1 (goto NrmRun) else (goto IntRun)

:: Execute Smart Rebuild
:IntRun
powershell if (Test-Path Rebuilder.ps1){. .\Rebuilder.ps1} else {iwr https://raw.githubusercontent.com/Smorgan05/Nova/Experimental/%24OEM%24/%24%24/Setup/Scripts/Rebuilder.ps1 -OutFile Rebuilder.ps1}
PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "Rebuilder.ps1"

:: Grab the Windows Version
:NrmRun
For /f "tokens=4,5,6 delims=. " %%G in ('ver') Do (set _major=%%G& set _minor=%%H)
set version=%_major%.%_minor%

:: Powershell Check
regedit /s "%windir%\Setup\scripts\Reg\Windows\disable_uac.reg"

:: Insert starter.bat into startup via RunOnce / Go
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Starter" /t REG_SZ /d "C:\windows\setup\scripts\SetupComplete.cmd" /f
if exist "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" (goto regInst) ELSE (exit)
:: -----------------------------------------------------------------------------------------

:regInst

:: Grab Powershell Version information
FOR /F "usebackq delims=" %%v IN (`powershell -noprofile "& { $PSVersionTable.CLRVersion.Major }"`) DO set "psver=%%v"
set psver

:: Flip over to Upgrade to Powershell 4.0
if "%psver%"=="2" if "%version%"=="6.1" (goto win7)

:: Execute Powershell Setup
cd %windir%\setup\scripts
PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "Setup.ps1"
goto Finish

:: -----------------------------------------------------------------------------------------

:win7
:: Install .net 4.5.2
cd %windir%\setup\scripts\Prep
start /w NDP461-KB3102436-x86-x64-AllOS-ENU.exe /q /norestart

MD "%systemdrive%\2819745"
IF /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" (goto win7x64) ELSE (goto win7x32)

:: -----------------------------------------------------------------------------------------

:win7x32
:: Start update for 7 x86 - Powershell 4.0
Expand –F:* "Windows6.1-KB2819745-x86-MultiPkg.msu" "%systemdrive%\2819745"
Start /w pkgmgr /n:"%systemdrive%\2819745\Windows6.1-2819745-x86.xml" /Quiet /NoRestart
RD /S /Q "C:\2819745"
goto Finish

:win7x64
:: Start update for 7 x64 / Server 2008 R2 x64 - Powershell 4.0
Expand –F:* "Windows6.1-KB2819745-x64-MultiPkg.msu" "%systemdrive%\2819745"
Start /w pkgmgr /n:"%systemdrive%\2819745\Windows6.1-2819745-x64.xml" /Quiet /NoRestart
RD /S /Q "C:\2819745"
goto Finish

:: -----------------------------------------------------------------------------------------

:Finish
shutdown /r /f /t 0
exit