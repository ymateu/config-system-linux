#!/bin/bash

# Atualizar e instalar pacotes básicos
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim curl git gcc g++ clang clang-format python3-pip build-essential

# Instalar gerenciador de plugins Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Instalar FZF (fuzzy finder)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Instalar clangd (para C/C++ LSP)
sudo apt install -y clangd

# Configurar o Coc.nvim (extensão para C/C++)
vim -c 'PlugInstall | q | q'
vim -c 'CocInstall coc-clangd | q | q'
