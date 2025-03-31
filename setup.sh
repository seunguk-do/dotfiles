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
  gh
)

# Iterate over the array and install each package
for package in "${brew_packages[@]}"; do
  echo "Installing $package..."
  $HOME/.homebrew/bin/brew install "$package"
done

case "$OSTYPE" in
"linux-gnu"*)
  # apt packages
  sudo apt update
  sudo apt install \
    zsh \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3

  if [ ! -d "$HOME/.zsh/pure" ]; then
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
  else
    echo "Pure prompt is already installed in $HOME/.zsh/pure"
  fi
  ;;

"darwin"*)
  $HOME/.homebrew/bin/brew install --cask wezterm
  $HOME/.homebrew/bin/brew install coreutils pure

  common_items=(
    "wezterm.lua:$HOME/.wezterm.lua"
  )
  create_symlinks "${common_items[@]}"
  ;;

*)
  echo "Unknown OS!" >&2
  exit 1
  ;;
esac

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
