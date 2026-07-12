# For native installed apps
export PATH="$HOME/.local/bin:$PATH"

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

[[ $- != *i* ]] && return

eval "$(keychain --quiet --eval id_ed25519)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# My aliases
alias g="lazygit"
alias ocserve="opencode serve --port"
alias ocattach="opencode attach http://localhost:4096"

PS1='[\W]\$ '
