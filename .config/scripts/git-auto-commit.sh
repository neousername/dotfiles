#!/usr/bin/bash

set -euo pipefail

readonly repo="$HOME"
readonly keychain_env="$HOME/.keychain/$(uname -n)-sh"
readonly remote_ref="refs/remotes/origin/main"
readonly lock_file="${XDG_RUNTIME_DIR:-/tmp}/git-auto-commit.lock"

exec 9>"$lock_file"
if ! flock -n 9; then
	printf 'Another automatic Git job is already running.\n'
	exit 0
fi

# Ghostty starts keychain through .bashrc, so allow it time to create the agent state.
for attempt in {1..12}; do
	if [[ -r "$keychain_env" ]]; then
		# shellcheck disable=SC1090
		source "$keychain_env"
		if ssh-add -l >/dev/null 2>&1; then
			break
		fi
	fi

	if (( attempt == 12 )); then
		printf 'SSH keychain is unavailable after waiting for one minute.\n' >&2
		exit 1
	fi

	sleep 5
done

cd "$repo"

current_branch="$(git symbolic-ref --quiet --short HEAD)"
if [[ "$current_branch" != "main" ]]; then
	printf 'Expected branch main, but repository is on %s.\n' "$current_branch" >&2
	exit 1
fi

git fetch --quiet origin '+refs/heads/main:refs/remotes/origin/main'

if ! git merge-base --is-ancestor "$remote_ref" HEAD; then
	printf 'origin/main is ahead of or has diverged from local main; stopping.\n' >&2
	exit 1
fi

git add -A

if ! git diff --cached --quiet; then
	git commit -m "Automatic-Daily-Commit $(date +%F)"
fi

if [[ "$(git rev-parse HEAD)" == "$(git rev-parse "$remote_ref")" ]]; then
	printf 'No local changes or commits to push.\n'
	exit 0
fi

git push origin HEAD:refs/heads/main
