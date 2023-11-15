# Determine the type of OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}";;
esac

# Export path to the homebrew if the OS is Mac
if [ $machine = "Mac" ]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="spaceship"

# Specify the plugins to use
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
## Set language environment
export LANG=en_US.UTF-8

# Aliases
if [ $machine = "Mac" ]; then
    alias vim="nvim"
else
    alias vim="nvim --appimage-extract-and-run"
    alias tmux="tmux -2"
fi
