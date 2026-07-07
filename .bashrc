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

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# My aliases
# I use ollama to filter my emails with thunderbird
alias olserve="OLLAMA_KEEP_ALIVE=-1 OLLAMA_NUM_PARALLEL=2 OLLAMA_CONTEXT_LENGTH=8192 OLLAMA_ORIGINS='moz-extension://*' ollama serve"
alias ocserve="opencode serve --port"
alias ocattach="opencode attach http://localhost:4096"

PS1='[\W]\$ '
