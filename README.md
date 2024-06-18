My Windows, WSL, Mac files and configs for productivity.

## Install apps

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
# macOS
brew install coreutils vim git curl zip zsh fzf fasd ripgrep bat broot tere
# Linux
#sudo apt update && sudo apt install ...
```

## Karabiner-Elements

```bash
rm -rf ~/.config/karabiner/assets/complex_modifications/karabiner-elements_1.json
ln -s ~/.dotfiles/src/karabiner-elements_1.json ~/.config/karabiner/assets/complex_modifications/karabiner-elements_1.json
```

## iTerm2

As for 10.11.2023, make many remmapings for basic shortcuts like cmd+e,r,s... etc. Still iTerm not functioning as expected in some cases, e.g. copy mode. Many remmapings done due to widgets.zsh "Set bindkey keybindings all together" function (you may explore this further). Below are example of some changes made to iTerm settings. All settings, as for today, backup in "My profile" file, iTerm2-my_profile.json, in this repo. How keybinds work: map iTerm2 keybinds 'cmd+p' to "Send Text with "vim" Special Chars" - "\<C-p>" mapped to functions in widgets.zsh "^p". Example: bindkey '^p' run-fzf-fasd-cd-vi. Basically this maps cmd+key to ctrl+key. Alternative: map 'cmd+a' to '^[a' (esc+a) to prevent same key codes collisions. Import iTerm2-key-mappings.itermkeymap by Settings -> Profiles -> Keys -> Key Mappings -> Presets -> Import

### iTerm2 example settings changes

Set iTerm2 Vim scroll up/down behavior to use pgup/pgdown in vim. Settings -> Advanced -> Scroll wheel sends arrow keys when in alternate screen mode -> Yes.
https://apple.stackexchange.com/questions/440527/scrolling-issue-in-vim-after-switch-to-iterm2

```bash
# Clipboard
cmd+a ^[a
cmd+c \<C-c>
cmd+v \<C-v>
cmd+x \<C-x>
cmd+z \<C-z>

# Widgets/functions
cmd+d # "Split Vertically with 'My profile'"
cmd+e \<C-e>
cmd+p \<C-p> # fzf-fasd
cmd+r \<C-r> # search history
cmd+k \<C-k> # clear scroll buffer
cmd+o \<C-o> # open file
cmd+s \<C-s> # broot
cmd+shift+s ^[s # tere
cmd+shift+f \<C-f> # fzf search
```

## zsh environment

```bash
chsh -s $(which zsh);
# reset before linking
rm -rf ~/.zshrc ~/.vimrc ~/.config/.vimrc ~/.tmux.conf ~/.config/lf/lfrc ~/.config/broot/verbs.hjson;
# zsh & vim
ln -s ~/.dotfiles/src/.zshrc ~/.zshrc && ln -s ~/.dotfiles/src/.vimrc ~/.config/.vimrc;
```

## zsh-autosuggestions

```bash
#brew install zsh-autosuggestions
#sudo apt update && sudo apt install zsh-autosuggestions;
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-autosuggestions;
#echo 'source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
```

## broot

```bash
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list;
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg https://azlux.fr/repo.gpg;
sudo apt update && sudo apt install broot && br;
ln -s ~/.dotfiles/src/verbs.hjson ~/.config/broot/verbs.hjson
```

## tere

```bash
wget https://github.com/mgunyho/tere/releases/download/v1.4.0/tere-1.4.0-x86_64-unknown-linux-gnu.zip
unzip tere-1.4.0-x86_64-unknown-linux-gnu.zip
sudo mv tere /usr/local/bin
rm tere-1.4.0-x86_64-unknown-linux-gnu.zip
```

## Sublime Text

https://gist.github.com/skoqaq/3f3e8f28e23c881143cef9cf49d821ff?permalink_comment_id=4424828#gistcomment-4424828

# Windows

## Settings

Keyboard Properties -> Character repeat -> Repeat delay / Repeat rate -> Short

## WinGet Windows Package Manager - Install apps

```
winget install RandyRants.SharpKeys;
winget install Lexikos.AutoHotkey;
winget install hluk.CopyQ;
winget install Microsoft.WindowsTerminal.Preview;
winget install Microsoft.VisualStudioCode;
winget install Telegram.TelegramDesktop;
winget install Brave.Brave;
winget install Kingsoft.WPSOffice;
```

## Uninstall apps

```
winget uninstall  "Microsoft People"
...WIP...
```

## SharpKeys remapping

| From:                         | To:                           |
| ----------------------------- | ----------------------------- |
| Special: Caps Lock (00_3A)    | Special: Escape (00_01)       |
| Special: Escape (00_01)       | Special: Caps Lock (00_3A)    |
| Special: Left Alt (00_38)     | Special: Left Ctrl (00_1D)    |
| Special: Left Ctrl (00_1D)    | Special: Left Windows (E0_5B) |
| Special: Left Windows (E0_5B) | Special: Left Alt (00_38)     |
| Special: Right Alt (E0_38)    | Special: Wake (or Fn) (E0_63) |
| Special: Wake (or Fn) (E0_63) | Special: Right Alt (E0_38)    |

## PowerShell symbolic links

```PowerShell
# AutoHotkey
New-Item -Path "C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ahk.ahk" -ItemType SymbolicLink -Value "\\wsl.localhost\Ubuntu\home\user\.dotfiles\win\ahk.ahk"

# Windows Terminal
New-Item -Path "C:\Users\user\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ItemType SymbolicLink -Value "\\wsl.localhost\Ubuntu\home\user\.dotfiles\win\settings.json"

# Sublime Text
New-Item -Path "C:\Users\user\AppData\Roaming\Sublime Text\Packages\User\Default (Windows).sublime-keymap" -ItemType SymbolicLink -Value "\\wsl.localhost\Ubuntu\home\user\.dotfiles\win\Default (Windows).sublime-keymap"
New-Item -Path "C:\Users\user\AppData\Roaming\Sublime Text\Packages\User\Preferences.sublime-settings" -ItemType SymbolicLink -Value "\\wsl.localhost\Ubuntu\home\user\.dotfiles\win\Preferences.sublime-settings"

# CopyQ
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Start-Sleep -Seconds 10; Start-Process 'C:\Program Files (x86)\CopyQ\copyq.exe'"
```

## Archive

```bash
# tmux - drop for priority of terminal functionality
ln -s ~/.dotfiles/zsh/.tmux.conf ~/.config/.tmux.conf

# lf
wget https://github.com/gokcehan/lf/releases/download/r28/lf-linux-amd64.tar.gz -O lf-linux-amd64.tar.gz;
tar xvf lf-linux-amd64.tar.gz && rm lf-linux-amd64.tar.gz && chmod +x lf && sudo mv lf /usr/local/bin;
wget https://raw.githubusercontent.com/gokcehan/lf/master/lf.1 && sudo mv lf.1 /usr/share/man/man1/;
ln -s ~/.dotfiles/zsh/lfrc ~/.config/lf/lfrc;

# Powerlevel10k
#brew install romkatv/powerlevel10k/powerlevel10k
#echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k;
#echo '[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh' >>~/.zshrc
#echo 'source ~/.config/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Hammerspoon
ln -s ~/.dotfiles/src/init.lua ~/.hammerspoon/init.lua
```

# Browser

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
// @name         Google Translate press listen button
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
    //function sleep(ms) {return new Promise(resolve => setTimeout(resolve, ms))} // timeout function to be set later
    window.addEventListener("keydown", pressKey, false)
    async function pressKey(key) {
        // let box = document.querySelector('.er8xn') // select text area
        const button = document.querySelector('[jsname="UsVyAb"]')
        // if (key.key == 'q' && key.ctrlKey || key.key == 'й' && key.ctrlKey) { // if 'q' and 'ctrl' keypress
        if (key.key == 'u' && key.metaKey || key.key == 'г' && key.metaKey) {
            button.click()
            //await sleep(500)
            //box.focus()
            //box.select()
            //alert("Greetings my friend! Good Work! ")
        }
    }
})();
```

### Google Search input Home/End buttons focus

```JavaScript
// ==UserScript==
// @name         Google Search input Home/End button functionality
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.google.com/search*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const textarea = document.querySelector('textarea[name="q"]')
    textarea.addEventListener("keydown", functionX, false)
    function functionX (e){
        if (e.key === 'Home') {
            //textarea.dispatchEvent(new KeyboardEvent('keydown', {'key': 'a'}));
            e.preventDefault()
            textarea.setSelectionRange(0, 0);
            textarea.focus();
        }
         if (e.key === 'End') {
            //textarea.dispatchEvent(new KeyboardEvent('keydown', {'key': 'a'}));
            e.preventDefault()
            textarea.setSelectionRange(-1, -1);
            textarea.focus();
        }
    }

})();
```
