# Oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Pure theme
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# Aliases
alias vim="nvim"
