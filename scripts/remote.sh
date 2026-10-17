# for remotes: source from ~/.bashrc or ~/.zshrc there.
# needs ~/scripts/aliases-core.sh (+ runner.sh) and ~/.config/nvim copied over.

export NVIM_LITE=1
export EDITOR=nvim

# nvim tarball in ~/.local when the distro one is too old
[ -d "$HOME/.local/nvim/bin" ] && PATH="$HOME/.local/nvim/bin:$PATH"

[ -f ~/scripts/aliases-core.sh ] && . ~/scripts/aliases-core.sh
[ -f ~/scripts/runner.sh ] && . ~/scripts/runner.sh
