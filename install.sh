#!/usr/bin/env bash

# Neovim Installer - Setup by Caio Henrique (baseado no Ghosts)

# Color configuration for logs
CRE=$(tput setaf 1)    # Red
CYE=$(tput setaf 3)    # Yellow
CGR=$(tput setaf 2)    # Green
CBL=$(tput setaf 4)    # Blue
CNC=$(tput sgr0)       # Reset colors

# Important paths
BACKUP_FOLDER="$HOME/.config/nvim_backup"
ERROR_LOG="$HOME/NeovimInstall.log"
REPO_URL="https://github.com/CHDevSec/neovim-setup.git"
TEMP_DIR="$HOME/nvim_temp"

# Função de log de erro
log_error() {
    local error_msg="$1"
    echo "[ERROR] $error_msg" | tee -a "$ERROR_LOG"
}

# Logo bonito
logo() {
    local text="${1:-Neovim Setup}"
    echo -e "\n${CGR}=========================================================${CNC}"
    echo -e "${CYE}             🚀 $text 🚀${CNC}"
    echo -e "${CGR}=========================================================${CNC}\n"
}

# Welcome screen
welcome() {
    clear
    logo "Bem-vindo $USER!"
    echo -e "${CYE}Este script irá configurar seu Neovim completo!${CNC}"
    echo
    read -rp "${CYE}Deseja continuar? (s/n): ${CNC}" choice
    case "${choice,,}" in
        n|no) echo -e "${CRE}Instalação cancelada.${CNC}"; exit 0 ;;
        y|yes|"") ;;
        *) echo -e "${CRE}Opção inválida.${CNC}"; exit 1 ;;
    esac
}

# Instalação do Neovim atualizado e dependências
install_dependencies() {
    echo -e "${CBL}Instalando dependências...${CNC}"
    sudo apt update
    sudo apt install -y curl ripgrep fd-find unzip git nodejs npm python3 python3-pip

    # Instalar Neovim mais recente via AppImage
    if ! command -v nvim >/dev/null || [[ "$(nvim --version | head -n1 | awk '{print $2}')" < "0.8.0" ]]; then
        echo -e "${CYE}Instalando Neovim atualizado...${CNC}"
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
    fi

    echo -e "${CGR}Dependências instaladas com sucesso!${CNC}\n"
}

# Backup da configuração existente
backup_existing_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo -e "${CYE}Fazendo backup da configuração existente...${CNC}"
        mkdir -p "$BACKUP_FOLDER"
        cp -r "$HOME/.config/nvim" "$BACKUP_FOLDER/nvim_backup_$(date +%Y%m%d-%H%M%S)"
        rm -rf "$HOME/.config/nvim"
        echo -e "${CGR}Backup salvo em $BACKUP_FOLDER${CNC}\n"
    fi
}

# Clonar seu repositório
clone_neovim_config() {
    echo -e "${CYE}Clonando configuração personalizada...${CNC}"
    git clone --depth=1 "$REPO_URL" "$TEMP_DIR" || {
        log_error "Falha ao clonar repositório!"
        exit 1
    }

    mkdir -p "$HOME/.config/"
    mv "$TEMP_DIR" "$HOME/.config/nvim"
    rm -rf "$TEMP_DIR"

    echo -e "${CGR}Configuração aplicada com sucesso!${CNC}\n"
}

# Instalar plugins (Lazy sync)
install_neovim_plugins() {
    echo -e "${CYE}Instalando plugins...${CNC}"
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        nvim --headless -c "Lazy sync" -c "qall"
        echo -e "${CGR}Plugins sincronizados com sucesso!${CNC}\n"
    else
        log_error "init.lua não encontrado!"
        exit 1
    fi
}

# Instalar Avante (opcional)
install_avante_integration() {
    read -rp "${CYE}Deseja instalar suporte à IA (Avante)? (s/n): ${CNC}" INSTALL_AVANTE

    if [[ "${INSTALL_AVANTE,,}" == "s" || "${INSTALL_AVANTE,,}" == "yes" ]]; then
        echo -e "${CYE}Integrando Avante ao Neovim...${CNC}"

        mkdir -p "$HOME/.config/nvim/lua/plugins"
        cat <<EOF > "$HOME/.config/nvim/lua/plugins/avante.lua"
return {
  { "AvanteAI/avante.nvim" }
}
EOF

        nvim --headless -c "Lazy sync" -c "qall"
        echo -e "${CGR}Avante instalado e sincronizado!${CNC}\n"
    else
        echo -e "${CYE}Avante não será instalado.${CNC}\n"
    fi
}

# Execução principal
main() {
    welcome
    install_dependencies
    backup_existing_config
    clone_neovim_config
    install_neovim_plugins
    install_avante_integration

    logo "Instalação Concluída!"
    echo -e "${CGR}Neovim configurado com sucesso. Aproveite! 🚀${CNC}\n"
}

main
