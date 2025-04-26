#!/bin/bash
set -e

echo "============================"
echo "      Instalação Neovim      "
echo "============================"

# Atualiza o sistema
sudo apt update && sudo apt install -y neovim git curl ripgrep fd-find nodejs npm python3 python3-pip

# Instala o Lazy.nvim se não existir
if [ ! -d "$HOME/.local/share/nvim/site/pack/lazy/start/lazy.nvim" ]; then
    echo "Instalando Lazy.nvim..."
    git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/site/pack/lazy/start/lazy.nvim
fi

# Cria estrutura de pastas se necessário
mkdir -p ~/.config/nvim/lua

# Backup da configuração existente
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backup das configurações existentes..."
    cp -r ~/.config/nvim ~/.config/nvim.backup.$(date +%s)
fi

# Copia seu setup (assumindo que você organiza dentro da pasta ./nvim)
echo "Copiando configurações personalizadas..."
cp -r ./nvim/* ~/.config/nvim/

# Pergunta sobre instalação do Avante
read -p "Deseja instalar o suporte à IA (Avante)? (s/n): " INSTALL_AVANTE

AVANTE_INSTALLED=false

if [[ "$INSTALL_AVANTE" == "s" || "$INSTALL_AVANTE" == "S" ]]; then
    echo "Integrando o Avante no seu setup..."

    # Verifica se já existe o plugins.lua
    if [ -f "$HOME/.config/nvim/lua/plugins.lua" ]; then
        # Antes de adicionar, verifica se o Avante já não está adicionado para evitar duplicação
        if ! grep -q "AvanteAI/avante.nvim" "$HOME/.config/nvim/lua/plugins.lua"; then
            echo "{ 'AvanteAI/avante.nvim' }," >> ~/.config/nvim/lua/plugins.lua
        fi
    else
        # Cria o plugins.lua básico se não existir
        cat <<EOL > ~/.config/nvim/lua/plugins.lua
return require('lazy').setup({
    { 'AvanteAI/avante.nvim' },
})
EOL
    fi

    AVANTE_INSTALLED=true
fi

# Instala plugins automaticamente
echo "Sincronizando plugins..."
nvim --headless "+Lazy! sync" +qa

# Se o Avante foi instalado, builda o Avante
if [ "$AVANTE_INSTALLED" = true ]; then
    echo "Construindo o Avante (AvanteBuild)..."
    nvim --headless "+AvanteBuild" +qa
fi

echo "============================"
echo "  Instalação finalizada!  "
echo "  Divirta-se no Neovim!   "
echo "============================"
