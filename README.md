# .dotfiles

My Windows, WSL, Mac files and configs for productivity.

## Settings

### Setting Symbolic links with PowerShell

```PowerShell
#AutoHotkey
New-Item -Path "C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ahk.ahk" -ItemType SymbolicLink -Value "\\wsl.localhost\Ubuntu\home\user\.dotfiles\win\ahk.ahk"

#Windows Terminal
New-Item -Path "C:\Users\user\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ItemType SymbolicLink -Value "\\wsl.localhost\Ubuntu\home\user\.dotfiles\win\settings.json"
```

### Create shortcuts

Target:

```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Start-Sleep -Seconds 10; Start-Process 'C:\Program Files (x86)\CopyQ\copyq.exe'"
```

## SharpKeys

### Remapping keys for Windows

| From:                         | To:                           |
| ----------------------------- | ----------------------------- |
| Special: Caps Lock (00_3A)    | Special: Escape (00_01)       |
| Special: Escape (00_01)       | Special: Caps Lock (00_3A)    |
| Special: Left Alt (00_38)     | Special: Left Ctrl (00_1D)    |
| Special: Left Ctrl (00_1D)    | Special: Left Windows (E0_5B) |
| Special: Left Windows (E0_5B) | Special: Left Alt (00_38)     |
| Special: Right Alt (E0_38)    | Special: Wake (or Fn) (E0_63) |
| Special: Wake (or Fn) (E0_63) | Special: Right Alt (E0_38)    |

## Browser Extensions

uBlock Origin, Vimium, Tampermonkey, Google Translate, Dark Reader, Wappalyzer, Bitwarden, I don't care about cookies

## Vimium Options

### Excluded URLs and keys

| Patterns                        | Keys  |
| ------------------------------- | ----- |
| https?://www.youtube.com/watch* | f < > |

### Custom key mappings

```
unmap /
map / focusInput

map <c-/> enterFindMode
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

### Settings

Keyboard Properties -> Character repeat -> Repeat delay / Repeat rate -> Short

### Uninstall apps

```
winget uninstall  "Microsoft People"
...WIP...
```

### Install apps

```
winget install RandyRants.SharpKeys
winget install Lexikos.AutoHotkey;
winget install hluk.CopyQ;
winget install Microsoft.WindowsTerminal.Preview;
winget install Microsoft.VisualStudioCode;
winget install Telegram.TelegramDesktop;
winget install Brave.Brave;
winget install Google.Chrome;
winget install Mozilla.Firefox;
winget install Kingsoft.WPSOffice;
```

## ZSH environment

### Clone repo

```bash
git clone https://github.com/webdev4422/.dotfiles.git
```

### Install apps

```bash
sudo apt install vim git curl zip zsh fzf fasd ripgrep fd-find tmux
```

### Set zsh

```bash
chsh -s $(which zsh)
```

### Install zsh-autosuggestions, broot, lf

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions;
# broot
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
sudo apt update && sudo apt install broot && br
# lf
wget https://github.com/gokcehan/lf/releases/download/r28/lf-linux-amd64.tar.gz -O lf-linux-amd64.tar.gz && tar xvf lf-linux-amd64.tar.gz && rm lf-linux-amd64.tar.gz && chmod +x lf && sudo mv lf /usr/local/bin && wget https://raw.githubusercontent.com/gokcehan/lf/master/lf.1 && sudo mv lf.1 /usr/share/man/man1/;
```

### Link files

```bash
rm -rf ~/.zshrc ~/.vimrc ~/.tmux.conf ~/.config/lf/lfrc ~/.config/broot/verbs.hjson;

ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc && ln -s ~/.dotfiles/zsh/.vimrc ~/.vimrc && ln -s ~/.dotfiles/zsh/.tmux.conf ~/.config/.tmux.conf && ln -s ~/.dotfiles/zsh/verbs.hjson ~/.config/broot/verbs.hjson && ln -s ~/.dotfiles/zsh/lfrc ~/.config/lf/lfrc
```