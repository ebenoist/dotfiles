source ~/.colors;
source ~/.aliases;

export PATH="$HOME/.pyenv/bin:$HOME/.rbenv/bin:$HOME/.nodenv/bin:$PATH"

eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init -)"

#bind 'set completion-ignore-case on'
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [ -x "$(command -v brew)" ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
  fi

  if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
  fi

  if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
  . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
source <(kitty + complete setup bash)

source ~/.exports;
export HISTSIZE=$HOME/.bash_history
export HISTFILESIZE=1000
export HISTSIZE=1000
export HISTTIMEFORMAT="%s "
export HISTCONTROL=ignorespace:erasedups
export DBHISTORY=true
export DBHISTORYFILE=$HOME/.dbhist.sql

export FLYCTL_INSTALL="/home/erik/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

source ~/.dbhist.sh;
