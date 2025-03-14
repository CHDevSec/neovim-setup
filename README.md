# 🚀 Neovim Setup - Configuração Profissional do Neovim 

![Neovim](https://img.shields.io/badge/Neovim-Setup-blue?style=for-the-badge&logo=neovim)
![Shell](https://img.shields.io/badge/Shell-Bash-green?style=for-the-badge&logo=gnu-bash)
![License](https://img.shields.io/github/license/Posedequebradaaa/neovim-setup?style=for-the-badge)

## 📌 Sobre
Esta é uma **configuração poderosa e otimizada do Neovim**, pronta para ser usada como IDE para desenvolvimento. Com suporte a LSP, plugins essenciais e um tema bonito, esse setup melhora **velocidade, produtividade e organização**.

> 🕒 **Startup time:** 44.1ms 🚀

Se você já tem sua própria configuração personalizada do Neovim, pode **fazer backup automático** antes de aplicar este setup.

## 🖥️ Preview do Neovim
![Neovim Preview](https://github.com/Posedequebradaaa/neovim-setup/raw/main/neovim.gif)

## 🎮 Atalhos de Teclado (Keymaps)

Aqui estão alguns atalhos úteis configurados nesta versão do Neovim:

### 📁 **Manipulação de Arquivos**
| Atalho         | Ação                 |
|---------------|---------------------|
| `<leader>w`   | Salvar arquivo |
| `<leader>q`   | Fechar Neovim |

### 🖥️ **Janela e Navegação**
| Atalho        | Ação |
|--------------|------|
| `<leader>sh` | Dividir janela **horizontalmente** |
| `<leader>sv` | Dividir janela **verticalmente** |
| `<C-k>` | Mover para **cima** |
| `<C-j>` | Mover para **baixo** |
| `<C-h>` | Mover para **esquerda** |
| `<C-l>` | Mover para **direita** |
| `<leader>th` | Alterar layout para **horizontal** |
| `<leader>tk` | Alterar layout para **vertical** |

### 📌 **Edição e Seleção**
| Atalho       | Ação |
|-------------|------|
| `J` (Visual) | Mover linha **para baixo** |
| `K` (Visual) | Mover linha **para cima** |
| `<C-a>` | Selecionar **tudo** |
| `<leader>co` | Ativar/Desativar **comentário** |

### 🔍 **Busca e Arquivos (Telescope)**
| Atalho       | Ação |
|-------------|------|
| `<leader>ff` | Buscar arquivos |
| `<leader>fg` | Buscar texto |
| `<leader>fr` | Abrir arquivos recentes |
| `<leader>fb` | Abrir buffers ativos |

### 🔀 **Tabs e Buffers**
| Atalho       | Ação |
|-------------|------|
| `<Tab>` | Ir para **próxima aba** |
| `<S-Tab>` | Ir para **aba anterior** |
| `<leader>x` | Fechar buffer |
| `<A-p>` | Fixar buffer |

### 📂 **Navegação de Arquivos (NeoTree)**
| Atalho       | Ação |
|-------------|------|
| `<leader>b` | Alternar NeoTree |
| `<leader>nb` | Revelar buffer atual no NeoTree |

### 🔥 **Busca Avançada (Spectre)**
| Atalho       | Ação |
|-------------|------|
| `<leader>S` | Alternar Spectre |
| `<leader>sw` | Buscar palavra selecionada |
| `<leader>sp` | Buscar dentro do arquivo atual |

---
## 🎯 **Plugins Incluídos**
Este setup já vem com os seguintes plugins configurados:

✅ **Interface e Navegação**  
- **Alpha** - Tela inicial personalizada  
- **Barbar** - Melhor gerenciamento de abas  
- **Lualine** - Status bar estilizada  
- **Neotree** - Explorador de arquivos avançado  

✅ **Produtividade e Utilitários**  
- **Autopairs** - Completa automaticamente parênteses e aspas  
- **Comments** - Atalhos fáceis para comentar código  
- **Spectre** - Ferramenta avançada de busca e substituição  
- **Which-Key** - Exibe atalhos disponíveis para comandos  

✅ **LSP e Autocompletar**  
- **LSP Config** - Integração com servidores de linguagem  
- **Completions** - Suporte a snippets e sugestões  
- **Conform** - Formatação automática de código  

✅ **Aparência e Temas**  
- **Highlight-Colors** - Destaca cores no código  
- **Indent-Blankline** - Exibe guias de indentação  
- **Tokyo-Night Theme** - Tema visual moderno e clean  

✅ **Desenvolvimento**  
- **Telescope** - Pesquisa instantânea no projeto  
- **Treesitter** - Melhor realce de sintaxe  

## 🛠️ **Pré-requisitos**
Antes de instalar, certifique-se de ter:
- **Sistema baseado em Debian (Ubuntu, Pop!_OS, etc.)**
- **Git instalado** (`sudo apt install git`)
- **Conexão com a internet**

## 📥 **Instalação**
Para instalar o Neovim com esta configuração, execute os seguintes comandos:

```bash
git clone https://github.com/Posedequebradaaa/neovim-setup.git
cd neovim-setup
chmod +x install.sh
./install.sh
