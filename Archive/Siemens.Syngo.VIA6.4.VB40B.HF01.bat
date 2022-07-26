SET APPNAME=Siemens Syngo.VIA 6.4.VB40B_HF01
SET DIRECTORY=C:\INSTALLS\%APPNAME%
SET ROOT=\\PHCMS01\share_data\phc\Imaging\FredTest\%APPNAME%
SET PSEXEC=\\phcms01\share_data\phc\Imaging\FredTest\Scripts\Sysinternals\PsExec.exe

TITLE %APPNAME% Utility
@ECHO OFF
COLOR 9F
CLS

IF NOT [%1]==[] (
	TITLE %APPNAME% (%1)
	IF [%1]==[BATCH] (GOTO:BATCH)
	IF [%1]==[COPY] (GOTO:COPY)
	IF [%1]==[INSTALL] (GOTO:INSTALL)
	IF [%1]==[REPAIR] (GOTO:REPAIR)
	IF [%1]==[UNINSTALL] (GOTO:UNINSTALL)
	IF [%1]==[UPGRADE] (GOTO:UPGRADE)
) ELSE (
	GOTO:MENU
)
GOTO:END

:MENU
	CLS
	ECHO Updated by Fred Linthicum 2020.10.26
	ECHO = Selection ===================================================================
	ECHO  1. Install
	ECHO  2. Repair
	ECHO  3. Uninstall
	ECHO ===============================================================================
	SET /p SELECTION= Enter your choice:
	ECHO ===============================================================================
	SET /p TARGET= Enter the PC to target(leave blank for local):
	IF [%TARGET%]==[] SET TARGET=%COMPUTERNAME%
:BATCH
	IF [%1]==[BATCH] SET SELECTION=%2
	IF [%1]==[BATCH] SET TARGET=%3
	TITLE %APPNAME% (%SELECTION% on %TARGET%)
	IF [%SELECTION%]==[1] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL
		GOTO:END
	)
	IF [%SELECTION%]==[2] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" REPAIR
		GOTO:END
	)
	IF [%SELECTION%]==[3] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UNINSTALL
		GOTO:END
	)
GOTO:END

:COPY
	ROBOCOPY "%ROOT%" "\\%TARGET%\C$\INSTALLS\%APPNAME%" /E /XD "%ROOT%\Extras"  /XF "\\PHCMS01\Share_Data\PHC\Imaging\FredTest\Siemens Syngo.VIA 4.1.VB30A_HF06\Automated\Thumbs.db"
GOTO:EOF

:PREREQ
	ECHO [%DATE% %TIME%] Installing .NET Framework 4.7.2...
		"%DIRECTORY%\Help\Prereqs\DotNetFx472\NDP472-KB4038188-x86-x64-AllOS-ENU.exe" /passive /norestart
	ECHO [%DATE% %TIME%] Installing C++ 8.0...
		"%DIRECTORY%\Help\Prereqs\vc8redist\vcredist_x64.exe" /Q
		"%DIRECTORY%\Help\Prereqs\vc8redist\vcredist_x86.exe" /Q
	ECHO [%DATE% %TIME%] Installing C++ 10.0...
		"%DIRECTORY%\Help\Prereqs\vc10redist\vcredist_x64.exe" /passive /norestart
		"%DIRECTORY%\Help\Prereqs\vc10redist\vcredist_x86.exe" /passive /norestart
	ECHO [%DATE% %TIME%] Installing C++ 12.0...
		"%DIRECTORY%\Help\Prereqs\vc12redist\vcredist_x64.exe" /passive /norestart
		"%DIRECTORY%\Help\Prereqs\vc12redist\vcredist_x86.exe" /passive /norestart
	ECHO [%DATE% %TIME%] Installing C++ 14.0...
		"%DIRECTORY%\Help\Prereqs\vc14redist\vc_redist.x64.exe" /passive /norestart
		"%DIRECTORY%\Help\Prereqs\vc14redist\vc_redist.x86.exe" /passive /norestart
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[PREREQ] %APPNAME%: %ERRORLEVEL%"
GOTO:EOF

:INSTALL
	CALL:PREREQ
	ECHO [%DATE% %TIME%] Installing %APPNAME% Main...
		MSIEXEC /i "%DIRECTORY%\x86\Bootstrapper_syngo.via@phcma809.piedmonthospital.org.msi" /qb-
		MSIEXEC /i "%DIRECTORY%\x86\syngo.via_Client_syngo.via.msi" /qb-
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%: %ERRORLEVEL%"
	CALL :REPAIR
GOTO:EOF

:REPAIR
	ECHO [%DATE% %TIME%] Repairing %APPNAME% Environmental Variables...
		SETX FEDA_LOOSE_WGL_ERROR_HANDLING true /M
		SETX FORCE_FEDATYPE GDI /M
		SETX MED_CONFIG_CACHE false /M
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[REPAIR] %APPNAME% Environmental Variables: %ERRORLEVEL%"
	ECHO [%DATE% %TIME%] Repairing %APPNAME% Settings...
		XCOPY "%DIRECTORY%\Help\Settings\ClientDeploymentContext.xml" "%PROGRAMDATA%\Siemens\syngo\DeploymentContexts\" /Q /R /Y
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[REPAIR] %APPNAME% Settings: %ERRORLEVEL%"
	ECHO [%DATE% %TIME%] Repairing %APPNAME% Creating Folders...
		DEL "%WINDIR%\Temp\*.*" /F /Q
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "%WINDIR%\Temp" /G "BUILTIN\Users":M /E
		IF NOT EXIST "%PROGRAMDATA%\Siemens" MKDIR "%PROGRAMDATA%\Siemens"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "%PROGRAMDATA%\Siemens" /G "BUILTIN\Users":M /E
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[REPAIR] %APPNAME% Creating Folders: %ERRORLEVEL%"
	ECHO [%DATE% %TIME%] Repairing %APPNAME% Desktop Icons...
		IF EXIST "%PUBLIC%\Desktop\syngo.via - Server Selection.lnk" DEL "%PUBLIC%\Desktop\syngo.via - Server Selection.lnk" /Q
REM		IF EXIST "%PUBLIC%\Desktop\syngo.via Client.lnk" DEL "%PUBLIC%\Desktop\syngo.via Client.lnk" /Q
		IF EXIST "%PUBLIC%\Desktop\syngo.via - Single Sign On.lnk" DEL "%PUBLIC%\Desktop\syngo.via - Single Sign On.lnk" /Q
		IF EXIST "%PUBLIC%\Desktop\Siemens Syngo.VIA Training.lnk" DEL "%PUBLIC%\Desktop\Siemens Syngo.VIA Training.lnk" /Q
		XCOPY "%DIRECTORY%\Help\Desktop\Piedmont Technologist Teaching Aide.lnk" "%PUBLIC%\Desktop\" /Q /R /Y
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[REPAIR] %APPNAME%Desktop Icons: %ERRORLEVEL%"
GOTO:EOF

:UNINSTALL
	ECHO [%DATE% %TIME%] Unnstalling %APPNAME% Old Versions...
		MSIEXEC /x {1B383085-36E0-4611-A26D-45142DE46BF9} /qb-
		MSIEXEC /x {DCB60D18-65B7-4483-B77C-50224F08718F} /qb-
		MSIEXEC /x {86DCA109-1173-0DD4-099E-984C1CB2D9EC} /qb-
		MSIEXEC /x {348E4A53-B74B-41DE-930C-C5D6F092C8DF} /qb-
		MSIEXEC /x {C0D3E13B-7BB1-4D70-8134-2ED473D63DFF} /qb-
		IF EXIST "%PUBLIC%\Desktop\syngo.via - Single Sign On.lnk" DEL "%PUBLIC%\Desktop\syngo.via - Single Sign On.lnk" /Q
		IF EXIST "%PUBLIC%\Desktop\Siemens Syngo.VIA Training.lnk" DEL "%PUBLIC%\Desktop\Siemens Syngo.VIA Training.lnk" /Q
	ECHO [%DATE% %TIME%] Unnstalling %APPNAME% MSI Files...
		TASKKILL /IM "syngoClientBootstrapping.exe" /F
		MSIEXEC /x {CDF29A84-755F-A2B7-07F7-C96451392278} /qb-
		MSIEXEC /x {7EB68AD3-2C71-428C-9FA3-AB08ECCD9285} /qb-
		IF EXIST "%PROGRAMFILES(X86)%\Siemens\syngo.via" RMDIR "%PROGRAMFILES(X86)%\Siemens\syngo.via" /S /Q
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME% MSI Files: %ERRORLEVEL%"
	ECHO [%DATE% %TIME%] Removing %APPNAME% Desktop Icons...
		IF EXIST "%PUBLIC%\Desktop\syngo.via - Single Sign On.lnk" DEL "%PUBLIC%\Desktop\syngo.via - Single Sign On.lnk" /Q
		IF EXIST "%PUBLIC%\Desktop\syngo.via Client.lnk" DEL "%PUBLIC%\Desktop\syngo.via Client.lnk" /Q
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME% Desktop Icon: %ERRORLEVEL%"
	ECHO [%DATE% %TIME%] Removing %APPNAME% Documentation...
		IF EXIST "%PUBLIC%\Desktop\Siemens Syngo.VIA Training.lnk" DEL "%PUBLIC%\Desktop\Siemens Syngo.VIA Training.lnk" /Q
		IF EXIST "%DIRECTORY%\Help\Desktop\Piedmont Technologist Teaching Aide.lnk" DEL "%DIRECTORY%\Help\Desktop\Piedmont Technologist Teaching Aide.lnk" /Q
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME% Removing Documentation: %ERRORLEVEL%"
GOTO:EOF

:END
	EXIT /B
