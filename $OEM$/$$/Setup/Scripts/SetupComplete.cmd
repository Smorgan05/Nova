@echo off
Title Setupcomplete with PS Install for Vista

echo Powershell Check
start /w regedit /s "%windir%\Setup\scripts\Reg\Windows\disable_uac.reg"
if exist "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" (goto reg) ELSE (goto Pwr)
-----------------------------------------------------------------------------------------

:reg
cd %windir%\setup\scripts
echo Execute Powershell Setup
PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "Setup.ps1"
goto Finish

-----------------------------------------------------------------------------------------

:Pwr
echo Insert starter.bat into startup via RunOnce
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Starter" /t REG_SZ /d "C:\windows\setup\scripts\SetupComplete.cmd" /f
MD "%systemdrive%\968930"
IF /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" (goto install64) ELSE (goto install32)

-----------------------------------------------------------------------------------------

:install32
echo Start update for Vista x86 / Server 2008 x86
cd %windir%\Setup\scripts\Apps\Prep
Expand –F:* "Windows6.0-vista-ps2-KB968930-x86.msu" "%systemdrive%\968930"
Start /w pkgmgr /ip /m:"%systemdrive%\968930\Windows6.0-KB968930-x86.cab" /Quiet /NoRestart
RD /S /Q "C:\968930"
exit

:install64
echo Start update for Vista x64 / Server 2008 x64
cd %windir%\Setup\scripts\Apps\Prep
Expand –F:* "Windows6.0-vista-ps2-KB968930-x64.msu" "%systemdrive%\968930"
Start /w pkgmgr /ip /m:"%systemdrive%\968930\Windows6.0-KB968930-x64.cab" /Quiet /NoRestart
RD /S /Q "C:\968930"
exit