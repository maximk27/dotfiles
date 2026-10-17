#!/usr/bin/env bash
# Stop autosaving the current session (undoes a manual prefix+C-s).
pinned="$HOME/.local/share/tmux/resurrect/pinned"
cur=$(tmux display-message -p '#S')
[ -f "$pinned" ] && grep -vxF -- "$cur" "$pinned" > "$pinned.tmp"; mv "$pinned.tmp" "$pinned" 2>/dev/null
tmux display-message "Unpinned $cur"
