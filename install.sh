#!/usr/bin/env bash

# Neovim Installer - Neovim Configuration by Caio Henrique

# Color configuration for logs
CRE=$(tput setaf 1)  # Red
CYE=$(tput setaf 3)  # Yellow
CGR=$(tput setaf 2)  # Green
CNC=$(tput sgr0)     # Reset colors

# Important paths
backup_folder="$HOME/.config/nvim_backup"
ERROR_LOG="$HOME/NeovimInstall.log"
repo_url="https://github.com/CHDevSec/neovim-setup.git"
temp_dir="$HOME/dotfiles_temp"

# Function for error logging
log_error() {
    echo "[ERROR] $1" | tee -a "$ERROR_LOG"
}

# Welcome message
welcome_message() {
    clear
    echo -e "${CGR}"
    echo "========================================================="
    echo "        🚀 Bem-vindo ao Setup do Neovim!        "
    echo "========================================================="
    echo -e "${CNC}"
}

# Confirm installation
confirm_installation() {
    read -p "Deseja instalar e configurar o Neovim? (s/n): " choice
    case "$choice" in
        [Nn]* )
            echo -e "${CRE}Instalação cancelada.${CNC}"
            exit 0
            ;;
        * )
            echo -e "${CGR}Iniciando a instalação...${CNC}"
            ;;
    esac
}

# Install Neovim and required dependencies
install_neovim() {
    echo -e "${CYE}Instalando dependências...${CNC}"
    
    sudo apt update -y
    sudo apt install -y neovim git curl ripgrep fd-find unzip nodejs npm python3 python3-pip

    if ! command -v nvim &> /dev/null; then
        log_error "Falha ao instalar o Neovim!"
        exit 1
    fi

    echo -e "${CGR}Dependências instaladas com sucesso!${CNC}"
}

# Install Nerd Fonts
install_nerd_fonts() {
    echo -e "${CYE}Instalando Nerd Fonts...${CNC}"
    mkdir -p "$HOME/.local/share/fonts"
    wget -q --show-progress -P "$HOME/.local/share/fonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o "$HOME/.local/share/fonts/JetBrainsMono.zip" -d "$HOME/.local/share/fonts/"
    fc-cache -fv
    echo -e "${CGR}Fonte Nerd instalada com sucesso!${CNC}"
}

# Configure terminal fonts
configure_terminal_fonts() {
    echo -e "${CYE}Configurando fontes no terminal...${CNC}"
    mkdir -p "$HOME/.config/kitty" "$HOME/.config/alacritty"
    echo "font_family JetBrainsMono Nerd Font" > "$HOME/.config/kitty/kitty.conf"
    echo -e "[font]\nnormal = { family = \"JetBrainsMono Nerd Font\" }" > "$HOME/.config/alacritty/alacritty.yml"
}

# Backup existing configuration
backup_existing_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo -e "${CYE}Fazendo backup da configuração existente...${CNC}"
        mv "$HOME/.config/nvim" "$backup_folder-$(date +%Y%m%d-%H%M%S)"
        echo -e "${CGR}Backup salvo em $backup_folder${CNC}"
    fi
}

# Clone the custom configuration
clone_neovim_config() {
    echo -e "${CYE}Baixando configuração personalizada...${CNC}"
    git clone --depth=1 "$repo_url" "$temp_dir" || {
        log_error "Falha ao clonar o repositório!"
        exit 1
    }
    if [ -d "$temp_dir" ]; then
        mv "$temp_dir" "$HOME/.config/nvim"
        echo -e "${CGR}Configuração aplicada com sucesso!${CNC}"
    else
        log_error "Pasta de configuração não encontrada no repositório!"
        exit 1
    fi
    rm -rf "$temp_dir"
}

# Install plugins and run Lazy sync
install_neovim_plugins() {
    echo -e "${CYE}Instalando plugins...${CNC}"
    if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        log_error "Arquivo de configuração init.lua não encontrado!"
        exit 1
    fi
    nvim --headless -c "Lazy sync" -c "qall"
    echo -e "${CGR}Plugins instalados e sincronizados com sucesso!${CNC}"
}

# Ask to install Avante (AI integration)
install_avante_integration() {
    read -p "Deseja instalar o suporte à IA (Avante)? (s/n): " INSTALL_AVANTE

    if [[ "$INSTALL_AVANTE" == "s" || "$INSTALL_AVANTE" == "S" ]]; then
        echo -e "${CYE}Integrando Avante ao Neovim...${CNC}"

        # Cria o arquivo lua/plugins/avante.lua
        mkdir -p "$HOME/.config/nvim/lua/plugins"
        cat <<EOF > "$HOME/.config/nvim/lua/plugins/avante.lua"
return {
  { "AvanteAI/avante.nvim" }
}
EOF

        echo -e "${CGR}Avante integrado ao Neovim!${CNC}"

        # Rodar Lazy sync novamente para instalar o Avante
        nvim --headless -c "Lazy sync" -c "qall"
    else
        echo -e "${CYE}Avante não será instalado.${CNC}"
    fi
}

# Main Script Execution
welcome_message
confirm_installation
install_neovim
install_nerd_fonts
configure_terminal_fonts
backup_existing_config
clone_neovim_config
install_neovim_plugins
install_avante_integration

echo -e "${CGR}Setup completo! Agora é só aproveitar seu Neovim configurado. 🚀${CNC}"
