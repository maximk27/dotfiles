# for remotes: source from ~/.bashrc or ~/.zshrc there.
# run ~/scripts/deps.sh --install first for fzf, rg, nvim etc.

export NVIM_LITE=1
export EDITOR=nvim

# user-space tools from deps.sh --install, and the nvim tarball when the distro one is too old
PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/nvim/bin" ] && PATH="$HOME/.local/nvim/bin:$PATH"

# network home (CAEN's is SMB): keep nvim's cache/undo/shada/swap on local disk.
# undo history and recent files are then per machine.
case $(stat -f -c %T "$HOME" 2>/dev/null) in
cifs | smb* | nfs* | afs | fuse*)
	export XDG_CACHE_HOME="/var/tmp/$USER/cache" XDG_STATE_HOME="/var/tmp/$USER/state"
	mkdir -p "$XDG_CACHE_HOME" "$XDG_STATE_HOME"
	;;
esac

[ -f ~/scripts/aliases-core.sh ] && . ~/scripts/aliases-core.sh
[ -f ~/scripts/runner.sh ] && . ~/scripts/runner.sh
