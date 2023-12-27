#!/bin/bash

if [ ! -d $HOME/.config/nvim ]; then
	ln -s nvim $HOME/.config/nvim
fi

if [ ! -d $HOME/.tmux.conf ]; then
	ln -s nvim $HOME/.tmux.conf
fi

if [ ! -d $HOME/.zshrc ]; then
	# oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	export ZSH_CUSTOM=${HOME}/.oh-my-zsh/custom

	# zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

	# zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

	# theme: spaceship-prompt
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"

	ln -s nvim $HOME/.zshrc
fi
