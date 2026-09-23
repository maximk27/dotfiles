#!/bin/bash
backup="$HOME/.dotfiles-backup"
files=$(dot checkout 2>&1 | egrep "^\s+\." | awk '{print $1}')
if [ -n "$files" ]; then
    mkdir -p "$backup"
    echo "$files" | xargs -I{} mv {} "$backup/{}"
    echo "backup"
fi
dot checkout
