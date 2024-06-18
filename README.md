My Windows, WSL, Mac files and configs for productivity.

# MacOS

## Install apps

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
# All apps
brew install coreutils fzf fasd ripgrep fd tmux bat broot tere
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
rm -rf ~/.zshrc ~/.vimrc ~/.tmux.conf ~/.config/lf/lfrc ~/.config/broot/verbs.hjson;
ln -s ~/.dotfiles/src/.zshrc ~/.zshrc && ln -s ~/.dotfiles/src/.vimrc ~/.config/.vimrc;
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
ln -s ~/.dotfiles/src/verbs.hjson ~/.config/broot/verbs.hjson
```

## tere

```bash
wget https://github.com/mgunyho/tere/releases/download/v1.4.0/tere-1.4.0-x86_64-unknown-linux-gnu.zip
unzip tere-1.4.0-x86_64-unknown-linux-gnu.zip
sudo mv tere /usr/local/bin
rm tere-1.4.0-x86_64-unknown-linux-gnu.zip
```

## Powerlevel10k

```bash
#brew install romkatv/powerlevel10k/powerlevel10k
#echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k;
#echo '[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh' >>~/.zshrc
#echo 'source ~/.config/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

## Hammerspoon

```bash
ln -s ~/.dotfiles/src/init.lua ~/.hammerspoon/init.lua
```

## Sublime Text

https://gist.github.com/skoqaq/3f3e8f28e23c881143cef9cf49d821ff?permalink_comment_id=4424828#gistcomment-4424828
