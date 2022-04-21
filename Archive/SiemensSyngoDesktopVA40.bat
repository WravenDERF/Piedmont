SET APPNAME=Siemens sD Workplace VA40
SET DIRECTORY=C:\INSTALLS\%APPNAME%
SET ROOT=\\PHCMS01\share_data\PHC\Imaging\FredTest\%APPNAME%
SET PSEXEC=\\phcms01\share_data\PHC\Imaging\FredTest\Scripts\Sysinternals\PsExec.exe

TITLE %APPNAME% Utility
@ECHO OFF
COLOR 9F
CLS

IF NOT [%1]==[] (
	TITLE %APPNAME% (%1)
	IF [%1]==[BATCH] (GOTO:BATCH)
	IF [%1]==[COPY] (GOTO:COPY)
	IF [%1]==[INSTALLPROD] (GOTO:INSTALLPROD)
	IF [%1]==[INSTALLTEST] (GOTO:INSTALLTEST)
	IF [%1]==[REPAIR] (GOTO:REPAIR)
	IF [%1]==[UPGRADE] (GOTO:UPGRADE)
	IF [%1]==[UNINSTALL] (GOTO:UNINSTALL)
) ELSE (
	GOTO:MENU
)
GOTO:END

:MENU
	CLS
	ECHO Updated by Fred Linthicum 2021.09.15
	ECHO = Production ==================================================================
	ECHO  1. Install %APPNAME% for Production
	ECHO  2. Install %APPNAME% for Test
	ECHO  3. Repair %APPNAME%
	ECHO  4. Upgrade %APPNAME%
	ECHO  5. Uninstall %APPNAME%
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
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALLPROD
		GOTO:END
	)
	IF [%SELECTION%]==[2] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALLTEST
		GOTO:END
	)
	IF [%SELECTION%]==[3] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" REPAIR
		GOTO:END
	)
	IF [%SELECTION%]==[4] (
		ROBOCOPY "%ROOT%\Automated" "\\%TARGET%\C$\INSTALLS\%APPNAME%\Automated" /E"
		ROBOCOPY "%ROOT%\Help\Utility" "\\%TARGET%\C$\INSTALLS\%APPNAME%\Help\Utility" /E"
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UPGRADE
		GOTO:END
	)
	IF [%SELECTION%]==[5] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UNINSTALL
		GOTO:END
	)
GOTO :END

:COPY
	ROBOCOPY "\\PHCMS01\Share_Data\PHC\Imaging\FredTest\Microsoft .NET Framework 4.7.2\NDP472-KB4054530-x86-x64-AllOS-ENU.exe" "\\%TARGET%\C$\INSTALLS\Microsoft .NET Framework 4.7.2" /E
	ROBOCOPY "%ROOT%" "\\%TARGET%\C$\INSTALLS\%APPNAME%" /E /XD "%ROOT%\Extras"
GOTO:EOF

:PREREQ
	ECHO [%DATE% %TIME%] Installing Microsoft .NET Framework 4.7.2...
		"C:\INSTALLS\Microsoft .NET Framework 4.7.2\NDP472-KB4054530-x86-x64-AllOS-ENU.exe" /passive /norestart
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(PREREQ): %ERRORLEVEL%"
GOTO:EOF

:INSTALLPROD
	CALL:PREREQ
	CALL:INSTALL4DM
	ECHO [%DATE% %TIME%] Installing %APPNAME%(PROD)...
		MSIEXEC /i "%DIRECTORY%\x86\sDxClient.Setup.msi" /passive /norestart MODE=HDIR SDXSERVER=PHCMA572.piedmonthospital.org
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(PROD): %ERRORLEVEL%"
	CALL:REPAIR
GOTO:EOF

:INSTALLTEST
	CALL:PREREQ
	CALL:INSTALL4DM
	ECHO [%DATE% %TIME%] Installing %APPNAME%(TEST)...
		MSIEXEC /i "%DIRECTORY%\x86\sDxClient.Setup.msi" /passive /norestart MODE=HDIR SDXSERVER=PHCMX572.piedmonthospital.org
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(INSTALLTEST): %ERRORLEVEL%"
	CALL:REPAIR
GOTO:EOF

:INSTALL4DM
	ECHO [%DATE% %TIME%] Installing %APPNAME%(TEST)...
		MSIEXEC /i "%DIRECTORY%\x86\Corridor4DM\Corridor4DM.msi" /passive /norestart
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(INSTALL4DM): %ERRORLEVEL%"
GOTO:EOF

:REPAIR
	ECHO [%DATE% %TIME%] [Syngo] Removing Old Icons...
		IF EXIST "%PUBLIC%\Desktop\NM-Syngo Service (Test).lnk" DEL "%PUBLIC%\Desktop\NM-Syngo Service (Test).lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\US-Syngo Service (Test).lnk" DEL "%PUBLIC%\Desktop\US-Syngo Service (Test).lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\NM-Syngo Service.lnk" DEL "%PUBLIC%\Desktop\NM-Syngo Service.lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\US-Syngo Service.lnk" DEL "%PUBLIC%\Desktop\US-Syngo Service.lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\Syngo Service.lnk" DEL "%PUBLIC%\Desktop\Syngo Service.lnk" /Q		
		IF EXIST "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk" DEL "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk"
		IF EXIST "%PROGRAMFILES(X86)%\syngoDynamics\PACSKILL.cmd" DEL "%PROGRAMFILES(X86)%\syngoDynamics\PACSKILL.cmd" /Q		
		IF EXIST "%PUBLIC%\Desktop\Syngo PACSKILL.lnk" DEL "%PUBLIC%\Desktop\Syngo PACSKILL.lnk" /Q
	ECHO [%DATE% %TIME%] [Epic] Creating Folders...
		IF NOT EXIST "C:\Temp\XML" MKDIR "C:\Temp\XML"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "C:\Temp\XML" /G "BUILTIN\Users":M /E
REM [2021.09.21] Not sure if these are still needed from old version, but no documentationw a sgiven on 4DM.
	ECHO [%DATE% %TIME%] [4DM] Removing Folders...
		IF EXIST %PROGRAMDATA%\INVIA\Corridor4DM\tmpdata\ DEL %PROGRAMDATA%\INVIA\Corridor4DM\tmpdata\*.* /F /Q
		IF EXIST "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk" DEL "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk"
	ECHO [%DATE% %TIME%] [4DM] Creating Folders...
		IF NOT EXIST "%PROGRAMFILES(x86)%\INVIA\Corridor4DM\" MKDIR "%PROGRAMFILES(x86)%\INVIA\Corridor4DM\"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "%PROGRAMFILES(x86)%\INVIA\Corridor4DM" /G "BUILTIN\Users":M /E
		IF NOT EXIST "%PUBLIC%\Documents\INVIA\Corridor4DM\" MKDIR "%PUBLIC%\Documents\INVIA\Corridor4DM\"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "%PUBLIC%\Documents\INVIA\Corridor4DM" /G "BUILTIN\Users":M /E
		IF NOT EXIST "%PROGRAMDATA%\INVIA\Corridor4DM\tmpdata\" MKDIR "%PROGRAMDATA%\INVIA\Corridor4DM\tmpdata\"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "%PROGRAMDATA%\INVIA\Corridor4DM\tmpdata" /G "BUILTIN\Users":M /E
		IF NOT EXIST "C:\syngoDynamics User Data Files\" MKDIR "C:\syngoDynamics User Data Files\"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "C:\syngoDynamics User Data Files" /G "BUILTIN\Users":M /E
	ECHO [%DATE% %TIME%] [4DM] Updating Configuration...
		XCOPY "%DIRECTORY%\Help\Config\*.*" "%PUBLIC%\Documents\INVIA\Corridor4DM\" /E /I /Q /R /Y
	ECHO [%DATE% %TIME%] [4DM] Updating User Configuration...
		XCOPY "%DIRECTORY%\Help\User\Corridor4DM\ConfigPolicy.xml" "%PROGRAMFILES(x86)%\INVIA\Corridor4DM\" /Q /R /Y
	ECHO [%DATE% %TIME%] [4DM] Repairing Video...
		XCOPY "%DIRECTORY%\Help\Files\Corridor4DM\vcruntime140.dll" "%PROGRAMFILES(X86)%\INVIA\Corridor4DM\" /Q /R /Y
		XCOPY "%DIRECTORY%\Help\Files\Corridor4DM\avi2wmv.exe" "%PROGRAMFILES(X86)%\INVIA\Corridor4DM\" /Q /R /Y
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[REPAIR] %APPNAME%(REPAIR): %ERRORLEVEL%"
GOTO:EOF

:UPGRADE
	ECHO [%DATE% %TIME%] [Syngo] Removing Old Icons...
		IF EXIST "%PUBLIC%\Desktop\NM-Syngo Service (Test).lnk" DEL "%PUBLIC%\Desktop\NM-Syngo Service (Test).lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\US-Syngo Service (Test).lnk" DEL "%PUBLIC%\Desktop\US-Syngo Service (Test).lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\NM-Syngo Service.lnk" DEL "%PUBLIC%\Desktop\NM-Syngo Service.lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\US-Syngo Service.lnk" DEL "%PUBLIC%\Desktop\US-Syngo Service.lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\Syngo Service.lnk" DEL "%PUBLIC%\Desktop\Syngo Service.lnk" /Q		
		IF EXIST "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk" DEL "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk"
		IF EXIST "%PROGRAMFILES(X86)%\syngoDynamics\PACSKILL.cmd" DEL "%PROGRAMFILES(X86)%\syngoDynamics\PACSKILL.cmd" /Q		
		IF EXIST "%PUBLIC%\Desktop\Syngo PACSKILL.lnk" DEL "%PUBLIC%\Desktop\Syngo PACSKILL.lnk" /Q
	ECHO [%DATE% %TIME%] [Epic] Creating Folders...
		IF NOT EXIST "C:\Temp\XML" MKDIR "C:\Temp\XML"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "C:\Temp\XML" /G "BUILTIN\Users":M /E
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UPGRADE] %APPNAME%(UPGRADE): %ERRORLEVEL%"
GOTO:EOF

:UNINSTALL
	ECHO [%DATE% %TIME%] [4DM] Uninstalling (4DM(syngo Dynamics) 2018.0.0.205)...
		MSIEXEC /x {39C9EBCE-9663-4EE6-910D-404B1A166136} /qb!
	ECHO [%DATE% %TIME%] [4DM] Uninstalling (Corridor4DM(syngo Dynamics) 2015.0.2.60)...
		MSIEXEC /x {5D8F0D41-96DD-46B2-9A6F-8FDFD4F3B9BB} /qb!
	ECHO [%DATE% %TIME%] [4DM] Removing Invivo Configuration...
		IF EXIST "%PUBLIC%\Documents\INVIA\" RMDIR "%PUBLIC%\Documents\INVIA\" /S /Q
	ECHO [%DATE% %TIME%] [4DM] Removing User Configuration...
		IF EXIST "%PROGRAMFILES(x86)%\INVIA\" RMDIR "%PROGRAMFILES(x86)%\INVIA\" /S /Q
	ECHO [%DATE% %TIME%] [Syngo] Uninstalling VA20E...
		MSIEXEC /x {2CB8DFC4-501C-4670-9FCA-6EAF0B9B022B} /qb!
	ECHO [%DATE% %TIME%] [Syngo] Uninstalling VA40...
		MSIEXEC /x {FD42DDCC-6250-4E0F-BC38-42F0F5F44FED} /qb!
	ECHO [%DATE% %TIME%] [Syngo] Removing Old Icons...
		IF EXIST "%PUBLIC%\Desktop\NM-Syngo Service (Test).lnk" DEL "%PUBLIC%\Desktop\NM-Syngo Service (Test).lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\US-Syngo Service (Test).lnk" DEL "%PUBLIC%\Desktop\US-Syngo Service (Test).lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\NM-Syngo Service.lnk" DEL "%PUBLIC%\Desktop\NM-Syngo Service.lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\US-Syngo Service.lnk" DEL "%PUBLIC%\Desktop\US-Syngo Service.lnk" /F /Q
		IF EXIST "%PUBLIC%\Desktop\Syngo Service.lnk" DEL "%PUBLIC%\Desktop\Syngo Service.lnk" /Q		
		IF EXIST "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk" DEL "%PUBLIC%\Desktop\syngo Dynamics (Test).lnk"
		IF EXIST "%PROGRAMFILES(X86)%\syngoDynamics\PACSKILL.cmd" DEL "%PROGRAMFILES(X86)%\syngoDynamics\PACSKILL.cmd" /Q		
		IF EXIST "%PUBLIC%\Desktop\Syngo PACSKILL.lnk" DEL "%PUBLIC%\Desktop\Syngo PACSKILL.lnk" /Q
	ECHO [%DATE% %TIME%] [Syngo] Removing Old Syngo Configuration...
		IF EXIST "%PROGRAMDATA%\Siemens\syngoDynamics\" RMDIR "%PROGRAMDATA%\Siemens\syngoDynamics\" /S /Q
		IF EXIST "%PROGRAMFILES%\syngoDynamics\" RMDIR "%PROGRAMFILES%\syngoDynamics\" /S /Q
		IF EXIST "%PROGRAMFILES(x86)%\syngoDynamics\" RMDIR "%PROGRAMFILES(x86)%\syngoDynamics\" /S /Q
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME%(): %ERRORLEVEL%"
GOTO:EOF

:END
	EXIT /B
