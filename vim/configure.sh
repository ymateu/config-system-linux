#!/bin/bash

function print_message {
    echo -e "\n==============================="
    echo "$1"
    echo "===============================\n"
}

print_message "Instalando o gerenciador de pacotes Vim-Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

print_message "Instalando FZF"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

print_message "Instalando o Coc.nvim (extensão para LSP)"
vim -c 'PlugInstall | q | q'
vim -c 'CocInstall coc-clangd | q | q'

print_message "Instalando o clangd para C/C++"
sudo apt install -y clangd

print_message "Instalando a fonte Nerd Font Hack"
mkdir -p ~/.local/share/fonts
curl -fLo ~/.local/share/fonts/Hack-Regular.ttf https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip
cd ~/.local/share/fonts
unzip Hack.zip
fc-cache -fv

print_message "Instalação concluída! Reinicie o Vim para carregar a configuração."
