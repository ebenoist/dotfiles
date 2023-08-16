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

eval $(keychain -q --eval id_rsa)
eval $(keychain -q --eval id_nilcoast)
eval $(keychain -q --eval id_songfinch)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
source <(kitty + complete setup bash)

xset s on && xset +dpms

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

complete -C /usr/bin/terraform terraform
export GPG_TTY=$(tty) # for gpg


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/erik/google-cloud-sdk/path.bash.inc' ]; then . '/home/erik/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/erik/google-cloud-sdk/completion.bash.inc' ]; then . '/home/erik/google-cloud-sdk/completion.bash.inc'; fi
