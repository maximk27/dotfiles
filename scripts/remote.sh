# for remotes: source from ~/.bashrc or ~/.zshrc there.
# run ~/scripts/deps.sh --install first for fzf, rg, nvim etc.

export NVIM_LITE=1
export EDITOR=nvim

# user-space tools from deps.sh --install, and the nvim tarball when the distro one is too old
PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/nvim/bin" ] && PATH="$HOME/.local/nvim/bin:$PATH"

[ -f ~/scripts/aliases-core.sh ] && . ~/scripts/aliases-core.sh
[ -f ~/scripts/runner.sh ] && . ~/scripts/runner.sh
