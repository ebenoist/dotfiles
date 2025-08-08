# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# macOS Homebrew path (Apple Silicon)
if [ -f '/opt/homebrew/bin/brew' ]; then 
  eval "$(/opt/homebrew/bin/brew shellenv)"
# macOS Homebrew path (Intel)
elif [ -f '/usr/local/bin/brew' ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

source ~/.colors;
source ~/.aliases;
source ~/.exports;

## language ENV
export PATH="$HOME/.pyenv/bin:$HOME/.rbenv/bin:$HOME/.nodenv/bin:$PATH"
eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init -)"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

## gpg
export GPG_TTY=$(tty)

## completions
# Linux
[[ -r "/usr/share/bash-completion/completions/git" ]] && . "/usr/share/bash-completion/completions/git"
# macOS homebrew
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

## db history stores all of my bash history in a sqlite database
export HISTSIZE=$HOME/.bash_history
export HISTFILESIZE=1000
export HISTSIZE=1000
export HISTTIMEFORMAT="%s "
export HISTCONTROL=ignorespace:erasedups
export DBHISTORY=true
export DBHISTORYFILE=$HOME/.dbhist.sql
source ~/.dbhist.sh;

# Linux-specific fly.io path
if [[ "$(uname)" == "Linux" ]]; then
  export FLYCTL_INSTALL="/home/erik/.fly"
  export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi

## local install paths
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
export DISPLAY=${DISPLAY:-:0}
export CLAUDE_CODE_ENABLE_TELEMETRY=0
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc

complete -C /usr/bin/terraform terraform

# Linux-specific Google Cloud SDK paths
if [[ "$(uname)" == "Linux" ]]; then
  if [ -f '/home/erik/google-cloud-sdk/path.bash.inc' ]; then . '/home/erik/google-cloud-sdk/path.bash.inc'; fi
  if [ -f '/home/erik/google-cloud-sdk/completion.bash.inc' ]; then . '/home/erik/google-cloud-sdk/completion.bash.inc'; fi
fi

# Check for zellij bash completion
if [ -f '~/.bash_completion/zellij' ]; then . '~/.bash_completion/zellij'; fi

# pnpm
if [[ "$(uname)" == "Darwin" ]]; then
  export PNPM_HOME="/Users/erik/Library/pnpm"
elif [[ "$(uname)" == "Linux" ]]; then
  export PNPM_HOME="/home/erik/.local/share/pnpm"
fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ensure Ghostty allows OSC52 clipboard operations
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    # Ghostty has OSC52 support enabled by default
    # Make sure our clipboard helper is in PATH
    export PATH="$HOME/bin:$PATH"
fi
