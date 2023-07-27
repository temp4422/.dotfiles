# Windows

## Settings

Keyboard Properties -> Character repeat -> Repeat delay / Repeat rate -> Short


## Install apps

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

## WSL

### Install apps

```bash
sudo apt install vim git curl zip zsh fzf fasd ripgrep fd-find tmux
```

### Set zsh

```bash
chsh -s $(which zsh);
rm -rf ~/.zshrc ~/.vimrc ~/.tmux.conf ~/.config/lf/lfrc ~/.config/broot/verbs.hjson;
ln -s ~/.dotfiles/win/.zshrc ~/.zshrc && ln -s ~/.dotfiles/win/.vimrc ~/.vimrc;
```

### Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k;
#echo '[[ ! -f ~/.dotfiles/win/.p10k.zsh ]] || source ~/.dotfiles/win/.p10k.zsh' >>~/.zshrc
#echo 'source ~/.config/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

### zsh-autosuggestions

```bash
#sudo apt update && sudo apt install zsh-autosuggestions;
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-autosuggestions;
echo 'source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
```

### tere

```bash
wget https://github.com/mgunyho/tere/releases/download/v1.4.0/tere-1.4.0-x86_64-unknown-linux-gnu.zip
unzip tere-1.4.0-x86_64-unknown-linux-gnu.zip
sudo mv tere /usr/local/bin
rm tere-1.4.0-x86_64-unknown-linux-gnu.zip
```


## Archive

```bash
# broot
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list;
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg;
sudo apt update && sudo apt install broot && br;
ln -s ~/.dotfiles/win/verbs.hjson ~/.config/broot/verbs.hjson

# lf
wget https://github.com/gokcehan/lf/releases/download/r28/lf-linux-amd64.tar.gz -O lf-linux-amd64.tar.gz;
tar xvf lf-linux-amd64.tar.gz && rm lf-linux-amd64.tar.gz && chmod +x lf && sudo mv lf /usr/local/bin;
wget https://raw.githubusercontent.com/gokcehan/lf/master/lf.1 && sudo mv lf.1 /usr/share/man/man1/;
ln -s ~/.dotfiles/zsh/lfrc ~/.config/lf/lfrc;

# tmux - drop for priority of terminal functionality
ln -s ~/.dotfiles/zsh/.tmux.conf ~/.config/.tmux.conf
```
