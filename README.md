## Setup on a new machine

Needs SSH access to GitHub (`ssh -T git@github.com`). On a box without a key,
connect with `ssh -A` or swap the URLs below for `https://github.com/...`.

```
git clone --bare git@github.com:maximk27/dotfiles.git "$HOME/.dotfiles"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config status.showUntrackedFiles no

# if any conflicting files, moves to $backup, replacing
backup="$HOME/.dotfiles-backup"
files=$(dot checkout 2>&1 | grep -E "^\s+\S" | awk '{print $1}')
if [ -n "$files" ]; then
    echo "$files" | while IFS= read -r f; do
        mkdir -p "$backup/$(dirname "$f")"
        mv "$f" "$backup/$f"
    done
    echo "backup on $files"
fi

# bring into system
dot checkout

# nvim config is a submodule (run from $HOME)
cd ~ && dot submodule update --init

# check deps, --install puts missing ones in ~/.local
~/scripts/deps.sh --install
```

Paste these into an interactive shell. Aliases don't expand in bash scripts, so
if you save this as a script, replace the alias with
`dot() { /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"; }`.

Then start tmux and press `C-x I` to install the tmux plugins (tpm itself is
cloned by `deps.sh --install`).

Gnome settings (desktop only)
```
cd ~/.config/gnome
dconf load /org/gnome/desktop/peripherals/keyboard/ < keyboard.ini
dconf load /org/gnome/desktop/wm/keybindings/ < wm-keybindings.ini
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < media-keys.ini
dconf load /org/gnome/settings-daemon/plugins/color/ < night-light.ini
```

## Dependencies
`~/scripts/deps.sh` checks everything the configs rely on and exits non-zero if
something required is missing. `--install` fetches what doesn't need root into
`~/.local` (works on machines without sudo):

| | tools | `--install` |
|---|---|---|
| required | fzf ≥ 0.59, nvim ≥ 0.11, ripgrep, zoxide, tree-sitter ≥ 0.25, tpm, oh-my-zsh + plugins | yes |
| required | git, tmux ≥ 3.3, zsh, a C compiler | no, use the package manager |
| recommended | fd | yes |
| recommended | xclip/xsel, node | no |

On a network home (CAEN's is an SMB share) nvim is installed to
`/var/tmp/$USER/nvim` on local disk with `~/.local/nvim` symlinked to it, and
`remote.sh` keeps nvim's cache/undo/shada there too, since small-file reads over
the share make nvim slow. The local copy is per machine, so on a different CAEN
box (or after `/var/tmp` is cleaned) re-run `deps.sh --install`.

The oh-my-zsh checks are skipped when zsh isn't installed. Re-run `deps.sh`
after installing to confirm everything shows `ok`.

## Remotes
On a machine where you use bash (or don't want the full `.zshrc`), do the setup
above, then:
```
echo '. ~/scripts/remote.sh' >> ~/.bashrc
```
`remote.sh` puts `~/.local/bin` on PATH, loads the portable aliases, and sets
`NVIM_LITE=1` so nvim starts without plugins.

Nested tmux: the bar colour shows the machine (blue local, orange remote) and
the top bar is the tmux your prefix goes to. Press `C-]` to turn the local tmux
off so every key, prefix included, goes to the remote one: the local bar drops
to the bottom, the remote bar moves to the top, and the mouse moves with it.
Press `C-]` again to swap back. Copying in the remote tmux reaches the local
clipboard over OSC 52.

## Maintain
Files
```
dot <git operation>
```

nvim config (its own repo): commit and push inside `~/.config/nvim`, then
record the new commit here
```
dot add ~/.config/nvim && dot commit -m "bump nvim"
```
and pull it on other machines with `dot pull && dot submodule update`.

Gnome settings
```
cd ~/.config/gnome
dconf dump /org/gnome/desktop/peripherals/keyboard/ > keyboard.ini
dconf dump /org/gnome/desktop/wm/keybindings/ > wm-keybindings.ini
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > media-keys.ini
dconf dump /org/gnome/settings-daemon/plugins/color/ > night-light.ini
```

Uninstall: `~/scripts/uninstall.sh` removes the tracked files, restores
`~/.dotfiles-backup`, and deletes `~/.dotfiles`.
