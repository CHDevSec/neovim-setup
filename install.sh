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
    clear
    echo -e "${CGR}"
    echo "========================================================="
    echo "  🚀 Bem-vindo ao Setup!  "
    echo "========================================================="
    echo -e "${CNC}"
}

# Ask for confirmation before installing
confirm_installation() {
    read -p "Do you want to install and configure everything? (Y/n): " choice
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
    echo -e "${CYE}Installing dependencies...${CNC}"
    
    sudo apt update -y
    sudo apt install -y neovim git curl ripgrep fd-find unzip

    if ! command -v nvim &> /dev/null; then
        log_error "Failed to install Neovim!"
        exit 1
    fi

    echo -e "${CGR}Dependencies installed successfully!${CNC}"
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

# Backup existing configuration
backup_existing_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo -e "${CYE}Backing up existing configuration...${CNC}"
        mv "$HOME/.config/nvim" "$backup_folder-$(date +%Y%m%d-%H%M%S)"
        echo -e "${CGR}Backup saved to $backup_folder${CNC}"
    fi
}

# Clone the custom configuration
clone_neovim_config() {
    echo -e "${CYE}Downloading configuration from repository...${CNC}"
    git clone --depth=1 "$repo_url" "$temp_dir" || {
        log_error "Failed to clone repository files!"
        exit 1
    }
    if [ -d "$temp_dir" ]; then
        mv "$temp_dir" "$HOME/.config/nvim"
        echo -e "${CGR}Configuration applied successfully!${CNC}"
    else
        log_error "Configuration folder not found in the repository!"
        exit 1
    fi
    rm -rf "$temp_dir"
}

# Install plugins and run Lazy sync
install_neovim_plugins() {
    echo -e "${CYE}Installing plugins...${CNC}"
    if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        log_error "Configuration file not found!"
        exit 1
    fi
    nvim --headless +PackerSync +qall
    nvim --headless -c "Lazy sync" -c "qall"
    echo -e "${CGR}Plugins successfully installed and synced!${CNC}"
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

echo -e "${CGR}Setup completed successfully!${CNC}"
