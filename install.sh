#!/usr/bin/env bash

# Cores para logs
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CNC=$(tput sgr0)

welcome_message() {
    clear
    echo -e "${CGR}"
    echo "========================================================="
    echo "             🚀 Bem-vindo $USER! 🚀"
    echo "========================================================="
    echo -e "${CNC}"
    echo "Este script irá configurar seu Neovim completo!"
    echo
}

confirm_installation() {
    read -rp "Deseja continuar com a instalação do Neovim? (s/n): " choice
    if [[ ${choice,,} != "s" ]]; then
        echo -e "${CRE}Instalação cancelada.${CNC}"
        exit 1
    fi
}

install_dependencies() {
    echo -e "${CYE}Instalando dependências...${CNC}"
    sudo apt update -y
    sudo apt install -y curl git unzip ripgrep fd-find python3-pip nodejs npm
    echo -e "${CGR}Dependências instaladas com sucesso!${CNC}"
}

install_neovim() {
    echo -e "${CYE}Instalando Neovim atualizado...${CNC}"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
    echo -e "${CGR}Neovim instalado com sucesso!${CNC}"
}

clone_config() {
    echo -e "${CYE}Clonando configuração personalizada...${CNC}"
    git clone https://github.com/CHDevSec/neovim-setup.git ~/nvim_temp
    rm -rf ~/.config/nvim
    mv ~/nvim_temp ~/.config/nvim
    echo -e "${CGR}Configuração aplicada com sucesso!${CNC}"
}

install_plugins() {
    echo -e "${CYE}Instalando plugins...${CNC}"
    nvim --headless -c "Lazy! sync" -c "qall"
    echo -e "${CGR}Plugins sincronizados com sucesso!${CNC}"
}

# Execução do script
welcome_message
confirm_installation
install_dependencies
install_neovim
clone_config
install_plugins

echo -e "${CGR}"
echo "========================================================="
echo "             🚀 Instalação Concluída! 🚀"
echo "========================================================="
echo "Neovim configurado com sucesso. Aproveite! 🚀"
echo -e "${CNC}"
