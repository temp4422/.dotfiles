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
# Custom prompt # ❯⚡
PROMPT=$'\n⚡ %F{blue}%~%f\n%F{magenta}❯%f ' 

# Environment variables
export PATH=/home/user:/bin:/usr/bin:/usr/local/bin:${PATH}

# key mappings
bindkey "^[[1;5D" backward-word #ctrl-left
bindkey "^[[1;5C" forward-word #ctrl-right
bindkey "^[[1~" beginning-of-line #home
bindkey "^[[4~" end-of-line #end

up-dir() {
    builtin cd .. && zle reset-prompt
}
zle -N up-dir
bindkey "^[[1;3D" up-dir #alt-left
prev-dir(){
	builtin cd - && zle reset-prompt
}
zle -N prev-dir
bindkey "^[[1;3C" prev-dir #alt-right


# Aliases
# common
alias l='ls --color'
alias ls='ls --color'
alias ll='ls -l --almost-all --human-readable --color --group-directories-first' # ls -lAHSr
alias c='clear'
alias rm='rm -r'
alias cp='cp -r'
alias cd..='cd ..'
alias ..='cd ..'
alias cd-='cd -'
alias grep='grep --ignore-case --color=auto'
#alias du='du -sh'
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
alias y='yarn'
alias p='pnpm'
alias j='fasd_cd -d'
alias bat='batcat'


# Start in home dir
cd ~

# cd d, desktop, ~
#cd() {
#  if [ "$1" = "d" ]; then
#    builtin cd "/mnt/d/"
#  elif [ "$1" = "des" ]; then
#    builtin cd "/mnt/c/Users/user/Desktop/"
#  elif [ "$1" = "" ]; then
#    builtin cd "/home/user/"
#  else
#		builtin cd "$1"
# fi
#}




# tmux 
tmux new -As0


# fasd
#eval "$(fasd --init auto)"
eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
bindkey '^k^i' fasd-complete # test autocomplete



#### Init fzf ###
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash, https://raw.githubusercontent.com/mskar/setup/main/.zshrc
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Set fzf env vars
# $FZF_TMUX_OPTS $FZF_CTRL_T_COMMAND $FZF_CTRL_T_OPTS $FZF_CTRL_R_OPTS $FZF_ALT_C_COMMAND $FZF_ALT_C_OPTS
export FZF_DEFAULT_OPTS='--height 50% --history-size=1000 --layout=reverse --border --bind "ctrl-c:execute-silent(echo {} | clip.exe)+abort"' 

# Map fzf commands to keybindings 
# ctrl+r history
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

# ctrl+shif+f search all global default
#fzf-file-widget() {
#  LBUFFER="${LBUFFER}$(
#  local cmd="${FZF_CTRL_T_COMMAND:-"command find '/' -type d \( -path '/mnt/*' -o -path '/proc/*' -o -path '/dev/*' -o -path '/home/user/.cache/*' -o -path '/home/user/.vscode*' -o -name 'node_modules' -o -name '*git*' \) -prune -false -o -iname '*' 2>/dev/null"}"
#  setopt localoptions pipefail no_aliases 2> /dev/null
#  local item
#  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
#    echo -n "${(q)item} "
#  done
#  local ret=$?
#  echo
#  return $ret
#  )"
##  zle accept-line
#  local ret=$?
#  zle reset-prompt
#  return $ret
#}
#zle     -N   fzf-file-widget
#bindkey '^]' fzf-file-widget

# ctrl+shift+f search all modified
find-fzf() {
   item="$(find '/' -type d \( -path '/mnt/*' -o -path '/proc/*' -o -path '/dev/*' -o -path '/home/user/.cache/*' -o -path '/home/user/.vscode*' -o -name 'node_modules' -o -name '*git*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")" 
	if [[ -d ${item} ]]; then
		cd "${item}" || return 1
	elif [[ -f ${item} ]]; then
		(vi "${item}" < /dev/tty) || return 1
	else
    return 1
	fi
   zle accept-line
}
zle     -N  find-fzf 
bindkey '^]' find-fzf

# ctrl+f search all local and cd/vi
fzf-file-widget-2() {
   item="$(find . -type d \( -path '/mnt/*' -o -path '/proc/*' -o -path '/dev/*' -o -path '/home/user/.cache/*' -o -path '/home/user/.vscode*' -o -name 'node_modules' -o -name '*git*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")" 
	if [[ -d ${item} ]]; then
		cd "${item}" || return 1
	elif [[ -f ${item} ]]; then
		(vi "${item}" < /dev/tty) || return 1
	else
    return 1
	fi
   zle accept-line
}
zle     -N   fzf-file-widget-2
bindkey '^f' fzf-file-widget-2

# ctrl+e fasd-fzf cd/vi for recent folders/files
fasd-fzf-cd-vi() {
   item="$(fasd -Rl "$1" | fzf -1 -0 --no-sort +m)" 
	if [[ -d ${item} ]]; then
		cd "${item}" || return 1
	elif [[ -f ${item} ]]; then
		(vi "${item}" < /dev/tty) || return 1
	else
		return 1
	fi
   zle accept-line
}
zle -N fasd-fzf-cd-vi
bindkey '^e' fasd-fzf-cd-vi

# ctrl+k+o cd folder global
fzf-cd-widget() {
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

# ctrl+o open vi file global
vi-file() {
   file="$( find '/' -type d \( -path '/mnt/*' -o -path '/proc/*' -o -path '/dev/*' -o -path '/home/user/.cache/*' -o -path '/home/user/.vscode*' -o -name 'node_modules' -o -name '*git*' \) -prune -false -o -type f -iname '*' 2>/dev/null | fzf -1 -0 --no-sort +m)" && (vi "${file}" < /dev/tty) || return 1
   zle accept-line
}
zle -N vi-file
bindkey '^o' vi-file


# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# LF
#lfcd allow keep current dir on exit
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# ctrl+k open lf in right tmux pane
_zlf() {
    emulate -L zsh
    local d=$(mktemp -d) || return 1
    {
        mkfifo -m 600 $d/fifo || return 1
        tmux split -fh zsh -c "exec {ZLE_FIFO}>$d/fifo; export ZLE_FIFO; exec lf" || return 1
        local fd
        exec {fd}<$d/fifo
        zle -Fw $fd _zlf_handler
    } always {
        rm -rf $d
    }
}
zle -N _zlf
bindkey '^k' _zlf

_zlf_handler() {
    emulate -L zsh
    local line
    if ! read -r line <&$1; then
        zle -F $1
        exec {1}<&-
        return 1
    fi
    eval $line
    zle -R
}
zle -N _zlf_handler

