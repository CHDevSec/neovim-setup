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

# Exibir arte ASCII de boas-vindas
welcome_message() {
    echo -e "${CGR}"
    echo " __   __  _______   ______   ____    ____  __  .___  ___. "
    echo "|  \ |  | |   ____| /  __  \  \   \  /   / |  | |   \/   | "
    echo "|   \|  | |  |__   |  |  |  |  \   \/   /  |  | |  \  /  | "
    echo "|  . `  | |   __|  |  |  |  |   \      /   |  | |  |\/|  | "
    echo "|  |\   | |  |____ |  `--'  |    \    /    |  | |  |  |  | "
    echo "|__| \__| |_______| \______/      \__/     |__| |__|  |__| "
    echo "========================================================="
    echo "  🚀 Bem-vindo ao Setup do Neovim!  "
    echo "========================================================="
    echo -e "${CNC}"
}

# Ask for confirmation before installing
confirm_installation() {
    read -p "Do you want to install Neovim and the custom configurations? (Y/n): " choice
    case "$choice" in
        [Nn]* ) 
            echo -e "${CRE}Installation canceled.${CNC}"
            exit 0
            ;;
        * ) 
            echo -e "${CGR}Starting installation...${CNC}"
            ;;
    esac
}

# Install Neovim and required dependencies
install_neovim() {
    echo -e "${CYE}Installing Neovim and dependencies...${CNC}"
    
    sudo apt update -y
    sudo apt install -y neovim git curl ripgrep fd-find unzip

    if ! command -v nvim &> /dev/null; then
        log_error "Failed to install Neovim!"
        exit 1
    fi

    echo -e "${CGR}Neovim successfully installed!${CNC}"
}

# Install Nerd Fonts
install_nerd_fonts() {
    echo -e "${CYE}Installing Nerd Fonts...${CNC}"
    mkdir -p "$HOME/.local/share/fonts"
    wget -q --show-progress -P "$HOME/.local/share/fonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o "$HOME/.local/share/fonts/JetBrainsMono.zip" -d "$HOME/.local/share/fonts/"
    fc-cache -fv
    echo -e "${CGR}Nerd Font installed successfully!${CNC}"
}

# Configure terminal fonts
configure_terminal_fonts() {
    echo -e "${CYE}Configuring terminal fonts...${CNC}"
    mkdir -p "$HOME/.config/kitty" "$HOME/.config/alacritty"
    echo "font_family JetBrainsMono Nerd Font" > "$HOME/.config/kitty/kitty.conf"
    echo -e "[font]\nnormal = { family = \"JetBrainsMono Nerd Font\" }" > "$HOME/.config/alacritty/alacritty.yml"
}

# Backup existing Neovim configuration
backup_existing_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo -e "${CYE}Backing up existing Neovim configuration...${CNC}"
        mv "$HOME/.config/nvim" "$backup_folder-$(date +%Y%m%d-%H%M%S)"
        echo -e "${CGR}Backup saved to $backup_folder${CNC}"
    fi
}

# Clone the custom Neovim configuration
clone_neovim_config() {
    echo -e "${CYE}Downloading Neovim configuration from repository...${CNC}"
    git clone --depth=1 "$repo_url" "$temp_dir" || {
        log_error "Failed to clone repository files!"
        exit 1
    }
    if [ -d "$temp_dir" ]; then
        mv "$temp_dir" "$HOME/.config/nvim"
        echo -e "${CGR}Neovim configuration applied successfully!${CNC}"
    else
        log_error "Neovim configuration folder not found in the repository!"
        exit 1
    fi
    rm -rf "$temp_dir"
}

# Install Neovim plugins
install_neovim_plugins() {
    echo -e "${CYE}Installing Neovim plugins...${CNC}"
    if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        log_error "Neovim configuration file not found!"
        exit 1
    fi
    nvim --headless +PackerSync +qall
    echo -e "${CGR}Neovim plugins successfully installed!${CNC}"
}

# Run the script
welcome_message
confirm_installation
install_neovim
install_nerd_fonts
configure_terminal_fonts
backup_existing_config
clone_neovim_config
install_neovim_plugins

echo -e "${CGR}Neovim setup completed successfully!${CNC}"
