# portable aliases: safe in bash and zsh, on boxes missing most tools.
# sourced by aliases.sh locally, and on its own on remotes.

have() { command -v "$1" >/dev/null 2>&1; }

# tmux: reattach if a server is running, otherwise start one (continuum restores)
alias t="tmux attach 2>/dev/null || tmux"

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

# jj
if have jj; then
    alias hg="jj"
    alias hgs="jj st"
    alias hgha="jj log -r '@ | ancestors(remote_bookmarks().., 2) | trunk()'"
    alias hgh="jj log"
    alias hgu="jj edit"
    alias hge="jj new"
    alias hgQ="jj abandon"
    alias hgc="jj describe"
    alias hgba="jj b a"
    alias hgbap="jj b a && jj git push"
    alias hgrm="jj file untrack"

    alias hgg="jj git"
    alias hgp="jj git push"
    alias hgl="jj git pull"
    alias hg+="jj redo"
    alias hg-="jj undo"

    alias hgre="jj rebase"
    alias hgq="jj squash"
    alias hgspl="jj split"
    alias hgd="jj diff"
fi

# shell commmands
have duf && alias df="duf"
have eza && alias ls="eza --icons=auto"
alias di="diff -yb"

if have eza; then
    tree() {
        eza --icons -T "${1:-.}" -L "${2:-3}"
    }
fi

# coding
alias e="nvim ."
alias py="python3"
have bear && alias make="bear -- make -j8"

# ctf
alias disas="objdump -drwC -Mintel"
