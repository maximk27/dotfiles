#!/usr/bin/env bash
# tmux-resurrect post-save-layout hook.
# $1: "quiet" for continuum autosaves, empty for manual prefix+C-s saves
# $2: the freshly written resurrect file
#
# Keeps: config, cpp, the most recently attached other session, and pinned sessions.
# A manual save pins the current session so later autosaves keep it.
mode="$1"
file="$2"
pinned="$HOME/.local/share/tmux/resurrect/pinned"
touch "$pinned"

if [ "$mode" != "quiet" ]; then
	cur=$(tmux display-message -p '#S')
	grep -qxF -- "$cur" "$pinned" || printf '%s\n' "$cur" >> "$pinned"
fi

# forget pins for sessions that no longer exist
live=$(tmux list-sessions -F '#S')
grep -xF -f <(printf '%s\n' "$live") "$pinned" > "$pinned.tmp"
mv "$pinned.tmp" "$pinned"

recent=$(tmux list-sessions -F '#{session_last_attached} #S' |
	grep -vE '^[0-9]+ (config|cpp)$' | sort -n | tail -1 | cut -d' ' -f2-)

keep=$(printf '%s\n' config cpp "$recent"; cat "$pinned")

awk -F'\t' -v keep="$keep" '
	BEGIN { n = split(keep, a, "\n"); for (i = 1; i <= n; i++) k[a[i]] = 1 }
	$1 == "state" || ($2 in k)
' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
