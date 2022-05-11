$FujiCDUploader = [PSCustomObject]@{
    'Vendor' = [string]'Fuji'
    'Name' = [string]'CD Uploader'
    'Version' = [string]'5.7.220'
    'NetworkSource' = [string]'\\PHCMS01\share_data\PHC\Imaging\FredTest'
    'LocalSource' = [string]'C:\INSTALLS'
    'Debug' = [bool]$false
    'MenuArray' = New-Object System.Collections.ArrayList
}




Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'FujiSynapseCopy' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    
    #Copy source files to the destination.
    [string]$NetworkSourceFiles = "$($MassDriver.NetworkSource)\$($MassDriver.Vendor) $($MassDriver.Name) $($MassDriver.Version)"
    [string]$DestinationSourceFiles = "\\$ComputerName\C$\INSTALLS\$($MassDriver.Vendor) $($MassDriver.Name) $($MassDriver.Version)"
    Invoke-Command -ScriptBlock {Start-Process -FilePath 'C:\Windows\system32\ROBOCOPY.EXE' -ArgumentList """$NetworkSourceFiles"" ""$DestinationSourceFiles"" /E /XD ""$DestinationSourceFiles\Extras""" -Wait}
}




Add-Member -InputObject $Install -MemberType 'ScriptMethod' -Name 'FujiSynapseUninstall' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter(Mandatory=$True)][string]$ComputerName,
        [Parameter(Mandatory=$True)][string]$Build
    )
    
    #The main code block that uninstalls everything.
    $UninstallEverything = {
}





Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'FujiSynapseUninstall' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter()][string]$ComputerName
    )


    #The main code block that uninstalls everything.
    $UninstallEverything = {
        Write-Host -Object $('Exiting Fuji Desktop Agent.')
        IF (Get-Process -Name 'Fujifilm.Synapse.Agent.exe' -ErrorAction 'SilentlyContinue') {Stop-Process "Fujifilm.Synapse.Agent.exe" -Force}
        Write-Host -Object $('Exiting WebTWAIN Service.')
        IF (Get-Process -Name 'WebTWAINService.exe' -ErrorAction 'SilentlyContinue') {Stop-Process "WebTWAINService.exe" -Force}
        Write-Host -Object $('Uninstalling the HTML5 TWAIN Web component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {7BF08D44-2176-4A7B-A8B7-8E4DC7424D5D} /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling the Fuji Synapse 3D component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C21DF62B-3850-4977-8061-AD346FB14883} /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling the MPR Fusion component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {B6729277-10DA-4A2E-BABA-6B50002C5E57} /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling unknown Fuji Synapse version.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {BFE00D46-C1CF-4754-A51E-A4731F967992} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.200.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {D2DEA580-C6B1-4A8D-820E-46E93059268B} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.210.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {F71DB8E8-D8DA-4814-9255-10C7C52BAA30} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.360.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {D5BF7D6D-152E-4FBF-B2EE-DA5262B700A7} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.375.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {BA934C23-8A49-46F5-ABED-A1E00727A97B} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 5.5 Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C3FE4D19-8346-466A-B3EF-6A13867E8FDD} /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 5.7.200 Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {64D3590F-3BF8-4E61-994F-9AFB89EA6176} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {56839E35-532F-479D-8BB9-64D3546DF819} /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 5.7.220 Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {E6EB995F-F572-4DB9-A61A-0C3E6D11F75F} /qb-' -WindowStyle 'Hidden' -Wait
        Write-Host -Object $('Removing the old documentation links.')
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Fuji Synapse 5 Training.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Fuji Synapse 5 Training.lnk"}
        Write-Host -Object $('Removing the Content Manager icon.')
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Content Manager.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Content Manager.lnk"}
        Write-Host -Object $('Removing old tools.')
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\ScanKill.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\ScanKill.lnk"}
        Write-Host -Object $('Removing the Fuji Synapse 5 Web link.')
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Synapse 5 Web.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Synapse 5 Web.lnk"}
        Write-Host -Object $('Removing Registry keys.')
        IF (Test-Path -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web") {Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web"}
        Write-Host -Object $('Removing any Scheduled Task for Fuji Synapse.')
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/DELETE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE"' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/DELETE /F /TN "Piedmont\UNINSTALL-SYNAPSE44"' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/DELETE /F /TN "Piedmont\SYSTEM-REBOOT"' -WindowStyle 'Hidden' -Wait
    }


    #Main sub for processing.
    Invoke-Command -ScriptBlock {
        Clear-Host
        $LocalHostName = HOSTNAME
        IF ($MassDriver.Debug) {Write-Host -Object $('The local hostname is: ' + $LocalHostName + '. The target that was passed is: '  + $ComputerName)}
        IF ($MassDriver.Debug) {Pause}
        IF ($ComputerName -eq $LocalHostName) {
            #Running commands on local workstation.
            Invoke-Command -ScriptBlock $UninstallEverything
        } ELSE {
            #Running commands on remote workstation.
            Invoke-Command -ComputerName $ComputerName -ScriptBlock $UninstallEverything
        }
        IF ($MassDriver.Debug) {'FujiSynapseUninstall has completed.'}
        IF ($MassDriver.Debug) {Pause}
    }
}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseInstallAgentPROD' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter()][string]$ComputerName
    )


    #The main code block that installs everything for Fuji Synapse Agent PROD.
    $InstallAgentPROD = {
        Write-Host -Object $('Exiting WMI.')
        IF (Get-Process -Name 'msiexec.exe' -ErrorAction 'SilentlyContinue') {Stop-Process "msiexec.exe" -Force}
        Write-Host -Object $('Installing the Fuji Synapse 3D component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\InstallHelperSetup.msi"" ALLUSERS=1 /qb-" -Wait
        Write-Host -Object $('Installing the Dynamic Web HTML5 component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\DynamicWebTWAINHTML5Edition.msi"" ALLUSERS=1 /qb-" -Wait
        Write-Host -Object $('Installing the Fuji Synapse Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\SynapseWorkstationEx.msi"" CODEBASE=""http://farmcsyn.piedmonthospital.org/"" VERIFY_INSTALLATION=0 INSTALL_DESKTOP_AGENT=1 ALLUSERS=1 /qb-" -Wait
        Write-Host -Object $('Adding the startup batch file.')
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/CREATE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE" /RU "SYSTEM" /RL HIGHEST /SC ONSTART /TR "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Files\Fuji-Synapse-XML.bat"' -Wait
    }


    #Main sub for processing.
    Invoke-Command -ScriptBlock {
        Clear-Host
        $LocalHostName = HOSTNAME
        IF ($MassDriver.Debug) {Write-Host -Object $('The local hostname is: ' + $LocalHostName + '. The target that was passed is: '  + $ComputerName)}
        IF ($MassDriver.Debug) {Pause}
        #Invoke-Command -ScriptBlock {Start-Process -FilePath 'C:\Windows\system32\ROBOCOPY.EXE' -ArgumentList """$($MassDriver.SourceRepository)\$($MassDriver.ActiveSynapseName)"" ""\\$ComputerName\C$\INSTALLS\$($MassDriver.ActiveSynapseName)"" /E /XD ""$($MassDriver.SourceRepository)\$($MassDriver.ActiveSynapseName)\Extras""" -Wait}
        Invoke-Command -ScriptBlock {$MassDriver.FujiSynapseCopy($ComputerName)}
        Invoke-Command -ScriptBlock {$MassDriver.FujiSynapseUninstall($ComputerName)}
        IF ($ComputerName -eq $LocalHostName) {
            #Running commands on local workstation.
            Invoke-Command -ScriptBlock $InstallAgentPROD
        } ELSE {
            #Running commands on remote workstation.
            Invoke-Command -ComputerName $ComputerName -ScriptBlock $InstallAgentPROD
        }
        Invoke-Command -ScriptBlock {$MassDriver.FujiSynapseRepair($ComputerName)}
        IF ($MassDriver.Debug) {'FujiSynapseInstallAgentPROD has completed.'}
        IF ($MassDriver.Debug) {Pause}
    }
}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseInstallWebPROD' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter()][string]$ComputerName
    )


    #The main code block that installs everything for Fuji Synapse Web PROD.
    $InstallWebPROD = {
        Write-Host -Object $('Installing the Fuji Synapse 3D component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\InstallHelperSetup.msi"" ALLUSERS=1 /qb-" -Wait

        Write-Host -Object $('Installing the Dynamic Web HTML5 component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\DynamicWebTWAINHTML5Edition.msi"" ALLUSERS=1 /qb-" -Wait

        Write-Host -Object $('Installing the Web icon.')
        Copy-Item -Path "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Icon\fujiFilm.ico" -Destination "$($env:PROGRAMFILES)\Fujifilm Medical Systems\Icon" -Force
        Copy-Item -Path "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Desktop\Synapse 5 Web.lnk" -Destination "C:\Users\Public\Desktop" -Force

        Write-Host -Object $('Add values for Settings/Apps.')
        New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" -Name "DisplayName" -PropertyType 'String' -Value 'Fuji Synapse 5 Web' -Force
        New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" -Name "DisplayVersion" -PropertyType 'String' -Value '5.7' -Force
        New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" -Name "DisplayIcon" -PropertyType 'String' -Value '%ProgramFiles%\\Fujifilm Medical Systems\\Icon\\FujiFilm.ico' -Force
        New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" -Name "NoModify" -PropertyType 'Dword' -Value 1 -Force
        New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web" -Name "NoRepair" -PropertyType 'Dword' -Value 1 -Force
    }


    #Main sub for processing.
    Invoke-Command -ScriptBlock {
        Clear-Host
        $LocalHostName = HOSTNAME
        IF ($MassDriver.Debug) {Write-Host -Object $('The local hostname is: ' + $LocalHostName + '. The target that was passed is: '  + $ComputerName)}
        IF ($MassDriver.Debug) {Pause}
        Invoke-Command -ScriptBlock {$MassDriver.FujiSynapseCopy($ComputerName)}
        Invoke-Command -ScriptBlock {$MassDriver.FujiSynapseUninstall($ComputerName)}
        IF ($ComputerName -eq $LocalHostName) {
            #Running commands on local workstation.
            Invoke-Command -ScriptBlock $InstallWebPROD
        } ELSE {
            #Running commands on remote workstation.
            Invoke-Command -ComputerName $ComputerName -ScriptBlock $InstallWebPROD
        }
        Invoke-Command -ScriptBlock {$MassDriver.FujiSynapseRepair($ComputerName)}
        IF ($MassDriver.Debug) {'FujiSynapseInstallAgentPROD has completed.'}
        IF ($MassDriver.Debug) {Pause}
    }
}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseRepair' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter()][string]$ComputerName
    )


    #The main code block that installs everything for Fuji Synapse Agent PROD.
    $RepairEverything = {
        Write-Host -Object $('Disable UAC')
        New-ItemProperty -Path "HKLM\Software\Microsoft\Windows\CurrentVersion\policies\system" -Name "EnableLUA" -PropertyType 'Dword' -Value 0 -Force

        Write-Host -Object $('Make Synapse Desktop Agent always use IE.')
        Invoke-Command -ScriptBlock {
            New-ItemProperty -Path "HKEY_CURRENT_USER\Software\Fuji Medical Systems USA\Synapse\DesktopAgent" -Name "SelectedBrowser" -PropertyType 'String' -Value 'IE' -Force
            FOREACH ($UserProfile IN $(Get-ChildItem -Path 'C:\Users')) {
                IF (($UserProfile -LIKE 'PUBLIC') -OR ($UserProfile -LIKE 'wks_admin')) {BREAK}
                Start-Process -FilePath 'C:\Windows\System32\REG.EXE' -ArgumentList "LOAD HKLM\TempHive ""C:\USERS\$UserProfile\NTUSER.DAT""" -WindowStyle 'Hidden' -Wait
                New-ItemProperty -Path "HKLM\TempHive\Software\Fuji Medical Systems USA\Synapse\DesktopAgent" -Name "SelectedBrowser" -PropertyType 'String' -Value 'IE' -Force
                Start-Process -FilePath 'C:\Windows\System32\REG.EXE' -ArgumentList "UNLOAD HKLM\TempHive" -WindowStyle 'Hidden' -Wait
            }
        }
        
        Write-Host -Object $('Adding Synapse to Trusted Sites.')
        Invoke-Command -ScriptBlock {        
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" -Name "1206" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" -Name "1206" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name "1206" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1206" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" -Name "1206" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" -Name "2102" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" -Name "2102" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name "2102" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "2102" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" -Name "2102" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\pacs.piedmont.org" -Name "http" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\pacs.piedmont.org" -Name "https" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\farmcsyn" -Name "http" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\farmcsyn" -Name "https" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\phcmx137" -Name "http" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\phcmx137" -Name "https" -PropertyType 'Dword' -Value 2 -Force

            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmonthospital.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmonthospital.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmont.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmont.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest" -Name "*" -PropertyType 'Dword' -Value 2 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137" -Name "*" -PropertyType 'Dword' -Value 2 -Force        

            FOREACH ($UserProfile IN $(Get-ChildItem -Path 'C:\Users')) {
                IF (($UserProfile -LIKE 'PUBLIC') -OR ($UserProfile -LIKE 'wks_admin')) {BREAK}
                Start-Process -FilePath 'C:\Windows\System32\REG.EXE' -ArgumentList "LOAD HKLM\TempHive ""C:\USERS\$UserProfile\NTUSER.DAT""" -WindowStyle 'Hidden' -Wait
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmonthospital.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmonthospital.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest.piedmont.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137.piedmont.org" -Name "*" -PropertyType 'Dword' -Value 2 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\synapsetest" -Name "*" -PropertyType 'Dword' -Value 2 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\phcmx137" -Name "*" -PropertyType 'Dword' -Value 2 -Force        
                Start-Process -FilePath 'C:\Windows\System32\REG.EXE' -ArgumentList "UNLOAD HKLM\TempHive" -WindowStyle 'Hidden' -Wait
            }
        }

        Write-Host -Object $('Disable IE Intranet sites in compatibility mode.')
        New-ItemProperty -Path "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" -Name "IntranetCompatibilityMode" -PropertyType 'Dword' -Value 0 -Force

        Write-Host -Object $('Make IE default to 64 bit')
        New-ItemProperty -Path "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "TabProcGrowth" -PropertyType 'Dword' -Value 1 -Force

        Write-Host -Object $('Allow Pop-Ups.')
        Invoke-Command -ScriptBlock {        
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\New Windows" -Name "ListBox_Support_Allow" -PropertyType 'Dword' -Value 1 -Force
            New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\New Windows\Allow" -Name "*.farmcsyn" -PropertyType 'String' -Value "*.farmcsyn" -Force
        }

        Write-Host -Object $('Configureing Adobe Permissions.')
        Invoke-Command -ScriptBlock {        
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" -Name "bEnhancedSecurityStandalone" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" -Name "bEnhancedSecurityInBrowser" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" -Name "iProtectedView" -PropertyType 'Dword' -Value 0 -Force
            New-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\Privileged" -Name "bProtectedMode" -PropertyType 'Dword' -Value 0 -Force
            FOREACH ($UserProfile IN $(Get-ChildItem -Path 'C:\Users')) {
                IF (($UserProfile -LIKE 'PUBLIC') -OR ($UserProfile -LIKE 'wks_admin')) {BREAK}
                Start-Process -FilePath 'C:\Windows\System32\REG.EXE' -ArgumentList "LOAD HKLM\TempHive ""C:\USERS\$UserProfile\NTUSER.DAT""" -WindowStyle 'Hidden' -Wait
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" -Name "bEnhancedSecurityStandalone" -PropertyType 'Dword' -Value 0 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" -Name "bEnhancedSecurityInBrowser" -PropertyType 'Dword' -Value 0 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager" -Name "iProtectedView" -PropertyType 'Dword' -Value 0 -Force
                New-ItemProperty -Path "HKLM\TempHive\SOFTWARE\Adobe\Acrobat Reader\DC\Privileged" -Name "bProtectedMode" -PropertyType 'Dword' -Value 0 -Force
                Start-Process -FilePath 'C:\Windows\System32\REG.EXE' -ArgumentList "UNLOAD HKLM\TempHive" -WindowStyle 'Hidden' -Wait
            }
        }

        Write-Host -Object $('Adding the documentation link.')
        Copy-Item -Path "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Desktop\Piedmont Technologist Teaching Aide.lnk" -Destination "C:\Users\Public\Desktop" -Force

        Write-Host -Object $('Adding the Content Manager link.')
        Copy-Item -Path "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Desktop\Content Manager.lnk" -Destination "C:\Users\Public\Desktop" -Force

        Write-Host -Object $('Create cache Folders for IE.')
        Invoke-Command -ScriptBlock {        
            New-Item -Path "C:\DATA" -Name "FujiHybrid" -ItemType "directory" -Force | Out-Null
            $NewAcl = Get-Acl -Path "C:\DATA"
            $NewAclRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule("Everyone", "Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
            $NewAcl.SetAccessRule($NewAclRule)
            Set-ACL -Path "C:\DATA" -AclObject $NewAcl
        }
    }


    #Main sub for processing.
    Invoke-Command -ScriptBlock {
        Clear-Host
        $LocalHostName = HOSTNAME
        IF ($MassDriver.Debug) {Write-Host -Object $('The local hostname is: ' + $LocalHostName + '. The target that was passed is: '  + $ComputerName)}
        IF ($MassDriver.Debug) {Pause}
        IF ($ComputerName -eq $LocalHostName) {
            #Running commands on local workstation.
            Invoke-Command -ScriptBlock $RepairEverything
        } ELSE {
            #Running commands on remote workstation.
            Invoke-Command -ComputerName $ComputerName -ScriptBlock $RepairEverything
        }
        IF ($MassDriver.Debug) {'FujiSynapseRepair has completed.'}
        IF ($MassDriver.Debug) {Pause}
    }
}


#Write the main titlebar.
#Invoke-Command -ScriptBlock {
    Clear-Host
    Write-Host -Object $('= Fuji CD Uploader 5.7.220 ===================================================')
    Write-Host -Object $(' 1. PAH                           2. PAR'
    Write-Host -Object $(' 3. PCH                           4. PCM'
    Write-Host -Object $(' 5. PCN                           6. PEH'
    Write-Host -Object $(' 7. PFH                           8. PHH'
    Write-Host -Object $(' 9. PMH                          10. PMM'
    Write-Host -Object $('11. PNH                          12. PNTH'
    Write-Host -Object $('13. POA                          14. PRH'
    Write-Host -Object $('15. PWH                          16. PPG'
    Write-Host -Object $('==============================================================================')
    Write-Host -Object $('20. Uninstall Fuji CD Uploader 5.7.220')
    Write-Host -Object $('==============================================================================')
    $ActionInput = Read-Host "Please make a selection"
    Write-Host -Object $('==============================================================================')
    $TargetInput = Read-Host "Enter the PC to target(leave blank for local)"
    IF ($TargetInput -eq '') {$TargetInput = HOSTNAME}
    IF ($FujiCDUploader.Debug) {Write-Host -Object $TargetInput}
    IF ($FujiCDUploader.Debug) {PAUSE}
        
    #Perform task based off of the selection.
    SWITCH ($ActionInput) {
        '1' {$FujiCDUploader.InstallPAH($TargetInput)}
        '2' {$FujiCDUploader.InstallPAR($TargetInput)}
        '3' {$FujiCDUploader.InstallPCH($TargetInput)}
        DEFAULT {RETURN}
    }
#}
