#!/bin/bash
DOTFILES_DIR="$HOME/Repos/dotfiles"
XDG_CONFIG_HOME="$HOME/.config"
BREW="$HOME/.homebrew/bin/brew"
NVM_DIR="$HOME/.nvm"

# Install OS-specific packages
if [[ "$OSTYPE" == "linux-gnu"* && ! -x "$(command -v zsh)" ]]; then
  if ! sudo -n true 2>/dev/null; then
    echo "Error: sudo privileges required to install zsh. If you don't have sudo access, please ask your administrator to install zsh." >&2
    exit 1
  fi
  sudo apt update && sudo apt install -y zsh
fi

# Install Homebrew
if [ ! -d "$HOME/.homebrew" ]; then
  mkdir -p $HOME/.homebrew
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
fi

# Install packages
packages=(fd ripgrep lazygit fzf neovim tmux gh yt-dlp zoxide pandoc python@3.12)
[[ "$OSTYPE" == "darwin"* ]] && packages+=(coreutils)

for pkg in "${packages[@]}"; do
  $BREW install "$pkg"
done

# Install cask packages on macOS
[[ "$OSTYPE" == "darwin"* ]] && $BREW install --cask ghostty mactex-no-gui 1password-cli

# Install Pure prompt
[ ! -d "$HOME/.zsh/pure" ] && {
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
}

# Install tools
curl -sfL https://direnv.net/install.sh | bash
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Create symlinks
create_symlink() {
  [ -L "$3" ] && unlink "$2"
  [ ! -e "$2" ] && ln -s "$DOTFILES_DIR/$1" "$2" && echo "Created symlink for $1"
}

create_symlink "tmux.conf" "$HOME/.tmux.conf"
create_symlink "nvim" "$XDG_CONFIG_HOME/nvim"
create_symlink "zshrc" "$HOME/.zshrc"
create_symlink "bash_profile" "$HOME/.bash_profile"
create_symlink "claude/commands" "$HOME/.claude/commands"
create_symlink "claude/settings.json" "$HOME/.claude/settings.json"
[[ "$OSTYPE" == "darwin"* ]] && create_symlink "ghostty_config" "$XDG_CONFIG_HOME/ghostty/config"

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node && nvm use node
npm install -g @anthropic-ai/claude-code
