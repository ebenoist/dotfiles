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

source ~/.exports;

#AWSume alias to source the AWSume script
alias awsume=". \$(pyenv which awsume)"

#Auto-Complete function for AWSume

_awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(awsumepy --rolesusers)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _awsume awsume

