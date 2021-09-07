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

bindkey "^[[1;3D" up-directory
up-directory() {
    builtin cd .. && zle reset-prompt
}
zle -N up-directory

# Start in home dir
cd ~

# Aliases
# common
alias l='ls --color'
alias ls='ls --color'
alias ll='ls -l --almost-all --human-readable --sort=size --reverse --color --group-directories-first' # ls -lAHSr
alias c='clear'
alias rm='rm -r'
alias cp='cp -r'
alias cd..='cd ..'
alias ..='cd ..'
alias cd-='cd -'
alias grep='grep --ignore-case --color=auto'
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


# cd d, desktop, ~
cd() {
  if [ "$1" = "d" ]; then
    builtin cd "/mnt/d/"
  elif [ "$1" = "des" ]; then
    builtin cd "/mnt/c/Users/user/Desktop/"
  elif [ "$1" = "" ]; then
    builtin cd "/home/user/"
  else
		builtin cd "$1"
 fi
}


# tmux 
tmux new -As0


### Init fasd ###
eval "$(fasd --init auto)"
#alias j='fasd_cd -d'
bindkey '^k^i' fasd-complete # test autocomplete


#### Init fzf ###
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash, https://raw.githubusercontent.com/mskar/setup/main/.zshrc
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh


# Map fzf commands to keybindings 
# ctrl+t to ctrl+o with bindkey
export FZF_DEFAULT_OPTS='--height 50% --history-size=1000 --layout=reverse --border'
# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find '/' -type d \( -path '/mnt/*' -o -path '/proc/*' -o -path '/dev/*' -o -path '/home/user/.cache/*' -o -path '/home/user/.vscode*' -o -name 'node_modules' -o -name '*git*' \) -prune -false -o -type f -iname '*' 2>/dev/null"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}
__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  zle accept-line
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-file-widget
bindkey '^o' fzf-file-widget
#export FZF_DEFAULT_COMMAND="fd --type file"
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ctrl+shift+e (ctrl+] Windows terminal)
fzf-hidden-files () { fd --type file --hidden --no-ignore | fzf }
zle -N fzf-hidden-files
bindkey '^]' fzf-hidden-files

# ctrl+k+o
export FZF_ALT_C_OPTS="--height 50% --layout=reverse --border"
# ALT-C (ctrl+k+o) - cd into the selected directory
fzf-cd-widget() {
  #local cmd="${FZF_ALT_C_COMMAND:-"command fdfind --type directory"}"
  local cmd="${FZF_ALT_C_COMMAND:-"command find '/' -type d \( -path '/mnt/*' -o -path '/proc/*' -o -path '/dev/*' -o -path '/home/user/.cache/*' -o -path '/home/user/.vscode*' -o -name 'node_modules' -o -name '*git*' \) -prune -false -o -type d -iname '*' 2>/dev/null"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
 if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="cd ${(q)dir}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle     -N    fzf-cd-widget
bindkey '^k^o' fzf-cd-widget

# ctrl+r
export FZF_CTRL_R_OPTS='--history-size=1000 --layout=reverse --border'
# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle accept-line
  zle reset-prompt
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

#export FZF_COMPLETION_TRIGGER='**' 


# fasd & fzf change directory - jump using `fasd` if given argument, filter output of `fasd` using `fzf` else
fasd-dir() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
	  zle accept-line
}
zle -N fasd-dir
bindkey '^g' fasd-dir

# fzf-vim file
fasd-file() {
   #[ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return
   #local file
   file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && (vi "${file}" < /dev/tty) || return 1
   zle accept-line
}
zle -N fasd-file
bindkey '^e' fasd-file


# go() { fasd | sort -nr | fzf | awk -F ' ' '{print $2}' }
#zle -N go
#bindkey '^k^g' go



# Init fuck
eval $(thefuck --alias)

