#!/bin/bash

cp .vimrc $HOME/.vimrc
cp .zshrc $HOME/.zshrc
cp .p10k.zsh $HOME/.p10k.zsh

mkdir -p $HOME/.config && cp starship.toml $HOME/.config/starship.toml
cp .dircolors $HOME/.dircolors

# Nvim configuration
mkdir -p $HOME/.config/nvim && cp init.vim $HOME/.config/nvim/init.vim
