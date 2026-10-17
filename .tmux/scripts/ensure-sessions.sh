#!/usr/bin/env bash
# Make sure the permanent sessions exist.
for spec in "config:$HOME/.config" "cpp:$HOME/code/cpp"; do
	name=${spec%%:*}
	dir=${spec#*:}
	tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$dir"
done
