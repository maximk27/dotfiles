#!/usr/bin/env bash
# Session picker: other sessions on top (most recent first), config and cpp at the bottom.
# With an empty query a digit jumps straight to that index; otherwise type part of a
# name (prefix matches rank first) and press Enter. Ctrl-d kills the highlighted session.
# Enter with no match, or ctrl-n with any query, creates a session named after the query
# in the current pane's directory.
cur=$(tmux display-message -p '#S')

if [ "$1" = "--list" ]; then
	{
		tmux list-sessions -F '#{session_last_attached} #S' | sort -rn | cut -d' ' -f2- |
			grep -vxF -e config -e cpp -e "$cur"
		printf '%s\n' config cpp
	} | awk 'NF { printf "%d %s\n", ++n, $0 }'
	exit
fi

binds=()
for i in 1 2 3 4 5 6 7 8 9; do
	binds+=(--bind "$i:transform:[ -z {q} ] && echo 'pos($i)+accept' || echo 'put($i)'")
done
binds+=(--bind "ctrl-d:execute-silent(tmux kill-session -t ={2..})+reload($0 --list)")

out=$("$0" --list | fzf --layout=reverse --exact --nth=2.. \
	--tiebreak=begin,index --no-info --with-shell 'bash -c' --prompt="session ($cur)> " \
	--header='enter/1-9: switch   ctrl-n: new   ctrl-d: kill' \
	--print-query --expect=ctrl-n "${binds[@]}")
[ $? -eq 130 ] && exit 0 # esc / ctrl-c

{ read -r query; read -r key; read -r choice; } <<<"$out"

if [ "$key" = ctrl-n ] || [ -z "$choice" ]; then
	name=${query//[.:]/_} # tmux forbids . and : in session names
	[ -z "$name" ] && exit 0
	tmux has-session -t "=$name" 2>/dev/null ||
		tmux new-session -d -s "$name" -c "$(tmux display-message -p '#{pane_current_path}')"
	tmux switch-client -t "=$name"
	exit
fi
tmux switch-client -t "=${choice#* }"
