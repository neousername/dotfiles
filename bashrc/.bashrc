#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# My aliases
alias g="lazygit"
alias c='opencode --auto'
alias t="tmux"

PS1='❯ '
