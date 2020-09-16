$ErrorActionPreference = 'SilentlyContinue'

#==============================
# download and install apps

# fix fReverseConnectMode
#New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name fReverseConnectMode -PropertyType DWORD -Value 1 -Force

# installing fslogix
write-output "Installing FSLogix"
new-item -Path c:\Apps\fslogix -ItemType Directory -Force
Invoke-WebRequest -uri "https://packerbuildhays.blob.core.windows.net/fslogix/FSLogixAppsSetup.exe" -OutFile C:\apps\fslogix\FSLogixAppsSetup.exe
Invoke-Expression -Command "C:\apps\fslogix\FSLogixAppsSetup.exe /install /quiet /norestart"
cd /
# fslogix installed

# installing Adapt Desktop Agent
write-output "Installing Adapt Desktop Agent"
new-item -Path c:\Apps\ada -ItemType Directory -Force
Invoke-WebRequest -uri "https://packerbuildhays.blob.core.windows.net/ada/Adapt Desktop Agent 1.1.32 Admin.msi" -OutFile "C:\apps\ada\Adapt_Desktop_Agent_1.1.32_Admin.msi"
cd C:\apps\ada
cmd /c "msiexec.exe /i Adapt_Desktop_Agent_1.1.32_Admin.msi /qn"
cd /
# Adapt Desktop Agent installed

# Installing Adobe Reader
write-output "Installing Adobe Reader"
new-item -Path c:\Apps\adobereader -ItemType Directory -Force
Invoke-WebRequest -Uri "https://packerbuildhays.blob.core.windows.net/adobereaderdc/adobereaderdc.zip" -OutFile c:\apps\adobereader\adobereaderdc.zip 
Expand-Archive -Path c:\apps\adobereader\adobereaderdc.zip -DestinationPath C:\apps\adobereader -Force
Rename-Item -Path 'C:\apps\adobereader\Acrobat Reader DC' -NewName 'adobereader'
cd C:\apps\adobereader\adobereader
Invoke-Expression -Command "C:\apps\adobereader\adobereader\setup.exe /sAll /msi EULA_ACCEPT=YES UPDATE_MODE=0 DISABLE_ARM_SERVICE_INSTALL=1 DISABLEDESKTOPSHORTCUT=1" 
start-sleep 30
cd /
# Adobe Reader installed

# copying Apps Folder
write-output "Installing Apps Folder"
Invoke-WebRequest -Uri "https://packerbuildhays.blob.core.windows.net/appsfolder/Apps.zip" -OutFile c:\apps\appstemp.zip 
Expand-Archive -Path C:\apps\appstemp.zip -DestinationPath C:\apps
Remove-Item c:\apps\appstemp.zip -Force
# Apps folder copied

# Copying BG Info#
write-output "Installing BG Info"
New-Item -Path c:\apps\bginfo -ItemType Directory -Force
Invoke-WebRequest -Uri "https://packerbuildhays.blob.core.windows.net/bginfo/BG Info.zip" -OutFile c:\apps\bginfo\bginfo.zip
Expand-Archive -Path C:\apps\bginfo\bginfo.zip -DestinationPath c:\apps\bginfo\
New-Item -Path 'C:\Program Files (x86)\Bginfo' -ItemType Directory -Force
cd C:\apps\bginfo
Copy-Item -Path C:\apps\bginfo\Bginfo.exe -Destination 'C:\Program Files (x86)\Bginfo' -Force
Copy-Item -Path C:\apps\bginfo\Hays.bgi -Destination 'C:\Program Files (x86)\Bginfo' -Force
Copy-Item -Path C:\apps\bginfo\Hays_basic.bgi -Destination 'C:\Program Files (x86)\Bginfo' -Force
Copy-Item -Path C:\apps\bginfo\Hays.lnk -Destination 'C:\Program Files (x86)\Bginfo' -Force
Copy-Item -Path 'C:\Program Files (x86)\BGinfo\Hays.lnk' -Destination 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp' -Force
$shortcutName = "Show My IP.lnk"
$target = 'C:\Program Files (x86)\BGinfo\Bginfo.exe'
$arguments = " hays_basic.bgi /popup /silent /nolicprompt"
$shell = New-Object -ComObject ("Wscript.Shell")
$shortcut = $shell.CreateShortcut($env:PUBLIC + "\Desktop\$shortcutName")
$shortcut.TargetPath = $target
$shortcut.Arguments = $arguments
$shortcut.WorkingDirectory =  'C:\Program Files (x86)\BGinfo'
$shortcut.IconLocation = $target
$shortcut.Save()
cd /
# BG Info copied

# Installing 7-zip
write-output "Installing 7-zip"
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/7zip/7z1900-x64.msi -OutFile c:\Apps\7z1900-x64.msi
cd c:\apps
cmd /c "msiexec.exe /i 7z1900-x64.msi /qn"
# 7-zip installed

# Installing Notepad++
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/npp/npp.7.8.2.Installer.x64.exe -OutFile c:\apps\npp.7.8.2.Installer.x64.exe 
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/npp/config.model.xml -OutFile c:\apps\config.model.xml
cd C:\apps
cmd /c .\npp.7.8.2.Installer.x64.exe /S
Copy-Item -Path C:\apps\config.model.xml -Destination 'C:\Program Files\Notepad++' -Force
# Notepad++ installed

# Installing Google Chrome 81 (x64)
write-output "Installing Google Chrome"
New-Item -Path C:\apps\chrome81 -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/chrome81/chrome81_x64.zip -OutFile C:\apps\chrome81\chrome81_x64.zip
Expand-Archive -Path C:\apps\chrome81\chrome81_x64.zip -DestinationPath C:\apps\chrome81
cd C:\apps\chrome81\chrome81_x64
start-process "msiexec.exe" -ArgumentList "/i googlechromestandaloneenterprise64.msi /q ALLUSERS=2 NOGOOGLEUPDATEPING=1" -Wait
Copy-Item .\master_preferences -Destination 'C:\Program Files (x86)\Google\Chrome\Application' -Force
$chromeArguments = "--disable-hang-monitor --allow-outdated-plugins"
$shortcuts = cmd /c Dir /s /B c:\Users\*chrome*.lnk

foreach ($short in $shortcuts)
{
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($short)
    $shortcut.Arguments = "--disable-hang-monitor --allow-outdated-plugins"
    $shortcut.Save()
}
get-process chrome | stop-process -Force -ErrorAction SilentlyContinue
get-process googleupdate | stop-process -Force -ErrorAction SilentlyContinue
Remove-Item -Path 'C:\Program Files (x86)\Google\Update' -Recurse -Force -ErrorAction SilentlyContinue
cd /
# Google Chrome 81 installed

# Installing IE Tab
write-output "Installing IE Tab"
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/ietab/ietabhelper.9.11.7.1.msi -OutFile c:\apps\ietabhelper.9.11.7.1.msi
cd C:\apps
cmd /c "msiexec.exe /i ietabhelper.9.11.7.1.msi /qn"
Remove-Item C:\apps\ietabhelper.9.11.7.1.msi -Force
cd /
# IE Tab installed

# Installing MS Teams VDI Optimized 
write-output "Installing MS Teams VDI Optimized"
new-item -Path c:\apps\msteams -ItemType Directory -Force
New-Item -Path HKLM:\SOFTWARE\Microsoft\Teams -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Teams\ -Name IsWVDEnvironment -PropertyType DWORD -Value 1 -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/msteams/Teams_windows_x64.msi -OutFile c:\apps\msteams\Teams_windows_x64.msi
cd c:\apps\msteams
start-process "msiexec.exe" -ArgumentList "/i Teams_windows_x64.msi OPTIONS=noAutoStart=true ALLUSERS=1 /qn" -Wait
cd /
# MS Teams Installed

# Installing Fuze 6.1
write-output "Installing Fuze App"
New-Item -Path C:\apps\Fuze -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/fuze/FuzeInstallerPerMachine.exe -OutFile C:\apps\Fuze\FuzeInstallerPerMachine.exe
cd C:\apps\Fuze
Invoke-Expression -Command ".\FuzeInstallerPerMachine.exe /quiet /FuzeLyncIntegration=1 /FuzeOutlookIntegration=1" 
cd /
# Fuze 6.1 Installed 

# Installing SEP 14
write-output "Installing Symantec Endpoint Protection"
New-Item -Path c:\apps\sep14 -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/sep14/SEP14.zip -OutFile C:\apps\sep14\sep14.zip
Expand-Archive -Path C:\apps\sep14\sep14.zip -DestinationPath C:\apps\sep14
cd C:\apps\sep14\Symantec
cmd /c "msiexec.exe /i Sep64.msi /qn /l*v c:\Windows\Logs\SEP14.2.log SYMREBOOT=ReallySuppress"
cd /
# SEP14 installed

# Creating O365 Shortcuts
write-output "Installing O365 shortcuts"
$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($env:PUBLIC + "\Desktop\Outlook 2016.lnk")
$ShortCut.TargetPath="C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
$ShortCut.Save()

$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($env:PUBLIC + "\Desktop\Word 2016.lnk")
$ShortCut.TargetPath="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
$ShortCut.Save()

$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($env:PUBLIC + "\Desktop\Excel 2016.lnk")
$ShortCut.TargetPath="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
$ShortCut.Save()

$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($env:PUBLIC + "\Desktop\PowerPoint 2016.lnk")
$ShortCut.TargetPath="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"
$ShortCut.Save()
# O365 Shortcuts created

# Installing runtimes
write-output "Installing Runtimes"
New-Item -Path c:\apps\runtimes -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/runtimes/VC_redist.x64.exe -OutFile c:\apps\runtimes\VC_redist.x64.exe
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/runtimes/VC_redist.x86.exe -OutFile c:\apps\runtimes\VC_redist.x86.exe
cd c:\apps\runtimes
cmd /c .\VC_redist.x86.exe /quiet /norestart
cmd /c .\VC_redist.x64.exe /quiet /norestart
# Runtimes installed

# Installing Teams WebSocket Optimization Client 
write-output "Installing Teams WebSocket Optimization Client"
new-item -Path c:\apps\msrdc -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/msrdc/msrdc.msi -OutFile c:\apps\msrdc\msrdc.msi
cd c:\apps\msrdc 
cmd /c "msiexec.exe /i msrdc.msi /qn"
# Teams WebSocket Optimization Client installed

# Installing HAYS template suite
write-output "Installing HAYS template suite"
new-item -Path c:\apps\haystemplatesuite -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/haystemplatesuite/Hays_Template_Suite_2016_x64.msi -OutFile c:\apps\haystemplatesuite\Hays_Template_Suite_2016_x64.msi
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/haystemplatesuite/InstallTemplates_64_Win10.bat -OutFile c:\apps\haystemplatesuite\InstallTemplates_64_Win10.bat 
cd c:\apps\haystemplatesuite
cmd /c .\InstallTemplates_64_Win10.bat
# HAYS template suite installed

# Software for UK
# Installing MDI File Converter
write-output "Installing MDI file converter"
new-item -Path c:\apps\modi -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/modi/MDIConversionSetup.msi -OutFile c:\apps\modi\MDIConversionSetup.msi
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/modi/MDI_File_Converter.ico -OutFile c:\apps\modi\MDI_File_Converter.ico
cd c:\apps\modi
Start-Process "msiexec.exe" -ArgumentList "/i MDIConversionSetup.msi /quiet /norestart" -Wait
# MDI file converter installed

# Installing EDM plugin
write-output "Installing EDM plugin"
new-item -Path c:\apps\edm -ItemType Directory -Force
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/edm/fspluginsetup.exe -OutFile c:\apps\edm\fspluginsetup.exe
cd c:\apps\edm
Invoke-Expression -Command "c:\apps\edm\fspluginsetup.exe installpath='C:\Program Files (x86)\Bottomline Technologies\Transform Client Plug-in' autoexit hide"
start-sleep 30
# EDM plugin installed

# replace hosts file for Russia - webmail.hays.ru
write-output "Replacing hosts file"
Invoke-WebRequest -Uri https://packerbuildhays.blob.core.windows.net/hosts/hosts -OutFile c:\apps\hosts
cd c:\apps
Copy-Item -Path c:\apps\hosts -Destination C:\Windows\System32\drivers\etc\hosts -Force

