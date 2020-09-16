$Date = get-date -Format yyyy-MM-dd--HH:mm
New-Item -Path HKLM:\SOFTWARE -Name HAYS-IT -ItemType Directory -Force
New-Item -Path HKLM:\SOFTWARE\HAYS-IT -Name Buildinfo -ItemType Directory -Force
New-ItemProperty -Path HKLM:\SOFTWARE\HAYS-IT\Buildinfo\ -Name ImageVersion -Value $Date -PropertyType STRING

