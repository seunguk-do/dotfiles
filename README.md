# Installation

## ZSH
```
# Ubuntu
sudo apt-get install -y zsh
```

## Oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Theme: Spaceship Prompt
```
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```

### Plugin: zsh-autosuggestions
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Plugin: zsh-syntax-highlighting
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Neovim
```
# Ubuntu
sudo apt-get install fuse libfuse2 # to install appimage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod a+x nvim.appimage
mv nvim.appimage /usr/local/bin/nvim

# MacOS
brew isntall neovim
```
