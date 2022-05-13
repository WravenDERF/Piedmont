$FujiCDUploader = [PSCustomObject]@{
    'Vendor' = [string]'Fuji'
    'Name' = [string]'CD Uploader'
    'Version' = [string]'5.7.220'
    'NetworkPackage' = [string]'\\PHCMS01\Share_Data\PHC\Imaging\Applications\FUJICDUPLOADER57.ZIP'
    'LocalPackage' = [string]'C:\INSTALLS\Packages\FUJICDUPLOADER57.ZIP'
    'LocalSource' = [string]'C:\INSTALLS\Fuji CD Uploader 5.7.220'
    'Debug' = [bool]$false
    'TargetList' = New-Object System.Collections.ArrayList
}




Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'Copy' -Force -Value {
    #These are the parameters needed.
    PARAM (
        [Parameter(Mandatory=$True)][string]$ComputerName = 'OISCV10Z'
    )
    
    Write-Host -Object $('Creating Folder for Packages')
    IF ($ComputerName -eq $ENV:COMPUTERNAME) {$TargetName = '.'} ELSE {$TargetName = $ComputerName}
    Invoke-Command -ComputerName $TargetName -ScriptBlock {IF (-Not (Test-Path -Path "C:\INSTALLS\Packages")) {New-Item -ItemType 'Directory' -Path "C:\INSTALLS\Packages" -Force}}

    Write-Host -Object $('Copying Package to Target Computer')
    Start-BitsTransfer -Source $($FujiCDUploader.NetworkPackage) -Destination "\\$ComputerName\C$\Installs\Packages"
    
    Write-Host -Object $('Extracting Package to Source')
    IF ($ComputerName -eq $ENV:COMPUTERNAME) {$TargetName = '.'} ELSE {$TargetName = $ComputerName}
    Invoke-Command -ComputerName $TargetName -ScriptBlock {Expand-Archive -Path $Using:FujiCDUploader.LocalPackage -DestinationPath $Using:FujiCDUploader.LocalSource -Force}
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
                Write-Host -Object $('Installing application')
                Start-Process -FilePath 'C:\Windows\system32\MSIEXEC.EXE' -ArgumentList "/i ""C:\INSTALLS\Fuji Synapse 5.7.220\x86\CDImportInstaller.msi"" /qb-" -Wait

                Write-Host -Object $('Copying Campus Settings')
                Copy-Item -Path "C:\INSTALLS\Fuji Synapse 5.7.220\Help\Settings\$Build\CDImport.ini" -Destination "C:\Users\Public\Desktop" -Force

                #change Add/remove Programs to match the campus.
                Write-Host -Object $('Change Add/remove Programs to match the campus')
                New-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D7FCFDCF-CFB8-4320-B30E-6599931A1CC1}" -Name "DisplayName" -PropertyType 'String' -Value "Synapse CDImport ($Build)" -Force
        }

        #Main sub for processing.
        Invoke-Command -ScriptBlock {
                Clear-Host

                IF ($FujiCDUploader.Debug) {Write-Host -Object $('The local hostname is: ' + $ENV:COMPUTERNAME + '. The target that was passed is: '  + $ComputerName)}
                IF ($FujiCDUploader.Debug) {Pause}
                
                #Check if a list was passed.
                IF (Test-Path -Path $ComputerName) {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a list.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        $FujiCDUploader.TargetList = Get-Content -Path $ComputerName
                } ELSE {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a single computer.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        $($FujiCDUploader.TargetList).Add($ComputerName)
                }

                #Iterate through list and hit each name.
                FOREACH ($TargetPC in $($FujiCDUploader.TargetList)) {

                    Invoke-Command -ScriptBlock {$FujiCDUploader.Copy($TargetPC)}
                    Invoke-Command -ScriptBlock {$FujiCDUploader.Uninstall($TargetPC)}
                    IF ($ComputerName -eq $ENV:COMPUTERNAME) {$TargetName = '.'} ELSE {$TargetName = $ComputerName}
                    Invoke-Command -ComputerName $TargetName -ScriptBlock $Install -ArgumentList $Build
                }

                IF ($FujiCDUploader.Debug) {Write-Host -Object $('FujiCDUploader.Install has completed.')}
                IF ($FujiCDUploader.Debug) {Pause}
        }
}




Add-Member -InputObject $FujiCDUploader -MemberType 'ScriptMethod' -Name 'Uninstall' -Force -Value {
        #These are the parameters needed.
        PARAM (
                [Parameter(Mandatory=$True)][string]$ComputerName
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

                IF ($FujiCDUploader.Debug) {Write-Host -Object $('The local hostname is: ' + $ENV:COMPUTERNAME + '. The target that was passed is: '  + $ComputerName)}
                IF ($FujiCDUploader.Debug) {Pause}
                
                #Check if a list was passed.
                IF (Test-Path -Path $ComputerName) {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a list.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        $FujiCDUploader.TargetList = Get-Content -Path $ComputerName
                } ELSE {
                        IF ($FujiCDUploader.Debug) {Write-Host -Object $("TargetInput:$ComputerName - This is a single computer.") -ForegroundColor Magenta}
                        IF ($FujiCDUploader.Debug) {PAUSE}
                        $($FujiCDUploader.TargetList).Add($ComputerName)
                }

                #Iterate through list and hit each name.
                FOREACH ($TargetPC in $($FujiCDUploader.TargetList)) {

                    Invoke-Command -ScriptBlock {$FujiCDUploader.Copy($TargetPC)}
                    IF ($ComputerName -eq $ENV:COMPUTERNAME) {$TargetName = '.'} ELSE {$TargetName = $ComputerName}
                    Invoke-Command -ComputerName $TargetName -ScriptBlock $Uninstall
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
