# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=1000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



######--- MY CONFIGS ---######

#bind '"\C-h":backward-kill-word'
#tmux

alias ll='ls -lah'
alias pwsh='powershell.exe'
alias exp='explorer.exe'
alias rm='rm -r'
alias cp='cp -r'
alias c='clear'
alias cd..='cd ..'
alias cd-='cd -'
alias grep='grep --color=auto'
alias chrome='/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
alias g='git'
alias du='du -sh'
alias p='pnpm'



# cd d,des 
cd() {
	if [[ $@ == "d" ]]; then
		command cd '/mnt/d/'
	elif [[ $@ == "des" ]]; then
		command cd '/mnt/c/Users/user/Desktop/'
	else
		command cd "$@"
	fi
}

# Change ls dircolor
#https://unix.stackexchange.com/questions/94498/what-causes-this-green-background-in-ls-output
eval "$(dircolors ~/.dircolors)";

# Customized prompt
#⚡Σ ➔➜➤➥➧ ❯❱ᐅ➤
PS1='${debian_chroot:+($debian_chroot)}\[\033[35m\]\u@WSL\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n\[\033[35m\]❯\[\033[00m\] '

cd ~

# tmux The -A flag makes new-session behave like attach-session if session-name already exists; 
tmux new -As0 


#stopwatch
function sw(){ 
	now=$(date +%s)sec
	while true; do
		printf "%s\r" $(TZ=UTC date --date now-$now +%H:%M:%S.%3N)
		sleep 0.1
	done
}
function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}

# Initialize fasd
#eval "$(fasd --init auto)"
#alias j='fasd_cd -d'
# Initialize fuck
eval $(thefuck --alias)
alias fd='fdfind'



# fzf
#/usr/share/doc/fzf/README.Debian enable fzf keybindings for Bash
source /usr/share/doc/fzf/examples/key-bindings.bash
#bind '"\C-g": "__fzf_cd__\n"' # bind inside Windows Terminal settings.json ctrl+g -> alt+c
export FZF_ALT_C_COMMAND='fd --type d .'
export FZF_ALT_C_OPTS="--height 40% --layout=reverse --border"


#export FZF_DEFAULT_OPTS='--history-size=1000 --height=30% --layout=reverse'
export FZF_CTRL_R_OPTS='--history-size=1000 --layout=reverse'


# fasd & fzf change directory - open best matched file using `fasd` if given argument, filter output of `fasd` using `fzf` else
v() {
    [ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return
    local file
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}

# enable control-s and control-q
stty -ixon
