#!/bin/bash

DOTFILES_DIR="$HOME/Repos/dotfiles"
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
  "zshrc:$HOME/.zshrc"
  "bash_profile:$HOME/.bash_profile"
)

create_symlinks "${common_items[@]}"

# brew packages
mkdir $HOME/.homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew

brew_packages=(
  fd
  ripgrep
  lazygit
  fzf
  direnv
  starship
  neovim
  tmux
)

# Iterate over the array and install each package
for package in "${brew_packages[@]}"; do
  echo "Installing $package..."
  $HOME/.homebrew/bin/brew install "$package"
done

if [[ "$OSTYPE" == linux-gnu ]]; then
  # apt packages
  sudo apt update
  sudo apt install \
    zsh \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3

elif [[ "$OSTYPE" == linux-gnu ]]; then
  $HOME/.homebrew/bin/brew install python
  $HOME/.homebrew/bin/brew install --cask wezterm

  common_items=(
    "wezterm.lua:$HOME/.wezterm.lua"
  )
  create_symlinks "${common_items[@]}"
fi

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
