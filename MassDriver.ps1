$MassDriver = [PSCustomObject]@{
    'Vendor' = 'infoSpark'
    'Name' = 'MassDriver'
    'Version' = 'Beta 2022.04.11'
    'Debug' = $true
    'MenuArray' = New-Object System.Collections.ArrayList
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
        $SelectionInput = Read-Host "Please make a selection"


        #Perform task based off of the selection.
        SWITCH ($SelectionInput) {
          '0' {RETURN}
          '1' {$Tools.DisplayMainMenu()}
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
