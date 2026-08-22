#!/usr/bin/env bash

set -euo pipefail

# Make Mason-installed formatters available outside Neovim.
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Always operate from the root of the Git repository.
repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

mapfile -d '' -t files < <(git ls-files -z)

lua_files=()
bash_files=()
prettier_files=()
python_files=()

for file in "${files[@]}"; do
    # Ignore tracked files that have been deleted locally.
    [[ -f $file ]] || continue

    case "$file" in
        *.lua)
            lua_files+=("$file")
            ;;

        *.sh | .bashrc | .bash_profile | .bash_login | .bash_logout)
            bash_files+=("$file")
            ;;

        *.js | *.jsx | *.ts | *.tsx | *.css | *.html | *.json | *.jsonc)
            prettier_files+=("$file")
            ;;

        *.py)
            python_files+=("$file")
            ;;
    esac
done

if ((${#lua_files[@]})); then
    stylua --search-parent-directories "${lua_files[@]}"
fi

if ((${#bash_files[@]})); then
    shfmt -w "${bash_files[@]}"
fi

if ((${#prettier_files[@]})); then
    prettier --write "${prettier_files[@]}"
fi

if ((${#python_files[@]})); then
    ruff format "${python_files[@]}"
fi

exit 0
