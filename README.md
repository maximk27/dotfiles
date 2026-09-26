## Setup on a new machine


Setup
```
git clone --bare git@github.com:maximk27/dotfiles.git "$HOME/.dotfiles"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config status.showUntrackedFiles no

# if any conflicting files, moves to $backup, replacing
backup="$HOME/.dotfiles-backup"
files=$(dot checkout 2>&1 | egrep "^\s+\S" | awk '{print $1}')
if [ -n "$files" ]; then
    echo "$files" | while IFS= read -r f; do
        mkdir -p "$backup/$(dirname "$f")"
        mv "$f" "$backup/$f"
    done
    echo "backup on $files"
fi

# bring into system
dot checkout
```


Gnome settings
```
dconf load /org/gnome/desktop/peripherals/keyboard/ < keyboard.ini
dconf load /org/gnome/desktop/wm/keybindings/ < wm-keybindings.ini
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < media-keys.ini
dconf load /org/gnome/settings-daemon/plugins/color/ < night-light.ini
```

## Maintain


Files
```
dot <git operation>
```

Gnome settings
```
dconf dump /org/gnome/desktop/peripherals/keyboard/ > keyboard.ini
dconf dump /org/gnome/desktop/wm/keybindings/ > wm-keybindings.ini
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > media-keys.ini
dconf dump /org/gnome/settings-daemon/plugins/color/ > night-light.ini
```

