#!/usr/bin/env bash

# Neovim Installer - Configuração do Neovim por Caio Henrique

# Configuração de cores para logs
CRE=$(tput setaf 1)  # Vermelho
CYE=$(tput setaf 3)  # Amarelo
CGR=$(tput setaf 2)  # Verde
CNC=$(tput sgr0)     # Resetar cores

# Caminhos importantes
backup_folder="$HOME/.config/nvim_backup"
ERROR_LOG="$HOME/NeovimInstall.log"
repo_url="https://github.com/Posedequebradaaa/neovim-setup.git"
temp_dir="$HOME/dotfiles_temp"

# Função para log de erros
log_error() {
    echo "[ERROR] $1" | tee -a "$ERROR_LOG"
}

# Exibir mensagem de boas-vindas
welcome_message() {
    echo -e "${CGR}"
    echo "======================================"
    echo "  🚀 Bem-vindo ao Setup do Neovim!  "
    echo "======================================"
    echo -e "${CNC}"
}

# Perguntar se deseja instalar
confirm_installation() {
    read -p "Deseja instalar o Neovim e as configurações personalizadas? (Y/n): " choice
    case "$choice" in
        [Nn]* ) 
            echo -e "${CRE}Instalação cancelada.${CNC}"
            exit 0
            ;;
        * ) 
            echo -e "${CGR}Iniciando instalação...${CNC}"
            ;;
    esac
}

# Instalar Neovim e dependências necessárias
install_neovim() {
    echo -e "${CYE}Instalando Neovim e dependências...${CNC}"
    
    sudo apt update -y
    sudo apt install -y neovim git curl ripgrep fd-find

    if ! command -v nvim &> /dev/null; then
        log_error "Falha ao instalar o Neovim!"
        exit 1
    fi

    echo -e "${CGR}Neovim instalado com sucesso!${CNC}"
}

# Backup de configuração existente
backup_existing_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo -e "${CYE}Realizando backup da configuração atual...${CNC}"
        mv "$HOME/.config/nvim" "$backup_folder-$(date +%Y%m%d-%H%M%S)"
        echo -e "${CGR}Backup salvo em $backup_folder${CNC}"
    fi
}

# Clonar a configuração personalizada do Neovim
clone_neovim_config() {
    echo -e "${CYE}Baixando configuração do Neovim do repositório...${CNC}"

    git clone --depth=1 "$repo_url" "$temp_dir" || {
        log_error "Falha ao clonar os arquivos do repositório!"
        exit 1
    }

    if [ -d "$temp_dir" ]; then
        mv "$temp_dir" "$HOME/.config/nvim"
        echo -e "${CGR}Configuração do Neovim aplicada com sucesso!${CNC}"
    else
        log_error "A pasta de configuração do Neovim não foi encontrada no repositório!"
        exit 1
    fi

    # Limpar arquivos temporários
    rm -rf "$temp_dir"
}

# Instalar Plug-ins do Neovim
install_neovim_plugins() {
    echo -e "${CYE}Instalando plug-ins do Neovim...${CNC}"

    if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        log_error "Arquivo de configuração do Neovim não encontrado!"
        exit 1
    fi

    nvim --headless +PackerSync +qall
    echo -e "${CGR}Plug-ins instalados com sucesso!${CNC}"
}

# Execução do script
welcome_message
confirm_installation
install_neovim
backup_existing_config
clone_neovim_config
install_neovim_plugins

echo -e "${CGR}Configuração do Neovim concluída com sucesso!${CNC}"
