DISABLE_AUTO_UPDATE="true"
zmodload zsh/zprof

export ZSH="$HOME/.oh-my-zsh" ZSH_THEME="geoffgarside"
plugins=(zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
PATH="$PATH:/opt/nvim-linux-x86_64/bin"
PATH="$PATH:/home/maximk/.cargo/bin"
PATH="$PATH:/usr/local/go/bin:/home/maximk/go/bin"

# run arbitrary single file code
source ~/scripts/runner.sh

# access tempates
source ~/templates/script.bash

eval "$(zoxide init --cmd cd zsh)"

# all most convenience alias
source ~/scripts/aliases.sh

# zsh binds
bindkey "^k" autosuggest-accept

# variables below
export EDITOR=nvim
export CMAKE_GENERATOR=Ninja

# required vim
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

fpath+=${ZDOTDIR:-~}/.zsh_functions
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# required pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# TODO: make system job to git pull from these repos to update?

# tools from special binaries
PATH="$PATH:$HOME/tools/FlameGraph"
PATH="$PATH:$HOME/tools/john/run"
PATH="$PATH:$HOME/tools/ghidra"
PATH="$PATH:$HOME/tools/binaryninja"

alias john="$HOME/tools/john/run/john"
alias matlab="$HOME/matlab/bin/matlab"
# zprof
