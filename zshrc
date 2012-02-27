export ZSH=$HOME/.zsh

export ZSH_THEME="muse"

plugins=(git vi-mode ruby github gem osx \
         cake cloudapp npm lol)

source $ZSH/zsh.sh

set TERM=xterm-256color

# Expand !
setopt no_hist_verify

# rbenv
# export PATH="/usr/local/lib/rbenv/bin:$PATH"
# export PATH="$HOME/.rbenv/shims:$PATH"
# eval "$(rbenv init -)"

# homebrew
export PATH="/usr/local/bin:$PATH"

#pre-rv
unsetopt auto_name_dirs

#z 
. "$HOME/dev/dotfiles/z/z.sh"
function precmd () {
    z --add "$(pwd -P)"
}

#find
function ffind() {
    find . -type f -iname "*${1}*";
}

#kill
function kkill() {
    kill %${1}; fg %${1};
}

#pbcat
function pbcat() {
    cat ${1} | pbcopy
}

#2nd to last argument
alias -g n-2=${${:-$history[$((HISTCMD-1))]}[(w)-2,(w)-2]}
