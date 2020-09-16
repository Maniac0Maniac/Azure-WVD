New-Item -Path C:\Apps\Scripts\ -ItemType Directory -Force
Invoke-WebRequest -Uri https://github.com/Pawel1985/Azure-WVD/raw/master/Windows_10_VDI_Optimize-master.zip -OutFile c:\apps\Scripts\vdioptimize.zip
Expand-Archive -Path c:\apps\Scripts\vdioptimize.zip -DestinationPath c:\apps\scripts
cd c:\Apps\Scripts\Windows_10_VDI_Optimize-master
powershell.exe .\Win10_VirtualDesktop_Optimize.ps1 -WindowsVersion 2004 -Verbose
