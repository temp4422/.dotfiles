# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Still need to wait for keybinds
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# My custom prompt, interfere with "refined" oh-my-zsh theme!!! # Custom color codes curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
#PROMPT=$'\n⚡ %F{blue}%~%f\n%F{magenta}❯%f '
PROMPT=$'\n%F{cyan}%~%f\n%F{46}❯%f '

# Keyboard shortcuts
###############################################################################
bindkey -e # Use emacs keybindings even if our EDITOR is set to vi
bindkey "^[[1;5D" backward-word #ctrl-left
bindkey "^[[1;5C" forward-word #ctrl-right
bindkey "^[[1~" beginning-of-line #home
bindkey "^[[4~" end-of-line #end
bindkey "^H" backward-kill-word # ctrl-backspace
bindkey "^Z" undo # ctrl-z
#bindkey -s "^W" "^D" set in terminal!
#bindkey -s "^D" "^W" set in terminal!


# Set options
###############################################################################
# Disable ctrl+s and ctrl+q flow control
setopt noflowcontrol
#stty start undef
#stty stop undef

# Set environment variables
#export PATH=/home/user:/bin:/usr/bin:/usr/local/bin:${PATH}
#export SHELL=/usr/bin/zsh
#export EDITOR=/usr/bin/vim # !!! Interfere tmux copy-mode
#export PAGER=/usr/bin/less
#export OPENER=/usr/bin/xdg-open

# Set history options
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.config/.zsh_history

# Use modern completion system, otherwise by default will be used old one
autoload -Uz compinit; compinit
# Chose completion options
zstyle ':completion:*' menu select
# Use colors: set variable and use in completion system https://linuxhint.com/ls_colors_bash/
LS_COLORS='di=94:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# case insensitivity
zstyle ":completion:*" matcher-list 'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü}'
# Select menu with single Enter https://superuser.com/questions/1498187/zsh-select-menu-auto-completion-with-single-enter-return-press
zmodload -i zsh/complist
bindkey -M menuselect '^M' .accept-line

# Aliases
###############################################################################
# common
alias l='ls --color'
alias ls='ls --color'
alias ll='gls -lAh --color --group-directories-first'
# alias c='clear'
alias c="clear && printf '\e[3J'"
alias rm='rm -rf'
alias cp='cp -r'
alias cd..='cd ..'
alias ..='cd ..'
alias cd-='cd -'
#alias grep='grep --ignore-case --color=auto'
alias du='du -sh'
# git
alias g='git'
alias gs='git status'
alias gl='git log --oneline -10 --graph --all'
alias gm='git add . && git commit -am'
alias gc='git checkout'
alias gb='git branch'
alias gp='git push'
alias gd='git diff'
alias gcl='git checkout . && git clean -fd'
# apps
#alias fd='fdfind'
# alias exp='explorer.exe'
# alias pwsh='powershell.exe'
# alias chrome='/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
alias ni='npm install'
alias y='yarn'
alias p='pnpm'
alias j='fasd_cd -d'
#alias cd='fasd_cd -d'
alias grep='rg --ignore-case'
alias rg='rg --ignore-case'
# alias bat='batcat'
alias cat='bat'
#alias vi='nvim'
# alias fman='fman.exe .'
alias sb='subl'
alias bd='bun dev --port 3000'
alias bb='bun run build'
alias bs='bun run start'
alias d='docker'


# fzf
##############################################################################
# Init fzf
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash, https://raw.githubusercontent.com/mskar/setup/main/.zshrc
#source /usr/share/doc/fzf/examples/key-bindings.zsh
#source /usr/share/doc/fzf/examples/completion.zsh

# Set fzf env vars
# $FZF_TMUX_OPTS $FZF_CTRL_T_COMMAND $FZF_CTRL_T_OPTS $FZF_CTRL_R_OPTS $FZF_ALT_C_COMMAND $FZF_ALT_C_OPTS
export FZF_DEFAULT_OPTS='--ansi --height 50% --history-size=1000 --layout=reverse --border --bind "ctrl-c:execute-silent(echo {} | pbcopy)+abort"'

# fasd
###############################################################################
eval "$(fasd --init zsh-hook)" # minimal zsh setup
#eval "$(fasd --init auto)"
#bindkey '^k^i' fasd-complete # test autocomplete
# Cache fasd list on shell startup in background after 5 seconds
($(sleep 5; fasd -Rl > ~/.config/.fasd_cache) &) # Use subshell to get rid of the job control messages. A command enclosed in $(...) is replaced with its output.

# zsh-autosuggestions
##############################################################################
source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh

# tmux
##############################################################################
# Attach to an existing session if it exists, or create a new one if it does not.
#tmux new-session -As0

# Powerlevel10k
##############################################################################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
#[[ ! -f ~/.dotfiles/mac/.p10k.zsh ]] || source ~/.dotfiles/mac/.p10k.zsh

# Load widgets.zsh
##############################################################################
source $HOME/.dotfiles/mac/widgets.zsh

# tere
##############################################################################
tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result" && clear && printf '\e[3J' && gls -Ah --color --group-directories-first
}
bindkey -s "^s" 'tere --map ctrl-s:Exit,ctrl-q:Exit --gap-search-anywhere^M' # info tere --help # Set keybind in karabiner cmd+shift+e

# broot
#source /home/user/.config/broot/launcher/bash/br
source /Users/user/.config/broot/launcher/bash/br
#bindkey -s "^s" 'br --hidden --sort-by-type^M'


# nvm
##############################################################################
# Lazy load nvm for fast startup
export PATH=~/.nvm/versions/node/v20.2.0/bin:$PATH # Add default node to path
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # Skip checking node version
# Manually load nvm for fast startup
# alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@" # Alais to load nvm manually. To use node, run "nvm".
# Load nvm. Comment this 2 lines and uncomment lazy load for faster startup
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${kXDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Run nvm on call
nvm() {
    source ~/.nvm/nvm.sh && nvm
}

# Show startup time. Profiling: 'zmodload zsh/zprof' 'zprof'
#time zsh -c exit #{ time zsh -c exit ; } 2> time.txt

# pnpm
# export PNPM_HOME="/home/user/.local/share/pnpm"
# export PATH="$PNPM_HOME:$PATH"

# LunarVim configs
# export PATH=/home/user/.local/bin:$PATH

# Sublime Text
# export EDITOR=subl

# lama
# lama() {
#     ~/dev/llama_linux_amd64
# }

# cdir installed with pip install cdir
# alias cdir='source cdir.sh'

# my path
# export PATH=/home/user/dev:$PATH
alias python=/usr/bin/python3

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
[ -s "/Users/user/.bun/_bun" ] && source "/Users/user/.bun/_bun"