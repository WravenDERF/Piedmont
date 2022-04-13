$MassDriver = [PSCustomObject]@{
    'Vendor' = 'infoSpark'
    'Name' = 'MassDriver'
    'Version' = 'Beta 2022.04.11'
    'SourceRepository' = [string]'\\PHCMS01\share_data\PHC\Imaging\FredTest'
    'ActiveSynapseName' = [string]'Fuji Synapse 5.7.220'
    'Debug' = $true
    'MenuArray' = New-Object System.Collections.ArrayList
}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseUninstall' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter()][string]$ComputerName
    )


    #The main code block that uninstalls everything.
    $UninstallEverything = {
        Write-Host -Object $('Exiting Fuji Desktop Agent.')
        IF (Get-Process -Name 'Fujifilm.Synapse.Agent.exe' -ErrorAction 'SilentlyContinue') {Stop-Process "Fujifilm.Synapse.Agent.exe" -Force}
        Write-Host -Object $('Uninstalling the HTML5 TWAIN Web component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {7BF08D44-2176-4A7B-A8B7-8E4DC7424D5D} /qb-' -Wait
        Write-Host -Object $('Uninstalling the Fuji Synapse 3D component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C21DF62B-3850-4977-8061-AD346FB14883} /qb-' -Wait
        Write-Host -Object $('Uninstalling the MPR Fusion component.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {B6729277-10DA-4A2E-BABA-6B50002C5E57} /qb-' -Wait
        Write-Host -Object $('Uninstalling unknown Fuji Synapse version.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {BFE00D46-C1CF-4754-A51E-A4731F967992} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.200.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {D2DEA580-C6B1-4A8D-820E-46E93059268B} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.210.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {F71DB8E8-D8DA-4814-9255-10C7C52BAA30} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.360.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {D5BF7D6D-152E-4FBF-B2EE-DA5262B700A7} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 4.4.375.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {BA934C23-8A49-46F5-ABED-A1E00727A97B} REMOVECONFIGURATION=1 REMOVEDATASOURCE=1 /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 5.5 Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C3FE4D19-8346-466A-B3EF-6A13867E8FDD} /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 5.7.200 Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {64D3590F-3BF8-4E61-994F-9AFB89EA6176} /qb-' -Wait
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {56839E35-532F-479D-8BB9-64D3546DF819} /qb-' -Wait
        Write-Host -Object $('Uninstalling Fuji Synapse 5.7.220 Desktop Agent.')
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {E6EB995F-F572-4DB9-A61A-0C3E6D11F75F} /qb-' -Wait
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
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/DELETE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE"' -Wait
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/DELETE /F /TN "Piedmont\UNINSTALL-SYNAPSE44"' -Wait
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList '/DELETE /F /TN "Piedmont\SYSTEM-REBOOT"' -Wait
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
        Write-Host -Object $('FredTest0')
        IF ($MassDriver.Debug) {Pause}
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
        Invoke-Command -ScriptBlock {Start-Process -FilePath 'C:\Windows\system32\ROBOCOPY.EXE' -ArgumentList """$($MassDriver.SourceRepository)\$($MassDriver.ActiveSynapseName)"" ""\\$ComputerName\C$\INSTALLS\$($MassDriver.ActiveSynapseName)"" /E /XD ""$($MassDriver.SourceRepository)\$($MassDriver.ActiveSynapseName)\Extras""" -Wait}
        Invoke-Command -ScriptBlock $MassDriver.FujiSynapseUninstall($ComputerName)
        Write-Host -Object $('FredTest2')
        IF ($MassDriver.Debug) {Pause}
        IF ($ComputerName -eq $LocalHostName) {
            #Running commands on local workstation.
            Invoke-Command -ScriptBlock $InstallAgentPROD
            Write-Host -Object $('FredTest1')
            IF ($MassDriver.Debug) {Pause}
        } ELSE {
            #Running commands on remote workstation.
            Invoke-Command -ComputerName $ComputerName -ScriptBlock $InstallAgentPROD
        }
        IF ($MassDriver.Debug) {Pause}
    }
}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseMenu' -Force -Value {
    <#Test code to make the computer talk to me!
    Invoke-Command -ScriptBlock {
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $speak.GetInstalledVoices() | ForEach{$_.VoiceInfo}
        $speak.SelectVoice('Microsoft Zira Desktop')
        $speak.Rate = -1
        $speak.Speak("This is the new installer for Fuji Synapse!")
    }
    #>

      #Display the Fuji Synapse menu.
      DO {
        #Write the main titlebar.
        Clear-Host
        Write-Host -Object $('= Fuji Synapse ===============================================================')
        Write-Host -Object $(' 0. Exit')
        Write-Host -Object $('==============================================================================')
        Write-Host -Object $(' 1. Install Fuji Synapse 5.7.220 Desktop Agent (PROD)')
        Write-Host -Object $(' 2. Repair Fuji Synapse 5.7.220 Desktop Agent (PROD)')
        Write-Host -Object $(' 3. Uninstall Fuji Synapse 5.7.220 Desktop Agent (PROD)')
        Write-Host -Object $('==============================================================================')
        Write-Host -Object $(' 4. Install Fuji Synapse 5.7.220 Web Icon (PROD)')
        Write-Host -Object $(' 5. Repair Fuji Synapse 5.7.220 Web Icon (PROD)')
        Write-Host -Object $(' 6. Uninstall Fuji Synapse 5.7.220 Web Icon (PROD)')
        Write-Host -Object $('==============================================================================')
        Write-Host -Object $(' 7. Install Fuji Synapse 5.7.220 Desktop Agent (TEST)')
        Write-Host -Object $(' 8. Repair Fuji Synapse 5.7.220 Web Icon (TEST)')
        Write-Host -Object $(' 9. Uninstall Fuji Synapse 5.7.220 Web Icon (TEST)')
        Write-Host -Object $('==============================================================================')
        $ActionInput = Read-Host "Please make a selection"
        Write-Host -Object $('==============================================================================')
        $TargetInput = Read-Host "Enter the PC to target(leave blank for local)"
        IF ($TargetInput -eq '') {$TargetInput = HOSTNAME}
        IF ($MassDriver.Debug) {Write-Host -Object $TargetInput}
        IF ($MassDriver.Debug) {PAUSE}
        
        #Perform task based off of the selection.
        SWITCH ($ActionInput) {
          '0' {RETURN}
          '1' {$MassDriver.FujiSynapseInstallAgentPROD($TargetInput)}
          DEFAULT {. .\POWERSHELL\INFOSPARK.NAVI.PS1}
        }
      } UNTIL ($SelectionInput -eq '0')
    }


#Display the main menu.
DO {
    #Write the main titlebar.
    Clear-Host
    Write-Host -Object $('= FredTest Menu ===============================================================')
    Write-Host -Object $(' 0. Exit')
    Write-Host -Object $(' 1. Fuji Synapse 5.7.220')
    Write-Host -Object $('===============================================================================')
    $SelectionInput = Read-Host "Please make a selection"


    #Perform task based off of the selection.
    SWITCH ($SelectionInput) {
        '0' {RETURN}
        '1' {$MassDriver.FujiSynapseMenu()}
        DEFAULT {. .\POWERSHELL\INFOSPARK.NAVI.PS1}
    }
} UNTIL ($SelectionInput -eq '0')
