# Winfiles
My Windows files and configs for productivity.  

## Settings
AutoHotkey  
New-Item -Path "C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ahk.ahk" -ItemType SymbolicLink -Value "D:\Winfiles\ahk.ahk"  
PowerShell  
New-Item -Path "C:\Users\user\Documents\WindowsPowerShell\profile.ps1" -ItemType SymbolicLink -Value "D:\Winfiles\profile.ps1"   
ConEmu  
New-Item -Path "C:\Users\user\ConEmuPack.200713\ConEmu.xml" -ItemType SymbolicLink -Value "D:\Winfiles\ConEmu.xml"   
Windows Terminal  
New-Item -Path "C:\Users\user\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ItemType SymbolicLink -Value "D:\Winfiles\settings.json"  
Notepad++  
New-Item -Path "C:\Users\user\AppData\Roaming\Notepad++\config.xml" -ItemType SymbolicLink -Value "D:\Winfiles\config.xml"  

## Misc
Shutdown shortcut (Target: "C:\Windows\System32\shutdown.exe -s -t 600")
AutoKey for linux
