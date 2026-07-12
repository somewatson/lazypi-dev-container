export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Prepend custom prompt prefix from environment variable
PROMPT="${CONTAINER_PROMPT:-[lazypi-docker]} ${PROMPT}"
