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
repo_url="https://github.com/Posedequebradaaa/neovim-setup.git"
temp_dir="$HOME/dotfiles_temp"

# Function for error logging
log_error() {
    echo "[ERROR] $1" | tee -a "$ERROR_LOG"
}

# Display ASCII art welcome message
welcome_message() {
    echo -e "${CGR}"
    echo " $$\   $$\                               $$\               "
    echo " $$$\  $$ |                              \__|              "
    echo " $$$$\ $$ | $$$$$$\   $$$$$$\ $$\    $$\ $$\ $$$$$$\$$$$\  "
    echo " $$ $$\$$ |$$  __$$\ $$  __$$\\$$\  $$  |$$ |$$  _$$  _$$\ "
    echo " $$ \$$$$ |$$$$$$$$ |$$ /  $$ |\$$\$$  / $$ |$$ / $$ / $$ |"
    echo " $$ |\$$$ |$$   ____|$$ |  $$ | \$$$  /  $$ |$$ | $$ | $$ |"
    echo " $$ | \$$ |\$$$$$$$\ \$$$$$$  |  \$  /   $$ |$$ | $$ | $$ |"
    echo " \__|  \__| \_______| \______/    \_/    \__|\__| \__| \__|"
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
    sudo apt install -y neovim git curl ripgrep fd-find

    if ! command -v nvim &> /dev/null; then
        log_error "Failed to install Neovim!"
        exit 1
    fi

    echo -e "${CGR}Neovim successfully installed!${CNC}"
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

    # Clean temporary files
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
backup_existing_config
clone_neovim_config
install_neovim_plugins

echo -e "${CGR}Neovim setup completed successfully!${CNC}"
