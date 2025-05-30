# Oh My Zsh "refined" theme
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/refined.zsh-theme
###############################################################################
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
  # echo "%F{blue}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
  echo "%F{cyan}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

# Displays the exec time of the last command if set threshold was exceeded
cmd_exec_time() {
  local stop=`date +%s`
  local start=${cmd_timestamp:-$stop}
  let local elapsed=$stop-$start
  [ $elapsed -gt 2 ] && echo ${elapsed}s
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
# PROMPT="%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
PROMPT="%(?.%F{green}.%F{red})❯%f " # Display a red prompt char on failure
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH
###############################################################################


# SHIFT-SELECT & ZSH LINE EDITOR (ZLE)
##############################################################################
# zsh-shift-select
#source ~/.local/share/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh

# zsh-shift-select combined with ctrl+x,c,v
# https://stackoverflow.com/a/30899296
r-delregion() {
  if ((REGION_ACTIVE)) then
    zle kill-region
  else
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}
r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}
r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}
# Set bindkey keybindings all together
for key       kcap     seq          mode       widget (
  # Movement Ctrl -> deselect ###################################
    right      x       $'\e[C'      deselect   forward-char
    left       x       $'\e[D'      deselect   backward-char
    home       x       $'\e[H'      deselect   beginning-of-line
    end        x       $'\e[F'      deselect   end-of-line
    pgup       x       $'\e[5~'     deselect   up-line
    pgdown     x       $'\e[6~'     deselect   down-line
    c_right    x       $'\e[1;3C'   deselect   forward-word
    c_left     x       $'\e[1;3D'   deselect   backward-word

  # Select Shift+Ctrl -> select #################################
    s_right    x      $'\e[1;2C'    select     forward-char
    s_left     x      $'\e[1;2D'    select     backward-char
    s_up       x      $'\e[1;2A'    select     up-line-or-history
    s_down     x      $'\e[1;2B'    select     down-line-or-history
    s_home     x      $'\e[1;2H'    select     beginning-of-line
    s_end      x      $'\e[1;2F'    select     end-of-line
    cs_right   x      $'\e[1;4C'    select     forward-word
    cs_left    x      $'\e[1;4D'    select     backward-word
    # cs_home    x      $'\e[1;6H'    select     beginning-of-line
    # cs_end     x      $'\e[1;6F'    select     end-of-line

  # Delete -> delregion #########################################
    del        x      $'\e[3~'      delregion  delete-char
    bs         x      $'^?'         delregion  backward-delete-char
  ) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

# Fix zsh-autosuggestions. Fixes autosuggest completion being overriden by keybindings:
# to have [zsh] autosuggest [plugin feature] complete visible suggestions, you can assign
# an array of shell functions to the `ZSH_AUTOSUGGEST_ACCEPT_WIDGETS` variable. When these functions
# are triggered, they will also complete any visible suggestion. https://stackoverflow.com/a/30899296
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
  key-right
)

# ctrl+x,c,v
# https://unix.stackexchange.com/a/634916/424080
zle-clipboard-cut() {
  if ((REGION_ACTIVE)); then
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | pbcopy #xclip -selection clipboard -in
    zle kill-region
  fi
}
zle -N zle-clipboard-cut
zle-clipboard-copy() {
  if ((REGION_ACTIVE)); then
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | pbcopy #xclip -selection clipboard -in
    #print -rn -- $CUTBUFFER | clip.exe #xclip -selection clipboard -in # for Windows
  else
    # Nothing is selected, so default to the interrupt command
    zle send-break
  fi
}
zle -N zle-clipboard-copy
zle-clipboard-paste() {
  if ((REGION_ACTIVE)); then
    zle kill-region
  fi
  #LBUFFER+="$(xclip -selection clipboard -out)"
  #LBUFFER+="$(cat clip.exe)" # for Windows
  LBUFFER+="$(pbpaste | cat)"
}
zle -N zle-clipboard-paste
# Exit ZLE mode; also this is workaround to make ^c (interrupt) work properly
my-zle-exit () {
  zle magic-space
  zle backward-delete-char
}
zle -N my-zle-exit
zle-pre-cmd() {
  # We are now in buffer editing mode. Clear the interrupt combo `Ctrl + C` by setting it to the null character, so it
  # can be used as the copy-to-clipboard key instead
  # stty intr "^@" # IMPORTANT! interfere with Powerlevel10k Instant prompt
  # FIX! https://github.com/romkatv/powerlevel10k/issues/388#issuecomment-567679874
  stty intr "^@" <$TTY >$TTY
}
precmd_functions=("zle-pre-cmd" ${precmd_functions[@]})
zle-pre-exec() {
  # We are now out of buffer editing mode. Restore the interrupt combo `Ctrl + C`.
  stty intr "^C"
}
preexec_functions=("zle-pre-exec" ${preexec_functions[@]})
# The `key` column is only used to build a named reference for `zle`
for key kcap seq   widget              arg (
    cx  _    $'^X' zle-clipboard-cut   _  # `Ctrl + X`
    cc  _    $'^C' zle-clipboard-copy  _  # `Ctrl + C`
    cv  _    $'^V' zle-clipboard-paste _  # `Ctrl + V` # Replaced by native iTerm paste functionality
    esc -    $'^[' my-zle-exit         _  # `Esc`
) {
  if [ "${arg}" = "_" ]; then
    eval "key-$key() {
      zle $widget
    }"
  else
    eval "key-$key() {
      zle-$widget $arg \$@
    }"
  fi
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

# Select entire prompt
# https://stackoverflow.com/a/68987551/13658418
widget::select-all() {
  local buflen=$(echo -n "$BUFFER" | wc -m | bc)
  CURSOR=$buflen   # if this is messing up try: CURSOR=9999999
  zle set-mark-command
  while [[ $CURSOR > 0 ]]; do
    zle beginning-of-line
  done
}
zle -N widget::select-all
bindkey '^[a' widget::select-all # Send escape sequence esc+a, bacause this interfere with 'home' button

# Clear scrollback buffer
clear-scrollback-buffer() {
  # Behavior of clear:
  # 1. clear scrollback if E3 cap is supported (terminal, platform specific)
  # 2. then clear visible screen
  # For some terminal 'e[3J' need to be sent explicitly to clear scrollback
  clear && printf '\e[3J'
  # .reset-prompt: bypass the zsh-syntax-highlighting wrapper
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  # -R: redisplay the prompt to avoid old prompts being eaten up
  # https://github.com/Powerlevel9k/powerlevel9k/pull/1176#discussion_r299303453
  zle && zle .reset-prompt && zle -R
}
zle -N clear-scrollback-buffer
bindkey '^k' clear-scrollback-buffer

# Undo ctrl-z
bindkey "^Z" undo


# FZF
###############################################################################
# Default command to work with other
__fzfcmd() {
  [ -n "${TMUX_PANE-}" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "${FZF_TMUX_OPTS-}" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

# ctrl+r cd/vi recent folders/files
fzf-fasd-cd-vi() {
# item="$(fasd -Rl "$1" | fzf -1 -0 --no-sort +m)" # fasdter when reading cache
  item="$(cat ~/.config/.fasd_cache | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")"
  if [[ -d ${item} ]]; then
    cd "${item}" || return 1
  elif [[ -f ${item} ]]; then
    (code "${item}" < /dev/tty) || return 1
  else
    return 1
  fi
  zle accept-line # Enable to accept on single press
  # zle reset-prompt # Not need, because function is called through the wrapper, which already handles the prompt reset with its own
  # return $ret
}
# Run widget from another function to work properly
run-fzf-fasd-cd-vi(){fzf-fasd-cd-vi; local ret=$?; zle reset-prompt; return $ret}
zle -N run-fzf-fasd-cd-vi
bindkey '^[r' run-fzf-fasd-cd-vi

# ctrl+shift+r search history
fzf-history() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=($(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd)))
  local ret=$?
  # local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle accept-line
}
run-fzf-history(){fzf-history; local ret=$?; zle reset-prompt; return $ret}
zle -N run-fzf-history
bindkey '^r' run-fzf-history

# ctrl+shift+f search local and cd/vi
fzf-find-local() {
  item="$(find '.' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")"
  if [[ -d ${item} ]]; then
    cd "${item}" || return 1
  elif [[ -f ${item} ]]; then
    (code "${item}" < /dev/tty) || return 1
  else
    return 1
  fi
  zle accept-line
}
run-fzf-find-local(){fzf-find-local; local ret=$?; zle reset-prompt; return $ret}
zle -N run-fzf-find-local
bindkey '^f' run-fzf-find-local
bindkey '^p' run-fzf-find-local

# ctrl+o open file in vscode
fzf-vi() {
  file="$(find '.' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -type f -iname '*' 2>/dev/null | fzf -1 -0 --no-sort +m)" && code "${file}" || return 1
  zle acceptl-line
}
run-fzf-vi(){fzf-vi; local ret=$?; zle reset-prompt; return $ret}
zle -N run-fzf-vi
bindkey '^o' run-fzf-vi

# # ctrl+shif+f search global modified
# fzf-find-global() {
#    item="$(find '/' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")"
#   if [[ -d ${item} ]]; then
#     cd "${item}" || return 1
#   elif [[ -f ${item} ]]; then
#     (vi "${item}" < /dev/tty) || return 1
#   else
#     return 1
#   fi
#    zle accept-line
# }
# #zle -N fzf-find-global; bindkey '^]' fzf-find-global
# run-fzf-find-global(){fzf-find-global; local ret=$?; zle reset-prompt; return $ret}
# zle -N run-fzf-find-global
# bindkey '^]' run-fzf-find-global

# # ctrl+k+o cd folder global
# fzf-cd() {
#   local cmd="${FZF_ALT_C_COMMAND:-"command find '/' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -type d -iname '*' 2>/dev/null"}"
#   setopt localoptions pipefail no_aliases 2> /dev/null
#   local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
#  if [[ -z "$dir" ]]; then
#     zle redisplay
#     return 0
#   fi
#   zle push-line # Clear buffer. Auto-restored on next prompt.
#   BUFFER="cd ${(q)dir}"
#   zle accept-line
#   local ret=$?
#   unset dir # ensure this doesn't end up appearing in prompt expansion
#   zle reset-prompt
#   return $ret
# }
# zle -N fzf-cd
# bindkey '^k^o' fzf-cd

# # ctrl+o vi file global
# fzf-vi() {
#    file="$( find '/' -type d \( -path '**/mnt*' -o -path '**/proc*' -o -path '**/dev*' -o -path '**/.cache*' -o -path '**/.vscode*' -o -path '**/.npm*' -o -path '**/.nvm*' -o -name 'node_modules' -o -name '*git*' -o -path '**/.trash*' -o -path '**/.local/share/pnpm*' -o -path '**/.quokka*' \) -prune -false -o -type f -iname '*' 2>/dev/null | fzf -1 -0 --no-sort +m)" && (vi "${file}" < /dev/tty) || return 1
#    zle acceptl-line
# }
# #zle -N fzf-vi; bindkey '^o' fzf-vi
# run-fzf-vi(){fzf-vi; local ret=$?; zle reset-prompt; return $ret}
# zle -N run-fzf-vi
# bindkey '^o' run-fzf-vi

# LF
###############################################################################
# #ctrl+s lfcd allow keep current dir on exit
# lfcd () {
#   tmp="$(mktemp)"
#   lf -last-dir-path="$tmp" "$@"
#   if [ -f "$tmp" ]; then
#       dir="$(cat "$tmp")"
#       rm -f "$tmp"
#       if [ -d "$dir" ]; then
#           if [ "$dir" != "$(pwd)" ]; then
#               cd "$dir"
#           fi
#       fi
#   fi
#   zle accept-line
#   zle reset-prompt
# }
# zle -N lfcd
# bindkey '^[[18~' lfcd
# bindkey '^s' lfcd

# Shell movement
###############################################################################
# up-dir() {
#   builtin cd ..
#   zle accept-line
#   zle reset-prompt
# }
# zle -N up-dir
# bindkey "^[[" up-dir

# prev-dir(){
#   builtin cd -
#   zle accept-line
#   zle reset-prompt
# }
# zle -N prev-dir
# bindkey "^[]" prev-dir
# zsh commands https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html