#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para mostrar mensagens coloridas
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_question() {
    echo -e "${PURPLE}[PERGUNTA]${NC} $1"
}

print_header() {
    echo -e "${CYAN}$1${NC}"
}

# Função para mostrar banner inicial
show_banner() {
    echo
    print_header "╔══════════════════════════════════════════════════════════════════╗"
    print_header "║                    🚀 NEOVIM SETUP UNIVERSAL 🚀                 ║"
    print_header "║                                                                  ║"
    print_header "║  Suporte para: Ubuntu/Debian • Fedora/RHEL • Arch/Manjaro      ║"
    print_header "║  Gerenciadores: apt • dnf • yum • pacman                        ║"
    print_header "╚══════════════════════════════════════════════════════════════════╝"
    echo
}

# Função para detectar o gerenciador de pacotes automaticamente
detect_package_manager() {
    if command -v apt >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Função para perguntar qual gerenciador usar
ask_package_manager() {
    local detected=$1
    
    echo
    print_question "Qual gerenciador de pacotes você deseja usar?"
    echo
    echo "1) apt      (Ubuntu, Debian, Pop!_OS, Mint, etc.)"
    echo "2) dnf      (Fedora, CentOS Stream, etc.)"
    echo "3) yum      (RHEL, CentOS antigo, etc.)"
    echo "4) pacman   (Arch Linux, Manjaro, etc.)"
    echo
    
    if [ "$detected" != "unknown" ]; then
        print_message "✅ Detectado automaticamente: $detected"
        echo
        read -p "Pressione ENTER para usar '$detected' ou digite o número da opção desejada (1-4): " choice
        
        if [ -z "$choice" ]; then
            echo "$detected"
            return
        fi
    else
        read -p "Digite o número da opção (1-4): " choice
    fi
    
    case $choice in
        1) echo "apt" ;;
        2) echo "dnf" ;;
        3) echo "yum" ;;
        4) echo "pacman" ;;
        *) 
            print_error "Opção inválida! Usando detecção automática..."
            echo "$detected"
            ;;
    esac
}

# Função para perguntar se quer instalar o Neovim
ask_install_neovim() {
    echo
    print_question "Deseja instalar/atualizar o Neovim?"
    echo
    echo "1) Sim - Instalar Neovim (recomendado)"
    echo "2) Não - Apenas configurar (assume que Neovim já está instalado)"
    echo
    
    read -p "Digite sua escolha (1-2): " choice
    
    case $choice in
        1|"") echo "yes" ;;
        2) echo "no" ;;
        *) 
            print_warning "Opção inválida! Instalando Neovim por segurança..."
            echo "yes"
            ;;
    esac
}

# Função para instalar pacotes baseado no gerenciador
install_packages() {
    local pm=$1
    shift
    local packages="$@"
    
    case $pm in
        "apt")
            print_step "Atualizando repositórios (apt)..."
            sudo apt update
            print_step "Instalando pacotes: $packages"
            sudo apt install -y $packages
            ;;
        "dnf")
            print_step "Instalando pacotes com dnf: $packages"
            sudo dnf install -y $packages
            ;;
        "yum")
            print_step "Instalando pacotes com yum: $packages"
            sudo yum install -y $packages
            ;;
        "pacman")
            print_step "Atualizando repositórios (pacman)..."
            sudo pacman -Sy
            print_step "Instalando pacotes: $packages"
            sudo pacman -S --noconfirm $packages
            ;;
        *)
            print_error "Gerenciador de pacotes não suportado!"
            exit 1
            ;;
    esac
}

# Função para instalar Neovim baseado na distro
install_neovim() {
    local pm=$1
    
    print_step "Instalando Neovim..."
    
    case $pm in
        "apt")
            # Para Ubuntu/Debian - tentar AppImage primeiro para versão mais recente
            print_message "Tentando instalar versão mais recente via AppImage..."
            
            # Remover versão antiga se existir
            sudo apt remove -y neovim >/dev/null 2>&1
            
            # Tentar baixar e instalar AppImage
            if curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage 2>/dev/null; then
                chmod u+x nvim.appimage
                
                # Testar se o AppImage funciona
                if ./nvim.appimage --version >/dev/null 2>&1; then
                    sudo mv nvim.appimage /usr/local/bin/nvim
                    print_message "✅ Neovim AppImage instalado em /usr/local/bin/nvim"
                else
                    print_warning "AppImage não funcionou, usando apt..."
                    rm -f nvim.appimage
                    install_packages apt neovim
                fi
            else
                print_warning "Download do AppImage falhou, usando apt..."
                install_packages apt neovim
            fi
            ;;
        "dnf")
            install_packages dnf neovim python3-neovim
            ;;
        "yum")
            # Para CentOS/RHEL mais antigos, pode precisar do EPEL
            print_step "Habilitando repositório EPEL..."
            sudo yum install -y epel-release >/dev/null 2>&1
            install_packages yum neovim python3-neovim
            ;;
        "pacman")
            install_packages pacman neovim python-pynvim
            ;;
    esac
}

# Função para verificar se Neovim está instalado
check_neovim() {
    if command -v nvim >/dev/null 2>&1; then
        local version=$(nvim --version | head -1)
        print_message "✅ Neovim encontrado: $version"
        return 0
    else
        print_warning "❌ Neovim não encontrado!"
        return 1
    fi
}

# Função principal
main() {
    show_banner
    
    print_message "Bem-vindo ao instalador universal do Neovim Setup!"
    print_message "Este script vai configurar um ambiente Neovim completo para desenvolvimento."
    echo
    
    # Verificar se é root
    if [ "$EUID" -eq 0 ]; then
        print_error "❌ Por favor, não execute este script como root!"
        print_error "Use sua conta de usuário normal (o script pedirá sudo quando necessário)"
        exit 1
    fi
    
    # Detectar gerenciador de pacotes
    DETECTED_PM=$(detect_package_manager)
    
    # Perguntar qual gerenciador usar
    PACKAGE_MANAGER=$(ask_package_manager "$DETECTED_PM")
    
    if [ "$PACKAGE_MANAGER" = "unknown" ]; then
        print_error "❌ Nenhum gerenciador de pacotes válido selecionado!"
        exit 1
    fi
    
    print_message "✅ Usando gerenciador de pacotes: $PACKAGE_MANAGER"
    
    # Verificar se Neovim já está instalado
    echo
    print_step "Verificando instalação atual do Neovim..."
    
    if check_neovim; then
        INSTALL_NEOVIM=$(ask_install_neovim)
    else
        print_message "Neovim não encontrado, será instalado automaticamente."
        INSTALL_NEOVIM="yes"
    fi
    
    # Fazer backup da configuração existente se houver
    echo
    if [ -d "$HOME/.config/nvim" ]; then
        print_warning "⚠️  Configuração existente do Neovim encontrada!"
        echo
        read -p "Deseja fazer backup da configuração atual? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_step "Removendo configuração antiga..."
            rm -rf "$HOME/.config/nvim"
            print_message "✅ Configuração antiga removida!"
        else
            BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
            print_step "Fazendo backup para: $BACKUP_DIR"
            mv "$HOME/.config/nvim" "$BACKUP_DIR"
            print_message "✅ Backup realizado em: $BACKUP_DIR"
        fi
        echo
    fi
    
    # Instalar dependências básicas
    print_step "Instalando dependências básicas..."
    
    case $PACKAGE_MANAGER in
        "apt")
            install_packages apt curl wget git build-essential unzip ripgrep fd-find
            ;;
        "dnf")
            install_packages dnf curl wget git gcc gcc-c++ make unzip ripgrep fd-find
            ;;
        "yum")
            install_packages yum curl wget git gcc gcc-c++ make unzip
            # ripgrep e fd podem não estar disponíveis em repos mais antigos
            ;;
        "pacman")
            install_packages pacman curl wget git base-devel unzip ripgrep fd
            ;;
    esac
    
    # Instalar Neovim se solicitado
    if [ "$INSTALL_NEOVIM" = "yes" ]; then
        echo
        install_neovim $PACKAGE_MANAGER
        
        # Verificar se a instalação foi bem-sucedida
        echo
        if ! check_neovim; then
            print_error "❌ Falha na instalação do Neovim!"
            print_error "Por favor, instale o Neovim manualmente e execute o script novamente."
            exit 1
        fi
    fi
    
    # Instalar Node.js (necessário para alguns LSPs)
    echo
    print_step "Verificando Node.js..."
    if ! command -v node >/dev/null 2>&1; then
        print_step "Instalando Node.js..."
        case $PACKAGE_MANAGER in
            "apt")
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - >/dev/null 2>&1
                install_packages apt nodejs
                ;;
            "dnf")
                install_packages dnf nodejs npm
                ;;
            "yum")
                install_packages yum nodejs npm
                ;;
            "pacman")
                install_packages pacman nodejs npm
                ;;
        esac
    else
        print_message "✅ Node.js já está instalado: $(node --version)"
    fi
    
    # Criar diretório de configuração
    echo
    print_step "Criando estrutura de diretórios..."
    mkdir -p "$HOME/.config/nvim"
    
    # Verificar se existe pasta nvim com configurações
    if [ -d "nvim" ]; then
        print_step "Copiando arquivos de configuração..."
        cp -r nvim/* "$HOME/.config/nvim/"
        chmod -R 755 "$HOME/.config/nvim"
        print_message "✅ Configurações copiadas!"
    else
        print_warning "⚠️  Pasta 'nvim' não encontrada no diretório atual!"
        print_warning "Certifique-se de executar o script dentro do diretório do projeto."
        print_warning "Apenas as dependências foram instaladas."
    fi
    
    # Mensagem final
    echo
    print_header "╔══════════════════════════════════════════════════════════════════╗"
    print_header "║                    🎉 INSTALAÇÃO CONCLUÍDA! 🎉                   ║"
    print_header "╚══════════════════════════════════════════════════════════════════╝"
    echo
    print_message "🚀 Para começar a usar:"
    print_message "   1. Execute: nvim"
    print_message "   2. Aguarde a instalação automática dos plugins"
    print_message "   3. Reinicie o Neovim após a instalação dos plugins"
    echo
    print_message "🔥 Teclas importantes:"
    print_message "   • <leader> = espaço"
    print_message "   • <leader>ff = buscar arquivos"
    print_message "   • <leader>b = toggle file explorer"
    print_message "   • <leader>w = salvar arquivo"
    print_message "   • <leader>q = sair do Neovim"
    echo
    print_message "📖 Para mais keymaps, consulte a documentação do projeto!"
    echo
    print_header "Aproveite seu novo setup do Neovim! 🚀✨"
    echo
}

# Verificar argumentos para modo não-interativo
if [[ "$1" == "--auto" ]]; then
    print_message "Modo automático ativado - usando detecção automática"
    AUTO_MODE=true
else
    AUTO_MODE=false
fi

# Executar função principal
main "$@"
