# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~


# Set to vi editing mode

set -o vi

export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"

# Directories

export REPOS="$HOME/Repos"
export DOTFILES="$REPOS/dotfiles"
export SCRIPTS="$DOTFILES/scripts"


# ~~~~~~~~~~~~~~~ Path configuration ~~~~~~~~~~~~~~~~~~~~~~~~


setopt extended_glob null_glob

path=(
    $path                           # Keep existing PATH entries
    $HOME/.local/bin
    $SCRIPTS
)

# Remove duplicate entries and non-existent directories
typeset -U path
path=($^path(N-/))

export PATH


# ~~~~~~~~~~~~~~~ Dev Container Specifics ~~~~~~~~~~~~~~~~~~~~~~~~


if [ -d "$HOME/.homebrew" ]; then
     eval "$($HOME/.homebrew/bin/brew shellenv)"
fi


# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~


HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions


# ~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~


PURE_GIT_PULL=0
fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure


# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~


alias vim=nvim
alias python=python3
alias scripts='cd $SCRIPTS'

# Repos

alias dot='cd $REPOS/dotfiles'

# ls


if [[ "$OSTYPE" = linux-gnu ]]; then
  alias ls='ls --color=auto --group-directories-first'
  alias la='ls -lah --group-directories-first'
else
  alias ls='gls --color=auto --group-directories-first'
  alias la='gls --color=auto -lah --group-directories-first'
fi


# finds all files recursively and sorts by last modification, ignore hidden files
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'

# ~~~~~~~~~~~~~~~ Completion ~~~~~~~~~~~~~~~~~~~~~~~~


fpath+=~/.zfunc

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit -u

zstyle ':completion:*' menu select


# ~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~~~~~~~~~~~


source <(fzf --zsh)

eval "$(direnv hook zsh)"


# ~~~~~~~~~~~~~~~ Misc ~~~~~~~~~~~~~~~~~~~~~~~~



fpath+=~/.zfunc; autoload -Uz compinit; compinit

. "$HOME/.local/bin/env"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
