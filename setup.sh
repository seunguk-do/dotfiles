#!/bin/bash

DOTFILES_DIR="$HOME/Repos/github.com/seunguk-do/dotfiles"
XDG_CONFIG_HOME="$HOME/.config"

create_symlinks() {
  local items=("$@")
  for item in "${items[@]}"; do
    IFS=':' read -r source target <<<"$item"
    if [ -L "$target" ]; then
      echo "Removing existing symlink $target"
      unlink "$target"
    elif [ -d "$target" ]; then
      echo "Warning: $target is a directory. Skipping..."
      continue
    elif [ -e "$target" ]; then
      echo "Warning: $target already exists. Skipping..."
      continue
    fi
    ln -s "$DOTFILES_DIR/$source" "$target"
    echo "Created symlink for $source"
  done
}

common_items=(
  "tmux.conf:$HOME/.tmux.conf"
  "nvim:$XDG_CONFIG_HOME/nvim"
  "zprofile:$HOME/.zprofile"
  "zshrc:$HOME/.zshrc"
  "bash_profile:$HOME/.bash_profile"
)

create_symlinks "${common_items[@]}"

# MacOS specific setup
if [[ "$OSTYPE" == darwin* ]]; then
  macos_directories=(
    "$HOME/.qutebrowser"
  )
  macos_items=(
    "qutebrowser/config.py:$HOME/.qutebrowser/config.py"
  )
  create_directories "${macos_directories[@]}"
  create_symlinks "${macos_items[@]}"
fi

# # Packages
#
# # install brew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#
# # ubuntu apt packages
# sudo apt update && sudo apt install ripgrep gcc g++ unzip fd direnv starship
#
# # ubuntu brew packages
# brew install neovim lazygit fzf
#
# # devpod
# curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-darwin-arm64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
#
# # set up prompt
# mkdir -p "$HOME/.zsh"
# git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
