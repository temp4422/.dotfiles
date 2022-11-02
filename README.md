# .dotfiles
My dotfiles with settings

### Clone repo
```bash
git clone https://github.com/webdev4422/.dotfiles.git
```

### Install apps
```bash
sudo apt install git curl zip zsh fzf fasd ripgrep tmux
```

### Set zsh
```bash
chsh -s $(which zsh)
```

### Install lf, zsh-autosuggestions
```bash
wget https://github.com/gokcehan/lf/releases/download/r6/lf-linux-amd64.tar.gz -O lf-linux-amd64.tar.gz && tar xvf lf-linux-amd64.tar.gz && rm lf-linux-amd64.tar.gz && chmod +x lf && sudo mv lf /usr/local/bin && wget https://raw.githubusercontent.com/gokcehan/lf/master/lf.1 && sudo mv lf.1 /usr/share/man/man1/ && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```

### Link files
```bash
ln -s ~/.dotfiles/.zshrc ~/.zshrc && ln -s ~/.dotfiles/.vimrc ~/.vimrc && ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf && ln -s ~/.dotfiles/lfrc ~/.config/lf/lfrc
```
