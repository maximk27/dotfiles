# portable stuff first
source ~/scripts/aliases-core.sh


fix_trackpad() { sudo rmmod i2c_hid_acpi && sudo modprobe i2c_hid_acpi };

# new stuff
alias cc="claude"
alias conn="/opt/cisco/secureclient/bin/vpn connect umvpn.umnet.umich.edu/umvpn-split-tunnel-alt"

# umich
alias vcs="ssh -f -L 5951:localhost:5951 maximk@login-course.engin.umich.edu 'sleep 30' && vncviewer localhost:5951"

# fzf
_fzf_action() {
    local dir="${1:-.}"
    local cmd="${2:-open}"
    local file
    file=$(ls "$dir" | fzf --popup 80%) && "$cmd" "$dir/$file"
}

function fsd() { _fzf_action ~/Downloads; }
function fsb() { _fzf_action ~/books; }
alias fs="fzf --popup 80% --bind 'enter:become(vim {})'"
function cpi() {
    local file
    file=$(ls -A ~/templates | fzf --popup 80%) && cp ~/templates/"$file" .
}

# python
alias uvr="uv run"
alias uvb="uv build"
alias uvl="uv sync"
alias uva="uv add"
alias uvf="uv run ruff check . --fix && uv run ruff format ."

# jj
function hgw() {
    local target="${1:-}"
    jj show --git --no-pager $target | diff2html -i stdin --style side
}

# github
alias ghr="gh repo view --web"
alias ghl="gh pr list --web"
alias ghc="gh pr create"

# shell commmands
alias dot="git --git-dir=$HOME/.dotfiles --work-tree=$HOME/"
alias pbcopy="xclip -sel clip"
alias pbpaste="xclip -selection clipboard -o"
alias open="xdg-open"
# alias tar="tar -xzvf"

# coding
alias nb="ninja"

# cpp
alias tl="ctest"

# rust
alias c="cargo"

# go
alias g="go"

# for seeing
alias aliass="cat ~/scripts/aliases-core.sh ~/scripts/aliases.sh | less"
