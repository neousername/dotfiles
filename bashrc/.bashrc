#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'
}

# Colors
RED="\[$(tput bold setaf 1)\]"
YELLOW="\[$(tput bold setaf 3)\]"
BLUE="\[$(tput bold setaf 4)\]"
RESET="\[$(tput sgr0)\]"

# Prompt
PS1="${YELLOW}\W${RESET} → ${BLUE}git:(${RESET}${RED}\$(parse_git_branch)${RESET}${BLUE})${RESET} ❯ "
