## Setup on a new machine

git clone --bare # git@github.com:maximk27/dotfiles.git
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot checkout   
