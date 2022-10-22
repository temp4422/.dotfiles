# Winfiles

My Windows files and configs for productivity.

## Settings

### Setting Symbolic links with PowerShell

```PowerShell
#AutoHotkey
New-Item -Path "C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ahk.ahk" -ItemType SymbolicLink -Value "D:\Apps\Winfiles\ahk.ahk"
#PowerShell
New-Item -Path "C:\Users\user\Documents\WindowsPowerShell\profile.ps1" -ItemType SymbolicLink -Value "D:\Apps\Winfiles\profile.ps1"
#ConEmu
New-Item -Path "C:\Program Files\ConEmu\ConEmu.xml" -ItemType SymbolicLink -Value "D:\Apps\Winfiles\ConEmu.xml"
#Windows Terminal
New-Item -Path "C:\Users\user\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" -ItemType SymbolicLink -Value "D:\Apps\Winfiles\settings.json"
```

## SharpKeys

### Remapping keys for Windows

| From:                         | To:                           |
| ----------------------------- | ----------------------------- |
| Special: Caps Lock (00_3A)    | Special: Escape (00_01)       |
| Special: Escape (00_01)       | Special: Caps Lock (00_3A)    |
| Special: Left Alt (00_38)     | Special: Left Ctrl (00_1D)    |
| Special: Left Ctrl (00_1D)    | Special: Left Alt (00_38)     |
| Special: Right Alt (E0_38)    | Special: Wake (or Fn) (E0_63) |
| Special: Wake (or Fn) (E0_63) | Special: Right Alt (E0_38)    |

## Browser Extensions

uBlock Origin, Vimium, Tampermonkey, Google Translate, Dark Reader, Wappalyzer, Disable HTML5 Autoplay, QuicKey

## Vimium Options

### Excluded URLs and keys

| Patterns                        | Keys  |
| ------------------------------- | ----- |
| https?://www.youtube.com/watch* | f < > |

### Custom key mappings

```
# Remap hjkl to jkl;
unmap h
unmap j
unmap k
unmap l

map j scrollLeft
map k scrollDown
map l scrollUp
map ; scrollRight

unmap /
map <c-/> enterFindMode

unmap H
unmap L
map J goBack
map : goForward
#map <c-left> goBack
#map <c-right> goForward

#map <c-tab> visitPreviousTab

map / focusInput

# Control YouTube playback speed with "Video speed controls" chrome extentsion in Tampermonkey
unmap d
unmap s
```

### Miscellaneous options

\+ Ignore keyboard layout

## Tampermonkey

### Google Translate

```JavaScript
// ==UserScript==
// @name         Google Translate Press Button
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://translate.google.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Press listen button and select input box
    window.addEventListener("keydown", pressKey, false)

    async function pressKey(key) {
        let box = document.querySelector('.er8xn') // select text area
        let button = document.querySelector('.SSgGrd') // select listen button
        function sleep(ms) {return new Promise(resolve => setTimeout(resolve, ms))} // timeout function to be set later
        if (key.key == 'q' && key.ctrlKey || key.key == 'й' && key.ctrlKey) { // if 'q' and 'ctrl' keypress
            button.click()
            await sleep(500)
            box.focus()
            box.select()
            //alert("Greetings my friend! Good Work! ")
        }
    }

})();
```

## Windows
### Uninstall apps
```
winget uninstall  "Microsoft People"
...WIP...
```

### Install apps
```
winget install Lexikos.AutoHotkey;
winget install hluk.CopyQ;
winget install Microsoft.WindowsTerminal.Preview; 
winget install Microsoft.VisualStudioCode;
winget install Google.Chrome;
winget install Telegram.TelegramDesktop;
winget install Kingsoft.WPSOffice;
```

## Archive

Shutdown shortcut (Target: "C:\Windows\System32\shutdown.exe -s -t 600")
AutoKey for linux
Notepad++ (config.xml)
