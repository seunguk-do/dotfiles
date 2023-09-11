# Installation

## ZSH
```
sudo apt-get install -y ZSH
```

## Oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Neovim
```
sudo apt-get install fuse libfuse2 # to install appimage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod a+x nvim.appimage
mv nvim.appimage /usr/local/bin/nvim
```
