source ~/.colors;
source ~/.aliases;

eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init -)"
bind 'set completion-ignore-case on'

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# `brew install bash-completion`
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
  . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source <(kitty + complete setup bash)

source ~/.exports;

