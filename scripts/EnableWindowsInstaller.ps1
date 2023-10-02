New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Force
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Name "DisableMSI" -Value 0

