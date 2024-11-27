#!/bin/bash

function print_message {
    echo -e "\n==============================="
    echo "$1"
    echo "===============================\n"
}

print_message "Atualizando sistema e instalando pacotes básicos"
sudo apt update && sudo apt upgrade -y
sudo apt install -y nano curl git vim zsh snapd

print_message "Habilitando o Snap"
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

print_message "Instalando VSCode"
sudo snap install code --classic

print_message "Instalando Zsh"
sudo apt install -y zsh

print_message "Instalando Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_message "Instalando plugins do Zsh"
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

print_message "Instalando tema Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

print_message "Configurando tema e plugins no .zshrc"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

print_message "Configurando Git"
git config --global user.email "mateusantonioofc@gmail.com"
git config --global user.name "Mateus"

print_message "Finalizando configuração"
source ~/.zshrc

print_message "Configuração concluída! Reinicie o terminal ou execute 'zsh' para ativar as mudanças."
