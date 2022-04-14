SET APPNAME=Fuji Synapse 5.7.220
SET DIRECTORY=C:\INSTALLS\%APPNAME%
SET ROOT=\\PHCMS01\share_data\PHC\Imaging\FredTest\%APPNAME%
SET PSEXEC=\\phcms01\share_data\PHC\Imaging\FredTest\Scripts\Sysinternals\PsExec.exe

REM Create a :REPAIRDESKTOP that will put a scheduled task to remove:
REM C:\ProgramData\Fujifilm Medical Systems\Synapse\Workstation\config\EnterpriseMachineId.xml
REM Once per week on Sunday morning.
REM The scheduled task will call the Repair desktop that wil delete the XML and update the scheduled task.

TITLE %APPNAME% Utility
@ECHO OFF
COLOR 9F
CLS

IF NOT [%1]==[] (
	TITLE %APPNAME% (%1)
	IF [%1]==[BATCH] (GOTO:BATCH)
	IF [%1]==[COPY] (GOTO:COPY)
	IF [%1]==[INSTALLDESKTOP] (GOTO:INSTALLDESKTOP)
	IF [%1]==[REPAIR] (GOTO:REPAIR)
	IF [%1]==[UNINSTALLDESKTOP] (GOTO:UNINSTALLDESKTOP)
	IF [%1]==[INSTALLWEB] (GOTO:INSTALLWEB)
	IF [%1]==[UNINSTALLWEB] (GOTO:UNINSTALLWEB)
	IF [%1]==[INSTALLTESTDESKTOP] (GOTO:INSTALLTESTDESKTOP)
	IF [%1]==[REPAIRTESTDESKTOP] (GOTO:REPAIRTESTDESKTOP)
	IF [%1]==[UPGRADEPREP] (GOTO:UPGRADEPREP)
	IF [%1]==[UNINSTALLTESTDESKTOP] (GOTO:UNINSTALLTESTDESKTOP)
	IF [%1]==[UNINSTALL-SYNAPSE44] (GOTO:UNINSTALL-SYNAPSE44)
	
) ELSE (
	GOTO:MENU
)
GOTO:END

:MENU
	CLS
	ECHO Updated by Fred Linthicum 2021.10.15
	ECHO = Prod Desktop Agent ==========================================================
	ECHO  1. Install %APPNAME% Desktop Agent
	ECHO  2. Repair %APPNAME% Desktop Agent
	ECHO  3. Uninstalling %APPNAME% Desktop Agent
	ECHO = Prod Web Icon ===============================================================
	ECHO  4. Install %APPNAME% Web Icon
	ECHO  5. Repair %APPNAME% Web Icon
	ECHO  6. Uninstalling %APPNAME% Web Icon
	ECHO = Test Desktop Agent ==========================================================
	ECHO  7. Install %APPNAME% Test Desktop Agent (PHCMX137)
	ECHO  8. Repair %APPNAME% Test Desktop Agent
	ECHO  9. Uninstalling %APPNAME% Test Desktop Agent
	ECHO ===============================================================================
	SET /p SELECTION= Enter your choice:
	ECHO ===============================================================================
	SET /p TARGET= Enter the PC to target(leave blank for local):
	IF [%TARGET%]==[] SET TARGET=%COMPUTERNAME%
:BATCH
	IF [%1]==[BATCH] (SET SELECTION=%2)
	IF [%1]==[BATCH] (SET TARGET=%3)
	TITLE %APPNAME% (%SELECTION% on %TARGET%)
	IF [%SELECTION%]==[0] (
		CALL:COPY
		GOTO:END
	)
	IF [%SELECTION%]==[1] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALLDESKTOP
		GOTO:END
	)
	IF [%SELECTION%]==[2] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" REPAIR
		GOTO:END
	)
	IF [%SELECTION%]==[3] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UNINSTALLDESKTOP
		GOTO:END
	)
	IF [%SELECTION%]==[4] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALLWEB
		GOTO:END
	)
	IF [%SELECTION%]==[5] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALLWEB
		GOTO:END
	)
	IF [%SELECTION%]==[6] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UNINSTALLWEB
		GOTO:END
	)
	IF [%SELECTION%]==[7] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" INSTALLTESTDESKTOP
		GOTO:END
	)
	IF [%SELECTION%]==[8] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" REPAIR
		GOTO:END
	)
	IF [%SELECTION%]==[9] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UNINSTALLDESKTOP
		GOTO:END
	)
	IF [%SELECTION%]==[98] (
		CALL:COPY
		%PSEXEC% \\%TARGET% -accepteula -e -h "C:\INSTALLS\%APPNAME%\Automated\Automated.bat" UPGRADEPREP
		GOTO:END
	)
	IF [%SELECTION%]==[99] (
		CALL:COPY
		SCHTASKS /delete /S %TARGET% /F /TN "Piedmont\UNINSTALL-SYNAPSE44"
		SCHTASKS /create /S %TARGET% /F /TN "Piedmont\UNINSTALL-SYNAPSE44" /RU "SYSTEM" /RL HIGHEST /SC ONSTART /TR "'C:\INSTALLS\%APPNAME%\Automated\Automated.bat' UNINSTALL-SYNAPSE44"
		SCHTASKS /create /S %TARGET% /F /TN "Piedmont\SYSTEM-REBOOT" /RU "SYSTEM" /RL HIGHEST /SC ONCE /SD 12/15/2020 /ST 04:00 /TR "SHUTDOWN /r /f /t 00"
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
	ECHO [%DATE% %TIME%] Disable UAC...
		REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\policies\system" /v EnableLUA /t REG_DWORD /d 0 /f
	ECHO [%DATE% %TIME%] Allow Pop-Ups...
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\New Windows" /v "ListBox_Support_Allow" /t REG_DWORD /d 1 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\New Windows\Allow" /v "*.farmcsyn" /t REG_SZ /d "*.farmcsyn" /f
	ECHO [%DATE% %TIME%] Installing Training Documentation...
		IF EXIST "%PUBLIC%\Desktop\Fuji Synapse 5 Training.lnk" DEL "%PUBLIC%\Desktop\Fuji Synapse 5 Training.lnk" /Q
		XCOPY "%DIRECTORY%\Help\Desktop\Piedmont Technologist Teaching Aide.lnk" "%PUBLIC%\Desktop" /I /V /Y
	ECHO [%DATE% %TIME%] Make IE default to 64 bit...
		REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v TabProcGrowth /t REG_DWORD /d 00000000 /f
	ECHO [%DATE% %TIME%] Copy ScanKill files...
		IF EXIST "%PUBLIC%\Desktop\ScanKill.lnk" DEL "%PUBLIC%\Desktop\ScanKill.lnk" /Q
	ECHO [%DATE% %TIME%] Create cache folders...
		IF NOT EXIST "C:\DATA\FujiHybrid" MKDIR "C:\DATA\FujiHybrid"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "C:\DATA\FujiHybrid" /G "BUILTIN\Everyone":M /E
	ECHO [%DATE% %TIME%] Create download folders...
		IF NOT EXIST "C:\Synapse" MKDIR "C:\Synapse"
		CSCRIPT "%DIRECTORY%\Help\Utility\XCACLS.vbs" "C:\Synapse" /G "BUILTIN\Everyone":M /E
	ECHO [%DATE% %TIME%] Copy Content Manager Files...
		XCOPY "%DIRECTORY%\Help\Desktop\Content Manager.lnk" "%PUBLIC%\Desktop\" /I /V /Y
	ECHO [%DATE% %TIME%] Make IE the browser Synapse always uses...
		REG ADD "HKEY_CURRENT_USER\Software\Fuji Medical Systems USA\Synapse\DesktopAgent" /v "SelectedBrowser" /t REG_SZ /d IE /f
		FOR /f %%f IN ('dir /b /a:d C:\USERS') DO (
			REG LOAD HKLM\TempHive "C:\USERS\%%f\NTUSER.DAT"
			REG ADD "HKLM\TempHive\Software\Fuji Medical Systems USA\Synapse\DesktopAgent" /v "SelectedBrowser" /t REG_SZ /d IE /f
			REG UNLOAD HKLM\TempHive
		)
	ECHO [%DATE% %TIME%] [GPO]Adding Fuji to Trusted Sites...
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1206 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 2102 /t REG_DWORD /d 0 /f
	ECHO [%DATE% %TIME%] [IE-GPO] Allow scripting of Microsoft webbrowser control...
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v 1206 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v 1206 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1206 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1206 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v 1206 /t REG_DWORD /d 0 /f
	ECHO [%DATE% %TIME%] [IE-GPO] Allow script-initiated windows without size or position constraints...
		REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v 2102 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v 2102 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 2102 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 2102 /t REG_DWORD /d 0 /f
		REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v 2102 /t REG_DWORD /d 0 /f
	ECHO [%DATE% %TIME%] [IE-GPO] Display intranet sites in compatibility view (Disable)...
		REM https://community.spiceworks.com/topic/207325-disabling-intranet-compatibility-mode-via-gpo
		REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v IntranetCompatibilityMode /t REG_DWORD /d "0" /f
	ECHO [%DATE% %TIME%] Add Trusted Sites...
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\pacs.piedmont.org" /v http /t REG_DWORD /d 2 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\pacs.piedmont.org" /v https /t REG_DWORD /d 2 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\farmcsyn" /v http /t REG_DWORD /d 2 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\farmcsyn" /v https /t REG_DWORD /d 2 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\phcmx137" /v http /t REG_DWORD /d 2 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\phcmx137" /v https /t REG_DWORD /d 2 /f

		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmonthospital.org" /v "*" /t REG_DWORD /d 2 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmonthospital.org" /v "*" /t REG_DWORD /d 2 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmont.org" /v "*" /t REG_DWORD /d 2 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmont.org" /v "*" /t REG_DWORD /d 2 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest" /v "*" /t REG_DWORD /d 2 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137" /v "*" /t REG_DWORD /d 2 /f
		FOR /f %%f IN ('dir /b /a:d C:\USERS') DO (
			IF NOT [%%f]==[wks_admin] REG LOAD HKLM\TempHive "C:\USERS\%%f\NTUSER.DAT"
			IF NOT [%%f]==[wks_admin] REG ADD "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmonthospital.org" /v "*" /t REG_DWORD /d 2 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmonthospital.org" /v "*" /t REG_DWORD /d 2 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmont.org" /v "*" /t REG_DWORD /d 2 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmont.org" /v "*" /t REG_DWORD /d 2 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest" /v "*" /t REG_DWORD /d 2 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137" /v "*" /t REG_DWORD /d 2 /f
			IF NOT [%%f]==[wks_admin] REG UNLOAD HKLM\TempHive
		)
	ECHO [%DATE% %TIME%] Configure Adobe Permissions...
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" /v "iProtectedView" /t REG_DWORD /d 0 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" /v "bEnhancedSecurityStandalone" /t REG_DWORD /d 0 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" /v "bEnhancedSecurityInBrowser" /t REG_DWORD /d 0 /f
		REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\Privileged" /v "bProtectedMode" /t REG_DWORD /d 0 /f
		FOR /f %%f IN ('dir /b /a:d C:\USERS') DO (
			IF NOT [%%f]==[wks_admin] REG LOAD HKLM\TempHive "C:\USERS\%%f\NTUSER.DAT"
			IF NOT [%%f]==[wks_admin] REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" /v "iProtectedView" /t REG_DWORD /d 0 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" /v "bEnhancedSecurityStandalone" /t REG_DWORD /d 0 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" /v "bEnhancedSecurityInBrowser" /t REG_DWORD /d 0 /f
			IF NOT [%%f]==[wks_admin] REG ADD "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\Privileged" /v "bProtectedMode" /t REG_DWORD /d 0 /f
			IF NOT [%%f]==[wks_admin] REG UNLOAD HKLM\TempHive
		)
	ECHO [%DATE% %TIME%] Disabling Trend Network Adaptor Binding (SR:282218)...
		POWERSHELL -Command "& {&'Disable-NetAdapterBinding' -Name '*' -DisplayName 'Trend Micro NDIS 6.0 Filter Driver'}"
		POWERSHELL -Command "& {&'Disable-NetAdapterBinding' -Name '*' -DisplayName 'Trend Micro LightWeight Filter Driver'}"
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[REPAIR] %APPNAME%: %ERRORLEVEL%"
GOTO:EOF

:INSTALLDESKTOP
	ECHO [%DATE% %TIME%] Installing %APPNAME% Desktop Agent...
		CALL:UNINSTALLWEB
		CALL:UNINSTALLDESKTOP
		CALL:UNINSTALL-SYNAPSE44
	ECHO [%DATE% %TIME%] Stopping %APPNAME% Desktop Agent...
		TASKKILL /F /IM "Fujifilm.Synapse.Agent.exe"
	ECHO [%DATE% %TIME%] Stopping MSIEXEC Prperty...
		TASKKILL /F /IM "msiexec.exe"
	ECHO [%DATE% %TIME%] Component Fuji Synapse 3D...
		MSIEXEC /i "%DIRECTORY%\x86\InstallHelperSetup.msi" ALLUSERS=1 /qb-
	ECHO [%DATE% %TIME%] Component Dynamic Web HTML5...
		MSIEXEC /i "%DIRECTORY%\x86\DynamicWebTWAINHTML5Edition.msi" /qb- ALLUSERS=1
	ECHO [%DATE% %TIME%] Component Fuji Synapse Desktop Agent...
		MSIEXEC /i "%DIRECTORY%\x86\SynapseWorkstationEx.msi" CODEBASE="http://farmcsyn.piedmonthospital.org/" VERIFY_INSTALLATION=0 INSTALL_DESKTOP_AGENT=1 ALLUSERS=1 /qb-
	ECHO [%DATE% %TIME%] Adding Startup Batch...
		SCHTASKS /CREATE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE" /RU "SYSTEM" /RL HIGHEST /SC ONSTART /TR "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Files\Fuji-Synapse-XML.bat"
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(Agent Prod): %ERRORLEVEL%"
	CALL:REPAIR
GOTO:EOF

:INSTALLTESTDESKTOP
	ECHO [%DATE% %TIME%] Installing %APPNAME% Test Desktop Agent...
		CALL:UNINSTALLWEB
		CALL:UNINSTALLDESKTOP
		CALL:UNINSTALL-SYNAPSE44
	ECHO [%DATE% %TIME%] Component Fuji Synapse 3D...
		MSIEXEC /i "%DIRECTORY%\x86\InstallHelperSetup.msi" ALLUSERS=1 /qb-
	ECHO [%DATE% %TIME%] Component Dynamic Web HTML5...
		MSIEXEC /i "%DIRECTORY%\x86\DynamicWebTWAINHTML5Edition.msi" /qb- ALLUSERS=1
	ECHO [%DATE% %TIME%] Component Fuji Synapse Desktop Agent...
		MSIEXEC /i "%DIRECTORY%\x86\SynapseWorkstationEx.msi" CODEBASE="http://phcmx137.piedmonthospital.org/" VERIFY_INSTALLATION=0 INSTALL_DESKTOP_AGENT=1 ALLUSERS=1 /qb-
	ECHO [%DATE% %TIME%] Adding Startup Batch...
		SCHTASKS /CREATE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE" /RU "SYSTEM" /RL HIGHEST /SC ONSTART /TR "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Files\Fuji-Synapse-XML.bat"
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(Agent Test): %ERRORLEVEL%"
	CALL:REPAIR
GOTO:EOF

:UPGRADEPREP
	SCHTASKS /CREATE /F /TN "Piedmont\SYNAPSE-UPGRADE" /RU "SYSTEM" /RL HIGHEST /SC ONSTART /TR "'C:\Installs\Fuji Synapse 5.7.220\Automated\Automated.bat' INSTALLDESKTOP"
GOTO:EOF

:UNINSTALLDESKTOP
	ECHO [%DATE% %TIME%] Uninstalling %APPNAME% Desktop Agent...
		TASKKILL /F /IM "Fujifilm.Synapse.Agent.exe"
	ECHO [%DATE% %TIME%] Component Fuji Synapse 5.5 Desktop Agent...
		MSIEXEC /x {C3FE4D19-8346-466A-B3EF-6A13867E8FDD} /qb-
	ECHO [%DATE% %TIME%] Component Fuji Synapse 5.7.200 Desktop Agent...
		MSIEXEC /x {64D3590F-3BF8-4E61-994F-9AFB89EA6176} /qb-
		MSIEXEC /x {56839E35-532F-479D-8BB9-64D3546DF819} /qb-
	ECHO [%DATE% %TIME%] Component Fuji Synapse 5.7.220 Desktop Agent...
		MSIEXEC /x {E6EB995F-F572-4DB9-A61A-0C3E6D11F75F} /qb-		
	ECHO [%DATE% %TIME%] Component old training link if present...
		IF EXIST "%PUBLIC%\Desktop\Fuji Synapse 5 Training.lnk" DEL "%PUBLIC%\Desktop\Fuji Synapse 5 Training.lnk" /Q
	ECHO [%DATE% %TIME%] Component HTML5 TWAIN Web...
		MSIEXEC /x {7BF08D44-2176-4A7B-A8B7-8E4DC7424D5D} /qb-
	ECHO [%DATE% %TIME%] Installation Helper 1.3.1.0...
		MSIEXEC /x {C21DF62B-3850-4977-8061-AD346FB14883} /qb-
	ECHO [%DATE% %TIME%] Component ScanKill link if present...
		IF EXIST "%PUBLIC%\Desktop\ScanKill.lnk" DEL "%PUBLIC%\Desktop\ScanKill.lnk" /Q
	ECHO [%DATE% %TIME%] Component MPR Fusion...
		MSIEXEC /x {B6729277-10DA-4A2E-BABA-6B50002C5E57} /qb-
	ECHO [%DATE% %TIME%] Uninstalling %APPNAME% Icon...
		IF EXIST "%PUBLIC%\Desktop\Content Manager.lnk" DEL "%PUBLIC%\Desktop\Content Manager.lnk" /Q
	ECHO [%DATE% %TIME%] Removing Startup Batch...
		SCHTASKS /CREATE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE" /RU "SYSTEM" /RL HIGHEST /SC ONSTART /TR "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Files\Fuji-Synapse-XML.bat"
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME%(Agent): %ERRORLEVEL%"
GOTO:EOF

:INSTALLWEB
	ECHO [%DATE% %TIME%] Installing %APPNAME% Web Icon...
		CALL:UNINSTALLWEB
		CALL:UNINSTALLDESKTOP
		CALL:UNINSTALL-SYNAPSE44
		MSIEXEC /i "%DIRECTORY%\x86\DynamicWebTWAINHTML5Edition.msi" /qb- ALLUSERS=1
		MSIEXEC /i "%DIRECTORY%\x86\InstallHelperSetup.msi" ALLUSERS=1 /qb-
		XCOPY "%DIRECTORY%\Help\Icon\fujiFilm.ico" "%PROGRAMFILES%\Fujifilm Medical Systems\Icon\" /E /I /V /Y
		XCOPY "%DIRECTORY%\Help\Desktop\Synapse 5 Web.lnk" "%PUBLIC%\Desktop" /E /I /V /Y
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" /v DisplayName /t REG_SZ /d "Fuji Synapse 5 Web" /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" /v DisplayVersion /t REG_SZ /d "5.7" /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" /v DisplayIcon /t REG_SZ /d "%ProgramFiles%\\Fujifilm Medical Systems\\Icon\\FujiFilm.ico" /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" /v NoModify /t REG_DWORD /d 1 /f
		REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" /v NoRepair /t REG_DWORD /d 1 /f
		CALL:REPAIR
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[INSTALL] %APPNAME%(Web): %ERRORLEVEL%"
GOTO:EOF

:UNINSTALLWEB
	ECHO [%DATE% %TIME%] Uninstalling %APPNAME% Icon...
		IF EXIST "%PUBLIC%\Desktop\Synapse 5 Web.lnk" DEL "%PUBLIC%\Desktop\Synapse 5 Web.lnk" /Q
		IF EXIST "%PUBLIC%\Desktop\Fuji Synapse 5 Training.lnk" DEL "%PUBLIC%\Desktop\Fuji Synapse 5 Training.lnk" /Q
		REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" /f
		IF EXIST "%PUBLIC%\Desktop\Content Manager.lnk" DEL "%PUBLIC%\Desktop\Content Manager.lnk" /Q
	ECHO [%DATE% %TIME%] Component HTML5 TWAIN Web...
		MSIEXEC /x {7BF08D44-2176-4A7B-A8B7-8E4DC7424D5D} /qb-
	ECHO [%DATE% %TIME%] Installation Helperc 1.3.1.0...
		MSIEXEC /x {C21DF62B-3850-4977-8061-AD346FB14883} /qb-
	EVENTCREATE /l APPLICATION /so InfoSpark /id 800 /T INFORMATION /d "[UNINSTALL] %APPNAME%(Web): %ERRORLEVEL%"
GOTO:EOF

:UNINSTALL-SYNAPSE44
	ECHO [%DATE% %TIME%] Component MPR Fusion...
		MSIEXEC /x {B6729277-10DA-4A2E-BABA-6B50002C5E57} /qb-
	ECHO [%DATE% %TIME%] Uninstalling Unknown Synapse Workstation...
		MSIEXEC /x {BFE00D46-C1CF-4754-A51E-A4731F967992} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-
	ECHO [%DATE% %TIME%] Uninstalling Synapse 4.4.200...
		MSIEXEC /x {D2DEA580-C6B1-4A8D-820E-46E93059268B} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-
	ECHO [%DATE% %TIME%] Uninstalling Synapse 4.4.210...
		MSIEXEC /x {F71DB8E8-D8DA-4814-9255-10C7C52BAA30} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-
	ECHO [%DATE% %TIME%] Uninstalling Synapse 4.4.360...
		MSIEXEC /x {D5BF7D6D-152E-4FBF-B2EE-DA5262B700A7} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-
	ECHO [%DATE% %TIME%] Uninstalling Synapse 4.4.375...
		MSIEXEC /x {BA934C23-8A49-46F5-ABED-A1E00727A97B} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-
	ECHO [%DATE% %TIME%] Removing Scheduled Task...
		SCHTASKS /delete /F /TN "Piedmont\UNINSTALL-SYNAPSE44"
		SCHTASKS /delete /F /TN "Piedmont\SYSTEM-REBOOT"
GOTO:EOF

:END
	EXIT /B
