export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="geoffgarside"
plugins=(zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
PATH="$PATH:/opt/nvim-linux-x86_64/bin"
PATH="$PATH:$HOME/myscripts"
PATH="$PATH:/home/maximk/.cargo/bin"
PATH="$PATH:$HOME/tools"

# add go binaries
PATH="$PATH:/usr/local/go/bin:/home/maximk/go/bin"

# add john tools
PATH="$PATH:/home/maximk/builds/john/run"

# run arbitrary single file code
function run() {
    local filename=$1
    local name="${filename%%.*}"
    local ext="${filename##*.}"

    if [[ $ext == "cpp" ]]; then
        g++ -std=c++23 -g -Wall -o $name.out $filename && ./$name.out
    elif [[ $ext == "c" ]]; then
        gcc -std=c23 -g -Wall -o $name.out $filename && ./$name.out
    elif [[ $ext == "rs" ]]; then
        rustc -o $name.out $filename && ./$name.out
    fi
}

# other remapping
alias dot="git --git-dir=$HOME/.dotfiles --work-tree=$HOME/"
alias pbcopy="xclip -sel clip"
alias df="duf"
alias ls="eza --icons"
alias open="xdg-open"
tree() {
    local depth=${1:-1}
    eza --icons -TL "$depth"
}
eval "$(zoxide init --cmd cd zsh)"
alias nb="ninja"
alias e="nvim ."

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

# github
alias ghr="gh repo view --web"
alias ghl="gh pr list --web"

# cpp
alias cmakel="cmake -B build"
alias nbl="ninja -C build"
alias makel="make -C build"
alias tl="ctest --test-dir build"
alias make="make -j8"

# python
alias py="python"

# rust
alias c="cargo"

bindkey "^[[Z" autosuggest-accept

# hacks
alias john="~/builds/john/run/john"
function cont() {
    touch z_expected.txt
    cp ~/cpp/template/Makefile .
}

alias diff="diff -yb"

# variables below
export EDITOR=nvim
export CMAKE_GENERATOR=Ninja

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

fpath+=${ZDOTDIR:-~}/.zsh_functions
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# PATH=$PATH:/home/maximk/builds/john/
