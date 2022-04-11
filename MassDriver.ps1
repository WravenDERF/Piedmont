$MassDriver = [PSCustomObject]@{
    'Vendor' = 'infoSpark'
    'Name' = 'MassDriver'
    'Version' = 'Beta 2022.04.11'
    'Debug' = $true
    'MenuArray' = New-Object System.Collections.ArrayList
}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseUninstall' -Force -Value {


    PARAM (
        [Parameter()][string]$ComputerName
    )


    Clear-Host
    IF ($MassDriver.Debug) {Write-Host -Object $ComputerName}
    IF ($MassDriver.Debug) {Write-Host -Object $ComputerName}
    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        #Stop the Agent Desktop if it is running.
        IF (Get-Process -Name 'Fujifilm.Synapse.Agent.exe' -ErrorAction 'SilentlyContinue') {Stop-Process "Fujifilm.Synapse.Agent.exe" -Force}
        #Uninstall the HTML5 TWAIN Web component.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {7BF08D44-2176-4A7B-A8B7-8E4DC7424D5D} /qb-' -Wait
        #Uninstall the Installation Helper 1.3.1.0 component.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C21DF62B-3850-4977-8061-AD346FB14883} /qb-' -Wait
        #Uninstall the MPR Fusion component.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {B6729277-10DA-4A2E-BABA-6B50002C5E57} /qb-' -Wait
        
        #Uninstall the Fuji Synapse 4.4.200.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C3FE4D19-8346-466A-B3EF-6A13867E8FDD} /qb-' -Wait
        
        #Uninstall the Fuji Synapse 5.5 Desktop Agent.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {C3FE4D19-8346-466A-B3EF-6A13867E8FDD} /qb-' -Wait
        #Uninstall the Fuji Synapse 5.7.200 Desktop Agent.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {64D3590F-3BF8-4E61-994F-9AFB89EA6176} /qb-' -Wait
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {56839E35-532F-479D-8BB9-64D3546DF819} /qb-' -Wait
        #Uninstall the Fuji Synapse 5.7.220 Desktop Agent.
        Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList '/x {E6EB995F-F572-4DB9-A61A-0C3E6D11F75F} /qb-' -Wait
        #Uninstall documentation links.
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Fuji Synapse 5 Training.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Fuji Synapse 5 Training.lnk"}
        #Uninstall Content Manager icon.
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Content Manager.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Content Manager.lnk"}
        #Uninstall old tools.
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\ScanKill.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\ScanKill.lnk"}
        #Uninstall Fuji Web Icon.
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Synapse 5 Web.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Synapse 5 Web.lnk"}
        #Remove registry keys.
        IF (Test-Path -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web") {Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fuji Synapse 5 Web"}
        #Remove Scheduled Task for PS360 Logout.
        Start-Process -FilePath 'C:\Windows\system32\SCHTASKS.EXE' -ArgumentList /DELETE /F /TN "Piedmont\LOGOUT-FUJISYNAPSE" -Wait
    }

}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseInstallAgentPROD' -Force -Value {


    PARAM (
        [Parameter()][string]$ComputerName
    )


    Clear-Host
    IF ($MassDriver.Debug) {Write-Host -Object $ComputerName}
    IF ($MassDriver.Debug) {Write-Host -Object $ComputerName}
    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    
    }

}


Add-Member -InputObject $MassDriver -MemberType 'ScriptMethod' -Name 'FujiSynapseMenu' -Force -Value {


      #Display the Fuji Synapse menu.
      IF ($MassDriver.Debug) {PAUSE}
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

        #Perform task based off of the selection.
        SWITCH ($ActionInput) {
          '0' {RETURN}
          '1' {$MassDriver.FujiSynapseInstallAgentPROD($TargetInput)}
          DEFAULT {. .\POWERSHELL\INFOSPARK.NAVI.PS1}
        }
      } UNTIL ($SelectionInput -eq '0')
    }


#Display the main menu.
IF ($MassDriver.Debug) {PAUSE}
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
