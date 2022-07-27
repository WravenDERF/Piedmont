#C:\ProgramData\Microsoft\Windows\Start Menu\syngo.via


$Index = 0
$ListPath = 'G:\SyngoVIA.log'
$Workbook = Get-Content -Path $ListPath
$NetworkFile = '\\PHCMS01\Share_Data\PHC\Imaging\FredTest\Siemens.Syngo.VIA.6.4.VB40B.HF05.zip'
$LocalFile = 'C:\INSTALLS\Packages\Siemens.Syngo.VIA.6.4.VB40B.HF05.zip'
$LocalFolder = 'C:\INSTALLS\Siemens Syngo.VIA 6.4.VB40B_HF05'
$ExecuteMSI = 'C:\Windows\system32\MSIEXEC.EXE'
$ComputerList = New-Object System.Collections.ArrayList

$Copy = {
    IF ($Row -eq $ENV:COMPUTERNAME) {$TargetName = '.'} ELSE {$TargetName = $Row}
    Invoke-Command -ComputerName $TargetName -ScriptBlock {IF (-Not (Test-Path -Path "C:\INSTALLS\Packages")) {New-Item -ItemType 'Directory' -Path "C:\INSTALLS\Packages" -Force}}
    Start-BitsTransfer -Source $NetworkFile -Destination "\\$Row\C$\Installs\Packages"
    #Start-BitsTransfer -Source $NetworkFile -Destination "\\$Row\C$\Installs\Packages" -Asynchronous
    #Copy-Item -Path $NetworkFile -Destination "\\$Row\C$\Installs\Packages"
}

$InstallPrereqs = {

    #Installing .NET Framework 4.7.2...
    Invoke-Command -ComputerName $TargetName -ScriptBlock {Start-Process -FilePath "$Using:LocalFolder\Prereqs\DotNetFx472\NDP472-KB4038188-x86-x64-AllOS-ENU.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait}

    #Installing C++ 8.0...
    Invoke-Command -ComputerName $TargetName -ScriptBlock {
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc8redist\vcredist_x64.exe" -ArgumentList '/Q' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc8redist\vcredist_x86.exe" -ArgumentList '/Q' -WindowStyle 'Hidden' -Wait
    }

    #Installing C++ 10.0...
    Invoke-Command -ComputerName $TargetName -ScriptBlock {
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc10redist\vcredist_x64.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc10redist\vcredist_x86.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait
    }

    #Installing C++ 12.0...
    Invoke-Command -ComputerName $TargetName -ScriptBlock {
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc12redist\vcredist_x64.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc12redist\vcredist_x86.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait
    }

    #Installing C++ 14.0...
    Invoke-Command -ComputerName $TargetName -ScriptBlock {
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc14redist\vcredist_x64.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath "$Using:LocalFolder\Prereqs\vc14redist\vcredist_x86.exe" -ArgumentList '/passive /norestart' -WindowStyle 'Hidden' -Wait
    }
}

$Install = {

    #Installing...
    Invoke-Command -ComputerName $Row -ScriptBlock {
        Invoke-Command -ScriptBlock {Expand-Archive -Path $Using:LocalFile -DestinationPath $Using:LocalFolder -Force}

        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList "/i ""$Using:LocalFolder\Bootstrapper_syngo.via@phcma809.piedmonthospital.org.msi"" /qb-" -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList "/i ""$Using:LocalFolder\syngo.via_Client_syngo.via.msi"" /qb-" -WindowStyle 'Hidden' -Wait

        Copy-Item -Path "$Using:LocalFolder\Settings\ClientDeploymentContext.xml" -Destination "$Env:PROGRAMDATA\Siemens\syngo\DeploymentContexts" -Force
        Copy-Item -Path "$Using:LocalFolder\Desktop\Piedmont Technologist Teaching Aide.lnk" -Destination "$Env:PUBLIC\Desktop" -Force

        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via - Server Selection.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via - Server Selection.lnk" -Force}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via Client.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via Client.lnk" -Force}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Siemens Syngo.VIA Training.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Siemens Syngo.VIA Training.lnk" -Force}
    }

}

$Repair = {

    #Repairing Environment Variables...
    Invoke-Command -ComputerName $Row -ScriptBlock {
        $env:FEDA_LOOSE_WGL_ERROR_HANDLING = 'true'
        $env:FORCE_FEDATYPE = 'GDI'
        $env:MED_CONFIG_CACHE = 'false'
    }

    #Repairing Settings...
    Invoke-Command -ComputerName $Row -ScriptBlock {
        Copy-Item -Path "$Using:LocalFolder\Settings\ClientDeploymentContext.xml" -Destination "$Env:PROGRAMDATA\Siemens\syngo\DeploymentContexts" -Force
        Copy-Item -Path "$Using:LocalFolder\Desktop\Piedmont Technologist Teaching Aide.lnk" -Destination "$Env:PUBLIC\Desktop" -Force

        Get-ChildItem -Path "$Env:WINDIR\temp" | Remove-Item -Recurse -Force
        $NewAcl = Get-Acl -Path "$Env:WINDIR\Temp"
        $NewAclRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('BUILTIN\Users', 'Modify', "ContainerInherit, ObjectInherit", "None", "Allow") 
        $NewAcl.SetAccessRule($NewAclRule) 
        Set-ACL -Path "$Env:WINDIR\Temp" -AclObject $NewAcl

        IF (-Not (Test-Path -Path "$Env:PROGRAMDATA\Siemens")) {New-Item -ItemType 'Directory' -Path "$Env:PROGRAMDATA\Siemens" -Force}
        $NewAcl = Get-Acl -Path "$Env:PROGRAMDATA\Siemens"
        $NewAclRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('BUILTIN\Users', 'Modify', "ContainerInherit, ObjectInherit", "None", "Allow") 
        $NewAcl.SetAccessRule($NewAclRule) 
        Set-ACL -Path "$Env:PROGRAMDATA\Siemens" -AclObject $NewAcl

        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via - Server Selection.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via - Server Selection.lnk" -Force}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via Client.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via Client.lnk" -Force}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Siemens Syngo.VIA Training.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Siemens Syngo.VIA Training.lnk" -Force}
    }

}

$Uninstall = {
    #Unnstalling %APPNAME% Old Versions...
    Invoke-Command -ComputerName $Row -ScriptBlock {
        Get-Process -Name 'syngoClientBootstrapping.exe' -ErrorAction 'SilentlyContinue' | Stop-Process
        #Stop-Process -Name 'syngoClientBootstrapping.exe'
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {1B383085-36E0-4611-A26D-45142DE46BF9} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {DCB60D18-65B7-4483-B77C-50224F08718F} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {86DCA109-1173-0DD4-099E-984C1CB2D9EC} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {348E4A53-B74B-41DE-930C-C5D6F092C8DF} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {C0D3E13B-7BB1-4D70-8134-2ED473D63DFF} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {CDF29A84-755F-A2B7-07F7-C96451392278} /qb-' -WindowStyle 'Hidden' -Wait
        Start-Process -FilePath $Using:ExecuteMSI -ArgumentList '/x {7EB68AD3-2C71-428C-9FA3-AB08ECCD9285} /qb-' -WindowStyle 'Hidden' -Wait
        IF (Test-Path -Path "$Env:PROGRAMFILES(X86)\Siemens\syngo.via") {Remove-Item -Path "$Env:PROGRAMFILES(X86)\Siemens\syngo.via"}
    }

    #Removing Icons...
    Invoke-Command -ComputerName $Row -ScriptBlock {
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via - Single Sign On.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via - Single Sign On.lnk"}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\Siemens Syngo.VIA Training.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\Siemens Syngo.VIA Training.lnk"}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via - Single Sign On.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via - Single Sign On.lnk"}
        IF (Test-Path -Path "$Env:PUBLIC\Desktop\syngo.via Client.lnk") {Remove-Item -Path "$Env:PUBLIC\Desktop\syngo.via Client.lnk"}
    } -AsJob
}

$Verify = {
    IF (Test-Path -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\syngo.via') {$Computer.StillExist = $True}
}

FOREACH ($Row in $Workbook) {

    $Computer = [PSCustomObject]@{
        'Index' = $Index
        'Hostname' = $Row
        'Ping' = [string]$Null
        'Exist' = [bool]$False

    }


    $Computer.Index = $Index
    $Computer.Hostname = $Row

    IF (Test-Connection -ComputerName $Row -Count 1 -Quiet) {
        $Computer.Ping = 'Yes'
        #Invoke-Command -ScriptBlock $Copy
        #Invoke-Command -ScriptBlock $Uninstall
        #IF (Test-Path -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\syngo.via') {$Computer.StillExist = $True}
        #IF (Test-Path -Path "\\$Row\c$\INSTALLS\Packages\Siemens.Syngo.VIA.6.4.VB40B.HF05.zip") {$Computer.Exist = $True}
        #Invoke-Command -ScriptBlock $Install
        IF (Test-Path -Path "\\$Row\c$\Users\Public\Desktop\syngo.via - Single Sign On.lnk") {$Computer.Exist = $True}
        
        $BatchFile = '\\PHCMS01\Share_Data\PHC\Imaging\FredTest\Siemens Syngo.VIA 6.4.VB40B_HF05\Automated\Automated.bat'
        #IF (-Not (Test-Path -Path "\\$Row\c$\Users\Public\Desktop\syngo.via - Single Sign On.lnk")) {
        #    $Computer.Exist = $False
        #    Start-Process -FilePath $BatchFile -ArgumentList "BATCH 1 $Row"
        #}

    } ELSE {
        $Computer.Ping = 'No'

    }
    
    $Index = $Index + 1
    $Computer
}
