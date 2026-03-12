# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

############
alias f='fastfetch'
# Cp/Mv alternative
alias rcp='rsync -av --info=progress2 --human-readable --stats'
alias rmv='rsync -av --remove-source-files --info=progress2 --human-readable --stats'

alias s='sudo su '
alias ss='sudo su -'
alias b='btop'
# alias nv ="nvim"
alias x='exit'
alias t='tmux'
# alias cat='bat'
alias c='clear'
### ALIASES ###
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Enhanced eza aliases with icons

# Basic listing
alias l='eza -a --color=always --group-directories-first --icons'
alias ll='eza -lah --color=always --group-directories-first --icons --time-style=long-iso'
alias ls='eza --icons'

# Tree view
alias lt='eza -aT --color=always --group-directories-first --icons'

# Hidden files
alias l.='eza -al --color=always --group-directories-first --icons | egrep "^\."'

# Parent directories
alias l.1='eza -al --color=always --group-directories-first --icons ../'    # 1 level up
alias l.2='eza -al --color=always --group-directories-first --icons ../../'  # 2 levels up
alias l.3='eza -al --color=always --group-directories-first --icons ../../../' # 3 levels up

# Fun aliases with emojis
alias lsf='ls -lhF --icons'               # 🗂️ Fancy listing
compdef eza=ls

# change your default USER shell
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in for change to take effect.'"


# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Ssh aliases
alias k="ssh user@192.168.122.127"
alias e="ssh root@192.168.122.26"
alias w="ssh wazuh-admin@192.168.122.254"
alias z="ssh zabbix-admin@192.168.122.253"
alias u="ssh ubuntu-admin@192..168.122.204"
# Shell integrations

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet


eval "$(starship init zsh)"
# Pour Qt5
export QT_QPA_PLATFORMTHEME=qt5ct

# Pour Qt6
# export QT_QPA_PLATFORMTHEME=qt6ct

export TERM=xterm-256color
# Always work in a tmux session if Tmux is installed
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
    if ! tmux has-session -t Default 2>/dev/null; then
        tmux new-session -d -s Default 
        tmux source-file ~/.config/tmux/tmux.conf
    fi
    tmux attach -t Default
fi


export EDITOR="nvim"
export VISUAL="nvim"   # Some programs use VISUAL
#xhost +SI:localuser:root



# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Shows full aliases
zstyle ':completion:*' completer _expand_alias _complete _ignored
export PATH="$HOME/.local/bin:$PATH"

# FZF command history search
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"

# CTRL-R to search history
bindkey '^R' fzf-history-widget

# Define the widget
fzf-history-widget() {
  local selected_command
  selected_command=$(fc -rl 1 | awk '{$1=""; print substr($0,2)}' | fzf --tac --ansi --preview 'echo {}' --preview-window=up:3:wrap)
  if [[ -n "$selected_command" ]]; then
    LBUFFER="$selected_command"
  fi
}
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget

# xhost +SI:localuser:root
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
