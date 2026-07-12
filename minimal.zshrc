export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

# Prepend (docker) to the prompt to indicate container environment
PROMPT='(docker) '"$PROMPT'

source $ZSH/oh-my-zsh.sh
