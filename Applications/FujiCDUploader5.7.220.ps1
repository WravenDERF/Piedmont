$FujiCDUploader = [PSCustomObject]@{
    'Vendor' = [string]'Fuji'
    'Name' = [string]'CD Uploader'
    'Version' = [string]'5.7.220'
    'NetworkSource' = [string]'\\PHCMS01\share_data\PHC\Imaging\FredTest'
    'LocalSource' = [string]'C:\INSTALLS'
    'Debug' = [bool]$false
    'MenuArray' = New-Object System.Collections.ArrayList
}




Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'Copy' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    
    #Copy source files to the destination.
    [string]$NetworkSourceFiles = "$($MassDriver.NetworkSource)\$($MassDriver.Vendor) $($MassDriver.Name) $($MassDriver.Version)"
    [string]$DestinationSourceFiles = "\\$ComputerName\C$\INSTALLS\$($MassDriver.Vendor) $($MassDriver.Name) $($MassDriver.Version)"
    Invoke-Command -ScriptBlock {Start-Process -FilePath 'C:\Windows\system32\ROBOCOPY.EXE' -ArgumentList """$NetworkSourceFiles"" ""$DestinationSourceFiles"" /E /XD ""$DestinationSourceFiles\Extras""" -Wait}
}




Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'Install' -Force -Value {
        #These are the parameters needed.
        PARAM (
                [Parameter(Mandatory=$True)][string]$ComputerName,
                [Parameter(Mandatory=$True)][string]$Build
        )

        #The main code block that uninstalls everything.
        $Install = {
                #These are the parameters needed.
                PARAM (
                        [Parameter(Mandatory=$True)][string]$Build
                )
                
                #Install the main application.
                Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\CDImportInstaller.msi"" /qb-" -Wait
                #Copy the correct campus data.
                Copy-Item -Path "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Settings\$Build\CDImport.ini" -Destination "C:\Users\Public\Desktop" -Force
                #change Add/remove Programs to match the campus.
                New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" -Name "DisplayName" -PropertyType 'String' -Value "Synapse CDImport ($Build)" -Force
        }

        #Main sub for processing.
        Invoke-Command -ScriptBlock {
                Clear-Host
                $LocalHostName = HOSTNAME
                IF ($FujiCDUploader.Debug) {Write-Host -Object $('The local hostname is: ' + $LocalHostName + '. The target that was passed is: '  + $ComputerName)}
                IF ($FujiCDUploader.Debug) {Pause}
                
                #Check if a list was passed.
                IF (Test-Path -Path $ComputerName) {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a list.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        
                        #Iterate through list and hit each name.
                        $FileContents = Get-Content -Path $TargetInput
                        FOREACH ($TargetPC in $FileContents) {
                                #Check if local computer.
                                IF ($ComputerName -eq $LocalHostName) {
                                    #Running commands on local workstation.
                                    Invoke-Command -ScriptBlock {$FujiCDUploader.Uninstall($TargetInput)}
                                    Invoke-Command -ScriptBlock $Install -ArgumentList $Build
                                } ELSE {
                                    #Running commands on remote workstation.
                                    Invoke-Command -ComputerName $ComputerName -ScriptBlock {$FujiCDUploader.Uninstall($TargetInput)}
                                    Invoke-Command -ComputerName $ComputerName -ScriptBlock $Install -ArgumentList $Build
                                }
                        }
                } ELSE {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a single computer.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        
                        #Check if local computer.
                        IF ($ComputerName -eq $LocalHostName) {
                            #Running commands on local workstation.
                            Invoke-Command -ScriptBlock {$FujiCDUploader.Uninstall($TargetInput)}
                            Invoke-Command -ScriptBlock $Install -ArgumentList $Build
                        } ELSE {
                            #Running commands on remote workstation.
                            Invoke-Command -ComputerName $ComputerName -ScriptBlock {$FujiCDUploader.Uninstall($TargetInput)}
                            Invoke-Command -ComputerName $ComputerName -ScriptBlock $Install -ArgumentList $Build
                        }
                }
                IF ($FujiCDUploader.Debug) {Write-Host -Object $('FujiCDUploader.Install has completed.')}
                IF ($FujiCDUploader.Debug) {Pause}
        }
}




Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'Uninstall' -Force -Value {
        #These are the parameters needed.
        PARAM (
                [Parameter(Mandatory=$True)][string]$ComputerName,
                [Parameter(Mandatory=$True)][string]$Build
        )

        #The main code block that uninstalls everything.
        $Uninstall = {
                #These are the parameters needed.
                PARAM (
                        [Parameter(Mandatory=$True)][string]$Build
                )
                
                Write-Host -Object $('Exiting Fuji CD Burner')
                IF (Get-Process -Name 'CDImport.exe' -ErrorAction 'SilentlyContinue') {Stop-Process "CDImport.exe" -Force}
                
                Write-Host -Object $('Uninstalling Fuji CD Uploader 1.1')
                Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/x {D5D17C51-EE13-483D-80D4-1A29D9D25BB9} /qb-" -Wait
                
                Write-Host -Object $('Uninstalling Fuji CD Uploader 5.3')
                Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/x {88B19E2B-E825-4C70-A620-EE6280DD4042} /qb-" -Wait
                
                Write-Host -Object $('Uninstalling Fuji CD Uploader 5.7.220')
                Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/x {D7FCFDCF-CFB8-4320-B30E-6599931A1CC1} /qb-" -Wait
                
                Write-Host -Object $('Removing Desktop Icon')
                IF (Test-Path -Path "$Env:PUBLIC\DESKTOP\Centricity CDImport.lnk") {Remove-Item -Path "$Env:PUBLIC\DESKTOP\Centricity CDImport.lnk"}
        }

        #Main sub for processing.
        Invoke-Command -ScriptBlock {
                Clear-Host
                $LocalHostName = HOSTNAME
                IF ($FujiCDUploader.Debug) {Write-Host -Object $('The local hostname is: ' + $LocalHostName + '. The target that was passed is: '  + $ComputerName)}
                IF ($FujiCDUploader.Debug) {Pause}
                
                #Check if a list was passed.
                IF (Test-Path -Path $ComputerName) {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a list.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        
                        #Iterate through list and hit each name.
                        $FileContents = Get-Content -Path $TargetInput
                        FOREACH ($TargetPC in $FileContents) {
                                #Check if local computer.
                                IF ($ComputerName -eq $LocalHostName) {
                                    #Running commands on local workstation.
                                    Invoke-Command -ScriptBlock $Install -ArgumentList $Build
                                } ELSE {
                                    #Running commands on remote workstation.
                                    Invoke-Command -ComputerName $ComputerName -ScriptBlock $Install -ArgumentList $Build
                                }
                        }
                } ELSE {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a single computer.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        
                        #Check if local computer.
                        IF ($ComputerName -eq $LocalHostName) {
                            #Running commands on local workstation.
                            Invoke-Command -ScriptBlock $Install -ArgumentList $Build
                        } ELSE {
                            #Running commands on remote workstation.
                            Invoke-Command -ComputerName $ComputerName -ScriptBlock $Install -ArgumentList $Build
                        }
                }
                IF ($FujiCDUploader.Debug) {Write-Host -Object $('FujiCDUploader.Uninstall has completed.')}  
                IF ($FujiCDUploader.Debug) {Pause}
        }
}




#Write the main titlebar.
Clear-Host
Write-Host -Object $('= Install Fuji CD Uploader 5.7.220 ===========================================')
Write-Host -Object $(' 1. PAH                           2. PAR'
Write-Host -Object $(' 3. PCH                           4. PCM'
Write-Host -Object $(' 5. PCN                           6. PEH'
Write-Host -Object $(' 7. PFH                           8. PHH'
Write-Host -Object $(' 9. PMH                          10. PMM'
Write-Host -Object $('11. PNH                          12. PNTH'
Write-Host -Object $('13. POA                          14. PPG'
Write-Host -Object $('15. PRH                          16. PWH'
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
        '1' {$FujiCDUploader.Install($TargetInput, 'PAH')}
        '2' {$FujiCDUploader.Install($TargetInput, 'PAR')}
        '3' {$FujiCDUploader.Install($TargetInput, 'PCH')}
        '4' {$FujiCDUploader.Install($TargetInput, 'PCM')}
        '5' {$FujiCDUploader.Install($TargetInput, 'PCN')}
        '6' {$FujiCDUploader.Install($TargetInput, 'PEH')}
        '7' {$FujiCDUploader.Install($TargetInput, 'PFH')}
        '8' {$FujiCDUploader.Install($TargetInput, 'PHH')}
        '9' {$FujiCDUploader.Install($TargetInput, 'PMH')}
        '10' {$FujiCDUploader.Install($TargetInput, 'PMM')}
        '11' {$FujiCDUploader.Install($TargetInput, 'PNH')}
        '12' {$FujiCDUploader.Install($TargetInput, 'PNTH')}
        '13' {$FujiCDUploader.Install($TargetInput, 'POA')}
        '14' {$FujiCDUploader.Install($TargetInput, 'PRH')}
        '15' {$FujiCDUploader.Install($TargetInput, 'PWH')}
        '16' {$FujiCDUploader.Install($TargetInput, 'PPG')}
        '20' {$FujiCDUploader.Uninstall($TargetInput)}
        DEFAULT {RETURN}
}
