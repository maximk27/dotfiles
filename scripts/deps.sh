#!/usr/bin/env bash
# Check the tools these dotfiles depend on.
#   deps.sh            report what's missing or too old
#   deps.sh --install  also install what can go in user space (~/.local, no root):
#                      fzf rg fd zoxide tree-sitter nvim, oh-my-zsh + plugins, tpm
# zsh, tmux, git and a C compiler need the system package manager.
set -u

BIN="$HOME/.local/bin"
install=0
[ "${1:-}" = "--install" ] && install=1

case $(uname -m) in
x86_64) rust_arch=x86_64 go_arch=amd64 nvim_arch=x86_64 ts_arch=x64 ;;
aarch64 | arm64) rust_arch=aarch64 go_arch=arm64 nvim_arch=arm64 ts_arch=arm64 ;;
*) rust_arch=unknown ;;
esac

missing=0
have() { command -v "$1" >/dev/null 2>&1; }
ok() { printf '  \033[32mok\033[0m    %-14s %s\n' "$1" "$2"; }
bad() { printf '  \033[31mmiss\033[0m  %-14s %s\n' "$1" "$2"; missing=1; }
warn() { printf '  \033[33mwarn\033[0m  %-14s %s\n' "$1" "$2"; }

# version_ge 0.11.2 0.11 -> true
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]; }

# first x.y[.z] in a command's version output
version_of() { "$@" 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1; }

# url of the latest release asset of github repo $1 matching regex $2
asset_url() {
	curl -fsSL "https://api.github.com/repos/$1/releases/latest" |
		grep -oE '"browser_download_url": *"[^"]+"' | cut -d'"' -f4 |
		grep -E "$2" | head -1
}

# download a release tarball of $1 matching $2, copy binary $3 into $BIN
install_tar_bin() {
	local url tmp
	url=$(asset_url "$1" "$2") || true
	[ -n "$url" ] || { echo "    no release asset for $1 ($2)"; return 1; }
	tmp=$(mktemp -d)
	echo "    fetching $url"
	curl -fsSL "$url" | tar -xz -C "$tmp" &&
		install -m755 "$(find "$tmp" -type f -name "$3" | head -1)" "$BIN/$3"
	rm -rf "$tmp"
}

install_fzf() { install_tar_bin junegunn/fzf "linux_${go_arch}\.tar\.gz$" fzf; }
install_rg() { install_tar_bin BurntSushi/ripgrep "${rust_arch}-unknown-linux-(musl|gnu)\.tar\.gz$" rg; }
install_fd() { install_tar_bin sharkdp/fd "${rust_arch}-unknown-linux-musl\.tar\.gz$" fd; }
install_zoxide() { install_tar_bin ajeetdsouza/zoxide "${rust_arch}-unknown-linux-musl\.tar\.gz$" zoxide; }

install_tree_sitter() {
	local url
	url=$(asset_url tree-sitter/tree-sitter "tree-sitter-linux-${ts_arch}\.gz$") || true
	[ -n "$url" ] || { echo "    no tree-sitter release asset"; return 1; }
	echo "    fetching $url"
	curl -fsSL "$url" | gunzip >"$BIN/tree-sitter" && chmod +x "$BIN/tree-sitter"
}

# goes in ~/.local/nvim, which remote.sh puts on PATH
install_nvim() {
	local url
	url=$(asset_url neovim/neovim "nvim-linux-${nvim_arch}\.tar\.gz$") || true
	[ -n "$url" ] || { echo "    no nvim release asset"; return 1; }
	echo "    fetching $url"
	rm -rf "$HOME/.local/nvim" && mkdir -p "$HOME/.local/nvim" &&
		curl -fsSL "$url" | tar -xz -C "$HOME/.local/nvim" --strip-components=1
}

# check NAME MIN_VERSION VERSION_CMD... ; installs via install_NAME when --install
check() {
	local name=$1 min=$2 cmd=$3 v
	shift 2
	if have "$cmd"; then
		v=$(version_of "$@")
		if [ -z "$min" ] || version_ge "${v:-0}" "$min"; then
			ok "$name" "$v"
			return
		fi
		bad "$name" "$v < $min"
	else
		bad "$name" "not found${min:+ (need >= $min)}"
	fi
	if [ $install -eq 1 ] && declare -F "install_${name//-/_}" >/dev/null; then
		if [ "$rust_arch" = unknown ]; then
			echo "    unsupported arch $(uname -m), skipping"
		elif "install_${name//-/_}"; then
			echo "    installed $name"
		fi
	fi
}

# check_dir NAME DIR GIT_URL ; clones when --install
check_dir() {
	if [ -d "$2" ]; then
		ok "$1" "$2"
		return
	fi
	bad "$1" "no $2"
	if [ $install -eq 1 ]; then
		git clone --depth 1 "$3" "$2" && echo "    installed $1"
	fi
}

[ $install -eq 1 ] && mkdir -p "$BIN"
orig_path=$PATH
export PATH="$BIN:$HOME/.local/nvim/bin:$PATH"

echo "required"
check git "" git --version
check fzf 0.59 fzf --version
check nvim 0.11 nvim --version
check rg "" rg --version
check zoxide "" zoxide --version
check tree-sitter 0.25 tree-sitter --version
if have cc || have gcc || have clang; then ok "cc" "$(command -v cc gcc clang | head -1)"; else bad "cc" "no C compiler (treesitter parsers)"; fi
check tmux 3.3 tmux -V
check_dir tpm "$HOME/.tmux/plugins/tpm" https://github.com/tmux-plugins/tpm
if [ -f "$HOME/.config/nvim/init.lua" ]; then
	ok "nvim-config" "~/.config/nvim"
else
	bad "nvim-config" "empty, run: cd ~ && dot submodule update --init"
fi

# zsh setup only matters where .zshrc is used; remotes source remote.sh from bash
if have zsh; then
	ZSH="${ZSH:-$HOME/.oh-my-zsh}"
	ok "zsh" "$(version_of zsh --version)"
	check_dir oh-my-zsh "$ZSH" https://github.com/ohmyzsh/ohmyzsh
	check_dir zsh-syntax-hl "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting" \
		https://github.com/zsh-users/zsh-syntax-highlighting
	check_dir zsh-autosugg "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions" \
		https://github.com/zsh-users/zsh-autosuggestions
else
	warn "zsh" "not found, skipping oh-my-zsh (fine on bash remotes)"
fi

echo "recommended"
if have fd; then
	ok "fd" "$(version_of fd --version)"
else
	warn "fd" "not found (telescope find_files, yazi search)"
	[ $install -eq 1 ] && install_fd && echo "    installed fd"
fi
if have xclip || have xsel; then ok "clipboard" "$(command -v xclip xsel | head -1)"; else warn "clipboard" "no xclip/xsel (tmux y, extrakto)"; fi
if have node; then ok "node" "$(version_of node --version)"; else warn "node" "not found (pyright, bashls, mason)"; fi

if [ $missing -eq 1 ]; then
	echo
	[ $install -eq 0 ] && echo "run with --install to fetch user-space tools into ~/.local"
	case ":$orig_path:" in *":$BIN:"*) ;; *) echo "note: add $BIN to PATH" ;; esac
	exit 1
fi
