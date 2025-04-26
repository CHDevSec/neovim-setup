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

install_avante_integration() {
    read -rp "${CYE}Deseja instalar suporte à IA (Avante)? (s/n): ${CNC}" INSTALL_AVANTE
    if [[ "${INSTALL_AVANTE,,}" == "s" ]]; then
        echo -e "${CYE}Integrando Avante ao Neovim com OpenAI GPT-4o...${CNC}"
        mkdir -p ~/.config/nvim/lua/plugins
        cat <<EOF > ~/.config/nvim/lua/plugins/avante.lua
return {
  {
    "yetone/avante.nvim",
    config = function()
      require("avante").setup({
        provider = "openai",
        openai = {
          api_key = os.getenv("OPENAI_API_KEY"),
          model = "gpt-4o",
        }
      })
    end
  }
}
EOF
        echo -e "${CYE}Sincronizando plugins do Avante...${CNC}"
        nvim --headless -c "Lazy! sync" -c "qall"

        echo -e "${CYE}Construindo templates do Avante (AvanteBuild)...${CNC}"
        nvim --headless -c "AvanteBuild" -c "qall"

        echo -e "${CGR}Avante com GPT-4o integrado e buildado com sucesso!${CNC}"
        echo
        echo -e "${CYE}⚠️  Lembre-se de exportar sua chave da OpenAI no seu .bashrc ou terminal:${CNC}"
        echo -e "${CYE}export OPENAI_API_KEY=\"sk-xxxxx...\"${CNC}"
    else
        echo -e "${CYE}Avante não será instalado.${CNC}"
    fi
}

# Execução do script
welcome_message
confirm_installation
install_dependencies
install_neovim
clone_config
install_plugins
install_avante_integration

echo -e "${CGR}"
echo "========================================================="
echo "             🚀 Instalação Concluída! 🚀"
echo "========================================================="
echo "Neovim configurado com sucesso. Aproveite! 🚀"
echo -e "${CNC}"
