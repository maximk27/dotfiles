# new stuff
alias jk="openclaude"

# sl stuff
alias hg="sl"
alias hgs="sl status -L 5"
alias hgh="sl hisotry"

# git stuff
alias gaa="git add -A"
alias gap="git add -p"
alias gsw="git switch"
alias gc="git commit --verbose"
alias gca="git commit --amend"
alias gp="git push"
alias gpu="git push -u origin main"
alias gl="git pull"
alias gck="git checkout"
alias gst="git status"
alias gr="git remote"
alias gd="git diff"
alias gb="git branch"
alias gsh="git show"
alias grh="git reset"
alias grhh="git reset --hard"
alias grs="git restore --staged"
alias gsta="git stash save"
alias gstp="git stash pop"
alias gf="git fetch"
alias gm="git merge"
alias grb="git rebase"
alias gcp="git cherry-pick"
alias gai="git add -i"
alias gr="git remote"
alias glgg="git log --graph"
alias glg="git log -n5"
alias gw="git worktree"
alias gar="git archive HEAD --output=out.tar"

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
