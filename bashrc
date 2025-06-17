# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

source ~/.colors;
source ~/.aliases;
source ~/.exports;

## language ENV
export PATH="$HOME/.pyenv/bin:$HOME/.rbenv/bin:$HOME/.nodenv/bin:$PATH"
eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init -)"
. "$HOME/.cargo/env"

## gpg
export GPG_TTY=$(tty)

## completions
[[ -r "/usr/share/bash-completion/completions/git" ]] && . "/usr/share/bash-completion/completions/git"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

## db history stores all of my bash history in a sqlite database
export HISTSIZE=$HOME/.bash_history
export HISTFILESIZE=1000
export HISTSIZE=1000
export HISTTIMEFORMAT="%s "
export HISTCONTROL=ignorespace:erasedups
export DBHISTORY=true
export DBHISTORYFILE=$HOME/.dbhist.sql
source ~/.dbhist.sh;

export FLYCTL_INSTALL="/home/erik/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

## local install paths
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
export DISPLAY=${DISPLAY:-:0}
