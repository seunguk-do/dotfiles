#!/bin/bash

# Installation
## oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH_CUSTOM=${HOME}/.oh-my-zsh/custom

## zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

## zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

## theme: spaceship-prompt
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"

# Config files

DIRS="nvim"

## backup
BD=${HOME}/old-dotfiles
if [ ! -d "$BD" ]; then
	mkdir $BD
fi

mv ~/.tmux* $BD
mv ~/.zshrc $BD

for i in ${DIRS}; do
	echo "install $i"
	stow $i
done

ln -s .tmux.conf $HOME/.tmux.conf
ln -s .zshrc $HOME/.zshrc
ln -s nvim $HOME/.config/nvim
