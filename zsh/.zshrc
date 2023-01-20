# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Still need to wait for keybinds
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#PROMPT=$'\n⚡ %F{blue}%~%f\n%F{magenta}❯%f ' # My custom prompt, interfere with "refined" oh-my-zsh theme!!!

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
alias ll='ls -l --almost-all --human-readable --color --group-directories-first' # ls -lAHSr
alias c='clear'
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
alias gl='git log --oneline -15 --graph --all'
alias gm='git add . && git commit -am'
alias gc='git checkout'
alias gb='git branch'
alias gp='git push'
alias gd='git diff'
alias gcl='git checkout . && git clean -fd'
# apps
alias fd='fdfind'
alias exp='explorer.exe'
alias pwsh='powershell.exe'
alias chrome='/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
alias ni='npm install'
alias y='yarn'
alias p='pnpm'
alias j='fasd_cd -d'
#alias cd='fasd_cd -d'
alias grep='rg --ignore-case'
alias rg='rg --ignore-case'
alias bat='batcat'
alias cat='batcat'
#alias vi='nvim'
alias fman='fman.exe .'
alias sb='subl.exe'

# fasd
###############################################################################
eval "$(fasd --init posix-alias zsh-hook)" # minimal zsh setup
#eval "$(fasd --init auto)"
#bindkey '^k^i' fasd-complete # test autocomplete
# Cache fasd list on shell startup in background
($(fasd -Rl > ~/.config/.fasd_cache) &) # Use subshell to get rid of the job control messages. A command enclosed in $(...) is replaced with its output.


# fzf
##############################################################################
# Init fzf
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash, https://raw.githubusercontent.com/mskar/setup/main/.zshrc
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Set fzf env vars
# $FZF_TMUX_OPTS $FZF_CTRL_T_COMMAND $FZF_CTRL_T_OPTS $FZF_CTRL_R_OPTS $FZF_ALT_C_COMMAND $FZF_ALT_C_OPTS
export FZF_DEFAULT_OPTS='--height 50% --history-size=1000 --layout=reverse --border --bind "ctrl-c:execute-silent(echo {} | clip.exe)+abort"'

# zsh-autosuggestions
##############################################################################
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# tmux
##############################################################################
# Attach to an existing session if it exists, or create a new one if it does not.
#tmux new-session -As0


# Powerlevel10k
##############################################################################
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh


# Load widgets.zsh
##############################################################################
source $HOME/.dotfiles/zsh/widgets.zsh

# broot
source /home/user/.config/broot/launcher/bash/br
bindkey -s "^s" 'br --hidden --sort-by-type^M'


# nvm
##############################################################################
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${kXDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm. Comment this line and uncomment one below to make shell load faster.
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@" # Alais to load nvm manually. To use node, run "nvm". Uncomment this line and comment one above to make shell load faster.

# Show startup time. Profiling: 'zmodload zsh/zprof' 'zprof'
#time zsh -c exit #{ time zsh -c exit ; } 2> time.txt

# pnpm
export PNPM_HOME="/home/user/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# LunarVim configs
export PATH=/home/user/.local/bin:$PATH

# Sublime Text
export EDITOR=subl.exe

# tere
tere() {
    local result=$(/home/user/dev/tere/target/debug/tere "$@")
    [ -n "$result" ] && cd -- "$result"
}