# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/refined.zsh-theme
# Set ohmyzsh refined theme
setopt prompt_subst

# Load required modules
autoload -Uz vcs_info

# Set vcs_info parameters
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s:%b" "%%u%c"
zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s:%b" "%u%c (%a)"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" ""

# Fastest possible way to check if repo is dirty
git_dirty() {
    # Check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # Check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
}

# Display information about the current repository
repo_information() {
    echo "%F{blue}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

# Displays the exec time of the last command if set threshold was exceeded
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    [ $elapsed -gt 5 ] && echo ${elapsed}s
}

# Get the initial timestamp for cmd_exec_time
preexec() {
    cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
precmd() {
    setopt localoptions nopromptsubst
    vcs_info # Get version control info before we start outputting stuff
    print -P "\n$(repo_information) %F{yellow}$(cmd_exec_time)%f"
    unset cmd_timestamp #Reset cmd exec time.
}

# Define prompts
PROMPT="%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH

#PROMPT=$'\n⚡ %F{blue}%~%f\n%F{magenta}❯%f ' # My custom prompt '⚡❯' Interfere with refined theme!!!


# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
#
# ------------------------------------------------------------------------------


# Default zsh settings
###############################################################################
 autoload -Uz promptinit
 promptinit

# Set history options
setopt histignorealldups sharehistory
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
###############################################################################


# Set environment variables
###############################################################################
#export PATH=/home/user:/bin:/usr/bin:/usr/local/bin:${PATH}
#export SHELL=/usr/bin/zsh
#export EDITOR=/usr/bin/vim # !!! Interfere tmux copy-mode
#export PAGER=/usr/bin/less
#export OPENER=/usr/bin/xdg-open


# Disable ctrl+s and ctrl+q flow control
setopt noflowcontrol
#stty start undef
#stty stop undef


# Keyboard shortcuts
###############################################################################
bindkey "^[[1;5D" backward-word #ctrl-left
bindkey "^[[1;5C" forward-word #ctrl-right
bindkey "^[[1~" beginning-of-line #home
bindkey "^[[4~" end-of-line #end
bindkey "^H" backward-kill-word # ctrl-backspace
bindkey "^Z" undo # ctrl-z

bindkey -e # Use emacs keybindings even if our EDITOR is set to vi

up-dir() {
  builtin cd ..
  zle accept-line
  zle reset-prompt
}
zle -N up-dir
bindkey "^[[1;3D" up-dir #alt-left

prev-dir(){
  builtin cd -
  zle accept-line
  zle reset-prompt
}
zle -N prev-dir
bindkey "^[[1;3C" prev-dir #alt-right
# zsh commands https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html


# Aliases
###############################################################################
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
alias gl='git log --oneline -20 --graph --all'
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
alias grep='rg --ignore-case'
alias rg='rg --ignore-case'


# fasd
###############################################################################
#eval "$(fasd --init auto)"
eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
bindkey '^k^i' fasd-complete # test autocomplete


# fzf
###############################################################################
# Init fzf
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash, https://raw.githubusercontent.com/mskar/setup/main/.zshrc
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Set fzf env vars
# $FZF_TMUX_OPTS $FZF_CTRL_T_COMMAND $FZF_CTRL_T_OPTS $FZF_CTRL_R_OPTS $FZF_ALT_C_COMMAND $FZF_ALT_C_OPTS
export FZF_DEFAULT_OPTS='--height 50% --history-size=1000 --layout=reverse --border --bind "ctrl-c:execute-silent(echo {} | clip.exe)+abort"'

# Map fzf commands to keybindings
# ctrl+e cd/vi recent folders/files
fzf-fasd-cd-vi() {
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
zle -N fzf-fasd-cd-vi
bindkey '^e' fzf-fasd-cd-vi

# ctrl+r search history
fzf-history() {
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
zle -N fzf-history
bindkey '^R' fzf-history

# ctrl+shif+f search global default
#fzf-widget() {
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
#zle -N fzf-widget
#bindkey '^]' fzf-widget

# ctrl+shif+f search global modified
fzf-find-global() {
   item="$(find '/' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")"
	if [[ -d ${item} ]]; then
		cd "${item}" || return 1
	elif [[ -f ${item} ]]; then
		(vi "${item}" < /dev/tty) || return 1
	else
    return 1
	fi
   zle accept-line
}
zle -N fzf-find-global
bindkey '^]' fzf-find-global

# ctrl+f search local and cd/vi
fzf-find-local() {
   item="$(find . -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")"
	if [[ -d ${item} ]]; then
		cd "${item}" || return 1
	elif [[ -f ${item} ]]; then
		(vi "${item}" < /dev/tty) || return 1
	else
    return 1
	fi
   zle accept-line
}
zle -N fzf-find-local
bindkey '^f' fzf-find-local

# ctrl+k+o cd folder global
fzf-cd() {
  local cmd="${FZF_ALT_C_COMMAND:-"command find '/' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -type d -iname '*' 2>/dev/null"}"
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
zle -N fzf-cd
bindkey '^k^o' fzf-cd

# ctrl+o vi file global
fzf-vi() {
   file="$( find '/' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -type f -iname '*' 2>/dev/null | fzf -1 -0 --no-sort +m)" && (vi "${file}" < /dev/tty) || return 1
   zle acceptl-line
}
zle -N fzf-vi
bindkey '^o' fzf-vi


# LF
###############################################################################
#ctrl+s lfcd allow keep current dir on exit
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
  zle accept-line
  zle reset-prompt
}
zle -N lfcd
#bindkey '^[[18~' lfcd
bindkey '^s' lfcd

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
###############################################################################


# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


# tmux
# Attach to an existing session if it exists, or create a new one if it does not.
tmux new-session -As0

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
