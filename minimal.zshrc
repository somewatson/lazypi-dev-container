export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Prepend [lazypi-docker] to the prompt to indicate container environment
PROMPT="[lazypi-docker] ${PROMPT}"
