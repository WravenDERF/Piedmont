SET APPNAME=Fuji CD Uploader 5.7
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
	IF [%1]==[INSTALL-PAH] (GOTO:INSTALL-PAH)
	IF [%1]==[INSTALL-PAR] (GOTO:INSTALL-PAR)
	IF [%1]==[INSTALL-PCM] (GOTO:INSTALL-PCM)
	IF [%1]==[INSTALL-PCN] (GOTO:INSTALL-PCN)
	IF [%1]==[INSTALL-PFH] (GOTO:INSTALL-PFH)
	IF [%1]==[INSTALL-PHH] (GOTO:INSTALL-PHH)
	IF [%1]==[INSTALL-PMH] (GOTO:INSTALL-PMH)
	IF [%1]==[INSTALL-PNH] (GOTO:INSTALL-PNH)
	IF [%1]==[INSTALL-PNTH] (GOTO:INSTALL-PNTH)
	IF [%1]==[INSTALL-POA] (GOTO:INSTALL-POA)
	IF [%1]==[INSTALL-PRH] (GOTO:INSTALL-PRH)
	IF [%1]==[INSTALL-PWH] (GOTO:INSTALL-PWH)
	IF [%1]==[INSTALL-PPG] (GOTO:INSTALL-PPG)
	
	IF [%1]==[INSTALL-GEUV] (GOTO:INSTALL-GEUV)
	IF [%1]==[INSTALL-SYNGO] (GOTO:INSTALL-SYNGO)
	
	IF [%1]==[UNINSTALL] (GOTO:UNINSTALL)
) ELSE (
	GOTO:MENU
)
GOTO:END

:MENU
	CLS
	ECHO Updated by Fred Linthicum 2020.11.23
	ECHO = Prod Desktop Agent ==========================================================
	ECHO   1. Install %APPNAME% for PAH
	ECHO   2. Install %APPNAME% for PAR
	ECHO   3. Install %APPNAME% for PCM
	ECHO   4. Install %APPNAME% for PCN
	ECHO   5. Install %APPNAME% for PFH
	ECHO   6. Install %APPNAME% for PHH
	ECHO   7. Install %APPNAME% for PMH
	ECHO   8. Install %APPNAME% for PNH
	ECHO   9. Install %APPNAME% for PNTH
	ECHO  10. Install %APPNAME% for POA
	ECHO  11. Install %APPNAME% for PRH
	ECHO  12. Install %APPNAME% for PWH
	ECHO  13. Install %APPNAME% for PPG
	ECHO ===============================================================================
	ECHO  20. Install %APPNAME% for GEUV
	ECHO  21. Install %APPNAME% for Syngo
	ECHO ===============================================================================
	ECHO  30. Uninstall %APPNAME%
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
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PAH
		GOTO:END
	)
	IF [%SELECTION%]==[2] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PAR
		GOTO:END
	)
	IF [%SELECTION%]==[3] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PCM
		GOTO:END
	)
	IF [%SELECTION%]==[4] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PCN
		GOTO:END
	)
	IF [%SELECTION%]==[5] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PFH
		GOTO:END
	)
	IF [%SELECTION%]==[6] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PHH
		GOTO:END
	)
	IF [%SELECTION%]==[7] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PMH
		GOTO:END
	)
	IF [%SELECTION%]==[8] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PNH
		GOTO:END
	)
	IF [%SELECTION%]==[9] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PNTH
		GOTO:END
	)
		IF [%SELECTION%]==[10] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-POA
		GOTO:END
	)
	IF [%SELECTION%]==[11] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PRH
		GOTO:END
	)
	IF [%SELECTION%]==[12] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PWH
		GOTO:END
	)
	IF [%SELECTION%]==[13] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-PPG
		GOTO:END
	)
	
	IF [%SELECTION%]==[20] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-GEUV
		GOTO:END
	)
	
	IF [%SELECTION%]==[21] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALL-SYNGO
		GOTO:END
	)
	
	IF [%SELECTION%]==[30] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UNINSTALL
		GOTO:END
	)
GOTO:END

:COPY
	REG ADD "\\%TARGET%\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
	IF EXIST "%TARGET%\C$\INSTALLS" DEL "%TARGET%\C$\INSTALLS" /F /Q
	ROBOCOPY "%ROOT%" "\\%TARGET%\C$\INSTALLS\%APPNAME%" /E /XD "%ROOT%\Extras"
GOTO:EOF

:REPAIR
	ECHO [%DATE% %TIME%] Repairing %APPNAME%...
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayVersion /t REG_SZ /d "5.7" /f
		IF EXIST "%PUBLIC%\DESKTOP\Centricity CDImport.lnk" DEL "%PUBLIC%\DESKTOP\Centricity CDImport.lnk" /Q
		XCOPY "%DIRECTORY%\Help\Desktop\Synapse CDImport.lnk" "%PUBLIC%\DESKTOP\" /I /V /Y
	ECHO [%DATE% %TIME%] Installing Trainging Documentation...
		XCOPY "%DIRECTORY%\Help\Desktop\Piedmont Technologist Teaching Aide.lnk" "%PUBLIC%\Desktop" /I /V /Y
	IF NOT [%ERRORLEVEL%]==[0] (ECHO Error: %ERRORLEVEL%)
GOTO:EOF

:INSTALL
	ECHO [%DATE% %TIME%] Installing %APPNAME%...
		CALL:UNINSTALL
		MSIEXEC /i "%DIRECTORY%\x86\CDImportInstaller.msi" /qb-
	IF NOT [%ERRORLEVEL%]==[0] (ECHO Error: %ERRORLEVEL%)
GOTO:EOF

:INSTALL-PAH
	SET CAMPUS=PAH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PAR
	SET CAMPUS=PAR
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PCM
	SET CAMPUS=PCM
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PCN
	SET CAMPUS=PCN
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PFH
	SET CAMPUS=PFH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PHH
	SET CAMPUS=PHH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PMH
	SET CAMPUS=PMH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PNH
	SET CAMPUS=PNH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PNTH
	SET CAMPUS=PNTH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-POA
	SET CAMPUS=POA
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PRH
	SET CAMPUS=PRH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PWH
	SET CAMPUS=PWH
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-PPG
	SET CAMPUS=PPG
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-GEUV
	SET CAMPUS=GEUV
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:INSTALL-INSTALL-SYNGO
	SET CAMPUS=Syngo
	ECHO [%DATE% %TIME%] Installing %APPNAME% %CAMPUS%...
		CALL:INSTALL
		XCOPY "%DIRECTORY%\Help\Settings\%CAMPUS%\CDImport.ini" "%PROGRAMFILES%\Fuji Medical System\Synapse\CDImport\" /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" /v DisplayName /t REG_SZ /d "Synapse CDImport (%CAMPUS%)" /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(%CAMPUS%): %ERRORLEVEL%"
GOTO:EOF

:UNINSTALL
	ECHO [%DATE% %TIME%] Closing Fuji CD Uploader...
		TASKKILL /F /IM "CDImport.exe"
	ECHO [%DATE% %TIME%] Uninstalling Fuji CD Uploader 1.1...
		MSIEXEC /x {D5D17C51-EE13-483D-80D4-1A29D9D25BB9} /qb!		
	ECHO [%DATE% %TIME%] Uninstalling Fuji CD Uploader 5.3...
		MSIEXEC /x {88B19E2B-E825-4C70-A620-EE6280DD4042} /qb!
		IF EXIST "%PUBLIC%\DESKTOP\Centricity CDImport.lnk" DEL "%PUBLIC%\DESKTOP\Centricity CDImport.lnk" /Q
	ECHO [%DATE% %TIME%] Uninstalling %APPNAME% CD Burner...
		MSIEXEC /x {D7FCFDCF-CFB8-4320-B30E-6599931A1CC1} /qb!
		IF EXIST "%PUBLIC%\DESKTOP\Synapse CDImport.lnk" DEL "%PUBLIC%\DESKTOP\Synapse CDImport.lnk" /Q
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME%: %ERRORLEVEL%"
GOTO:END

:END
	EXIT /B