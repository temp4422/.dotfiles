# Set up the prompt

autoload -Uz promptinit
promptinit
#prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


### MY CONFIGS ###
# Custom prompt
#autoload -U colors && colors
PROMPT="%F{magenta}%n@WSL%f %~
%F{magenta}⚡%f " # ❯

# key mappings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Start in home dir
cd ~

# Aliases
# common
alias ls='ls --color'
alias ll='ls -lah --color'
alias c='clear'
alias rm='rm -r'
alias cp='cp -r'
alias cd..='cd ..'
alias cd-='cd -'
alias grep='grep --color=auto'
alias du='du -sh'
# git
alias g='git'
alias gs='git status'
alias gl='git log --oneline -15 --graph --all'
alias gm='git add . && git commit -am'
alias gc='git checkout'
alias gb='git branch'
alias gp='git push'
alias gd='git diff'
# apps
alias fd='fdfind'
alias exp='explorer.exe'
alias pwsh='powershell.exe'
alias chrome='/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
alias p='pnpm'


# cd to desktop, d
cd() {
  if [ "$1" = "d" ]; then
    builtin cd "/mnt/d/"
  elif [ "$1" = "des" ]; then
    builtin cd "/mnt/c/Users/user/Desktop/"
  else
		builtin cd "$1"
 fi
}


# tmux 
tmux new -As0


# Initialize fasd
eval "$(fasd --init auto)"
#alias j='fasd_cd -d'

# Initialize fuck
eval $(thefuck --alias)



# fzf
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash, https://raw.githubusercontent.com/mskar/setup/main/.zshrc
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Map fzf commands to keybindings 
# ctrl+t to ctrl+e with bindkey
bindkey '^e' fzf-file-widget
export FZF_DEFAULT_COMMAND="fd --type file"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 50% --history-size=1000 --layout=reverse --border'
# ctrl+shift+e (ctrl+] Windows terminal)
fzf-hidden-files () { fd --type file --hidden --no-ignore | fzf }
zle -N fzf-hidden-files
bindkey '^]' fzf-hidden-files

# ctrl+g
bindkey '^g' fzf-cd-widget
export FZF_ALT_C_COMMAND='fd --type directory'
export FZF_ALT_C_OPTS="--height 50% --layout=reverse --border"

# ctrl+r
export FZF_CTRL_R_OPTS='--history-size=1000 --layout=reverse --border'

#export FZF_COMPLETION_TRIGGER='**' 


# fzf-fasd dir
alias jf="func() { local directory=$(echo '$(fasd -Rdl | fzf --delimiter=/ --no-multi --with-nth=4..)') && [ $(echo '$directory') ] && [ -d $(echo '$directory') ] && cd $(echo '$directory'); }; func"


# fzf-vim file
v() {
   [ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return
   local file
   file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}

# fasd & fzf change directory - open best matched file using `fasd` if given argument, filter output of `fasd` using `fzf` else
j() {
    [ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return
    local file
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}





