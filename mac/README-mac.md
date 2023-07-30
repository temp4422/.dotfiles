# MacOS

## Install apps

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
# All apps
brew install coreutils fzf fasd ripgrep fd tmux bat tere hammerspoon
```

## Karabiner-Elements

```bash
ln -s ~/.dotfiles/mac/karabiner-elements_1.json ~/.config/karabiner/assets/complex_modifications/karabiner-elements_1.json
ln -s ~/.dotfiles/mac/karabiner-elements_2.json ~/.config/karabiner/assets/complex_modifications/karabiner-elements_2.json
```

## Hammerspoon

```bash
ln -s ~/.dotfiles/mac/init.lua ~/.hammerspoon/init.lua
```

## iTerm2

Set iTerm2 Vim scroll up/down behavior to use pgup/pgdown in vim

Settings -> Advanced -> Scroll wheel sends arrow keys when in alternate screen mode -> Yes.
https://apple.stackexchange.com/questions/440527/scrolling-issue-in-vim-after-switch-to-iterm2

```bash
# Map iTerm2 keybinds 'cmd+p' to "Send Text with "vim" Special Chars" - "\<C-p>" mapped to functions in widgets.zsh "^p". Example: bindkey '^p' run-fzf-fasd-cd-vi Basically this maps cmd+key to ctrl+key.
# Import iTerm2-key-mappings.itermkeymap by Settings -> Profiles -> Keys -> Key Mappings -> Presets -> Import
# Added keybinds on top on 'Natural Text Editing', nothing removed:

# Movement
Home 0x1
End 0x5
cmd+[ # backward
cmd+] # forward

# Clipboard
cmd+x \<C-x>
cmd+c \<C-c>
cmd+v \<C-v>
cmd+a \<C-a>

# Widgets/functions
cmd+f \<C-f>
cmd+p \<C-p>
cmd+r \<C-r>
```

## zsh environment

```bash
rm -rf ~/.zshrc ~/.vimrc ~/.tmux.conf ~/.config/lf/lfrc ~/.config/broot/verbs.hjson;
ln -s ~/.dotfiles/mac/.zshrc ~/.zshrc && ln -s ~/.dotfiles/mac/.vimrc ~/.vimrc;
```

## Powerlevel10k

```bash
#brew install romkatv/powerlevel10k/powerlevel10k
#echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k;
#echo '[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh' >>~/.zshrc
#echo 'source ~/.config/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

## zsh-autosuggestions

```bash
#brew install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-autosuggestions;
#echo 'source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
```

## broot

```bash
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list;
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg;
sudo apt update && sudo apt install broot && br;
ln -s ~/.dotfiles/mac/verbs.hjson ~/.config/broot/verbs.hjson
```

## Sublime Text
