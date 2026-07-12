export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

# Persist history to a file in the workspace directory
HISTFILE=/home/dev/workspace/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY

source $ZSH/oh-my-zsh.sh

# Prepend custom prompt prefix from environment variable
PROMPT="${CONTAINER_PROMPT:-[lazypi-docker]} ${PROMPT}"
