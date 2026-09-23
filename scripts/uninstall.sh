#!/bin/bash

# 1. Remove all files placed into $HOME
dot ls-tree -r --name-only HEAD | while IFS= read -r f; do
    rm -f "$HOME/$f"
done

# 2. Restore backup
backup="$HOME/.dotfiles-backup"
if [ -d "$backup" ]; then
    cp -a "$backup/." "$HOME/"
    rm -rf "$backup"
fi

# 3. Remove repo
rm -rf "$HOME/.dotfiles"

# 4. Drop alias
unalias dot
