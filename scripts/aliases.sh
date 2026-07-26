# new stuff
alias cc="openclaude"

# fzf
local fzf_open() {
    local dir="${1:-.}"
    local file
    file=$(ls "$dir" | fzf --popup 80%) && open "$dir/$file"
}
function fsd() { fzf_open ~/Downloads; }
function fsd() { fzf_open ~/books; }
alias fs="fzf --popup 80% --bind 'enter:become(vim {})'"
function cpi() {
    local file
    file=$(ls ~/templates | fzf --popup 80%) && cp ~/templates/"$file" .
}

# python
alias uvr="uv run"
alias uvb="uv build"
alias uvl="uv sync"
alias uva="uv add"
alias uvf="uv run ruff check . --fix && uv run ruff format ."

# jj
alias hg="jj"
alias hgs="jj st"
alias hgha="jj log -r '@ | ancestors(remote_bookmarks().., 2) | trunk()'"
alias hgh="jj log"
alias hgu="jj edit"
alias hge="jj new"
alias hgq="jj abandon"
alias hgc="jj describe"
alias hgba="jj b a"
alias hgbap="jj b a && jj git push"

alias hgg="hg git"
alias hgp="jj git push"
alias hgl="jj git pull"

alias hgre="jj rebase"
alias hgsqu="jj squash"
alias hgspl="jj split"

function hgw() {
    local target="${1:-}"
    jj show --git --no-pager $target | diff2html -i stdin --style side
}

# git stuff
alias gi="git init"
alias gaa="git add -A"
alias gsw="git switch"
alias gc="git commit --verbose"
alias gca="git commit --amend"
alias gp="git push"
alias gl="git pull"
alias gst="git status"
alias gf="git fetch"
alias gm="git merge"
alias grb="git rebase"
alias gr="git remote"
alias glg="git log --graph -n5"
alias gw="git worktree"

# github
alias ghr="gh repo view --web"
alias ghl="gh pr list --web"
alias ghc="gh pr create"

# shell commmands
alias dot="git --git-dir=$HOME/.dotfiles --work-tree=$HOME/"
alias pbcopy="xclip -sel clip"
alias df="duf"
alias ls="eza --icons"
alias open="xdg-open"
alias diff="diff -yb"
# alias tar="tar -xzvf"

function tree() {
    name=${1:-"."}
    count=${2:-"3"}
    eza --icons -T $name -L $count
}

# coding
alias nb="ninja"
alias e="nvim ."

# cpp
alias tl="ctest"
alias make="bear -- make -j8"

# python
alias py="python"

# rust
alias c="cargo"

# go
alias g="go"

# ctf
alias disas="objdump -drwC -Mintel"

# for seeing
alias aliass="cat ~/scripts/aliases.sh | less"
