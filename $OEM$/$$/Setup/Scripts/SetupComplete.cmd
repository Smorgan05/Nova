@echo off
:: Setupcomplete with PS 2.0 Install for Vista \ Server 2008 PS 3.0 Install for Windows 7 \ Server 2008 R2

:: Grab the Windows Version
For /f "tokens=4,5,6 delims=. " %%G in ('ver') Do (set _major=%%G& set _minor=%%H)
set version=%_major%.%_minor%

:: Powershell Check
regedit /s "%windir%\Setup\scripts\Reg\Windows\disable_uac.reg"

:: Insert starter.bat into startup via RunOnce
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Starter" /t REG_SZ /d "C:\windows\setup\scripts\SetupComplete.cmd" /f

if exist "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" (goto regInst) ELSE (goto Vista)
:: -----------------------------------------------------------------------------------------

:regInst

:: Grab Powershell Version information
FOR /F "usebackq delims=" %%v IN (`powershell -noprofile "& { $PSVersionTable.CLRVersion.Major }"`) DO set "psver=%%v"
set psver

:: Flip over to Upgrade to Powershell 3.0
if "%psver%"=="2" if "%version%"=="6.1" (goto win7)

:: Execute Powershell Setup
cd %windir%\setup\scripts
PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "Setup.ps1"
goto Finish

:: -----------------------------------------------------------------------------------------

:Vista
:: Install .net 4.5.2
cd %windir%\setup\scripts\Prep
start /w NDP452-KB2901907-x86-x64-AllOS-ENU.exe /q /norestart

MD "%systemdrive%\968930"
IF /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" (goto Vista64) ELSE (goto Vista32)

:: -----------------------------------------------------------------------------------------

:win7
:: Install .net 4.5.2
cd %windir%\setup\scripts\Prep
start /w NDP452-KB2901907-x86-x64-AllOS-ENU.exe /q /norestart

MD "%systemdrive%\2506143"
IF /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" (goto win7x64) ELSE (goto win7x32)

:: -----------------------------------------------------------------------------------------

:Vista32
:: Start update for Vista x86 / Server 2008 x86 - PowerShell 2.0
Expand –F:* "Windows6.0-vista-ps2-KB968930-x86.msu" "%systemdrive%\968930"
Start /w pkgmgr /ip /m:"%systemdrive%\968930\Windows6.0-KB968930-x86.cab" /Quiet /NoRestart
RD /S /Q "C:\968930"
goto Finish

:Vista64
:: Start update for Vista x64 / Server 2008 x64 - Powershell 2.0
Expand –F:* "Windows6.0-vista-ps2-KB968930-x64.msu" "%systemdrive%\968930"
Start /w pkgmgr /ip /m:"%systemdrive%\968930\Windows6.0-KB968930-x64.cab" /Quiet /NoRestart
RD /S /Q "C:\968930"
goto Finish

:: -----------------------------------------------------------------------------------------

:win7x32
:: Start update for 7 x86 - Powershell 3.0
Expand –F:* "Windows6.1-KB2506143-x86.msu" "%systemdrive%\2506143"
Start /w pkgmgr /ip /m:"%systemdrive%\2506143\Windows6.1-KB2506143-x86.cab" /Quiet /NoRestart
RD /S /Q "C:\2506143"
goto Finish

:win7x64
:: Start update for 7 x64 / Server 2008 R2 x64 - Powershell 3.0
Expand –F:* "Windows6.1-KB2506143-x64.msu" "%systemdrive%\2506143"
Start /w pkgmgr /ip /m:"%systemdrive%\2506143\Windows6.1-KB2506143-x64.cab" /Quiet /NoRestart
RD /S /Q "C:\2506143"
goto Finish

:: -----------------------------------------------------------------------------------------

:Finish
shutdown /r /f /t 0
exit