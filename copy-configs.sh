#!/bin/bash

cp -f .vimrc $HOME/.vimrc 2>/dev/null
cp -f .zshrc $HOME/.zshrc 2>/dev/null
cp -f .p10k.zsh $HOME/.p10k.zsh 2>/dev/null

mkdir -p $HOME/.config && cp -f starship.toml $HOME/.config/starship.toml 2>/dev/null
cp -f .dircolors $HOME/.dircolors 2>/dev/null

# Nvim configuration
mkdir -p $HOME/.config/nvim && cp -f init.vim $HOME/.config/nvim/init.vim 2>/dev/null
