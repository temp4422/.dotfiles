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

uBlock Origin, Vimium, Tempermonkey, Google Translate, Dark Reader, Wappalyzer, Disable HTML5 Autoplay, QuicKey

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

## Tempermonkey

### Google Search and Dictionary

```JavaScript
(function() {
    'use strict';
    window.addEventListener("keydown", checkKey, false);
    async function checkKey(thisKey) {
        let box = document.querySelector('.dw-sbi')
        let speaker = document.querySelector('div.brWULd')
        let enter = (new KeyboardEvent('keydown', { bubbles: true, keyCode: 13 }));
        function sleep(ms) {return new Promise(resolve => setTimeout(resolve, ms));}

        if (thisKey.key == 'q' && thisKey.ctrlKey) {
            //box.dispatchEvent(enter)
            //await sleep(500)
            speaker.click()
            await sleep(500)
            box.focus()
            box.select()
            //console.log("Greetings my friend! Good Work! ")
        }
    }
})();
```

### Google Translate

```JavaScript
(function() {
    'use strict';

    // Trigger Listen button
    let xButton = document.querySelector('.tmJved'); // button class
    window.addEventListener('keydown', pressKey, false);
    function pressKey(x) {
        if (x.key == 'q' && x.ctrlKey || x.key == 'й' && x.ctrlKey) {
            xButton.click();
            setTimeout( function() {
                xBox.focus();
                xBox.select();
            }, 350);
            // xButton.style.backgroundColor = "green";
            // setTimeout( function() { xButton.style.backgroundColor = ""}, 500);
        }
    }

    // Focus search box
    let xBox = document.querySelector('.er8xn'); // textarea class
    window.addEventListener('keydown', pressKey2, false);
    function pressKey2(x) {
        if (x.key == '/') {
            setTimeout( function() {
                xBox.focus();
                xBox.select();
            }, 250);
        }
    }
})();
```

### YouTube

```JavaScript
(function() {
    'use strict';

    // Control YouTube playback speed with "Video speed controls" chrome extentsion
    window.addEventListener("keydown", checkKey0, false);
    function checkKey0(key) {
        if (key.key == '>') {
            // Simulate key press using standard KeyboardEvent https://stackoverflow.com/questions/3276794/jquery-or-pure-js-simulate-enter-key-pressed-for-testing/18937620#18937620
            const ke = new KeyboardEvent('keydown', {
            bubbles: true, cancelable: true, keyCode: 68 // Character "d" https://www.w3.org/2002/09/tests/keys.html
            });
            document.body.dispatchEvent(ke);
        }
        if (key.key == '<') {
            const ke = new KeyboardEvent('keydown', {
            bubbles: true, cancelable: true, keyCode: 83 // Character "s" https://www.w3.org/2002/09/tests/keys.html
            });
            document.body.dispatchEvent(ke);
        }
    }
})();
```

## Archive

Shutdown shortcut (Target: "C:\Windows\System32\shutdown.exe -s -t 600")
AutoKey for linux
Notepad++ (config.xml)
