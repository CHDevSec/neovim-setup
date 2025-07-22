# 🚀 Neovim Setup - Professional Neovim Configuration

![Neovim](https://img.shields.io/badge/Neovim-Setup-blue?style=for-the-badge&logo=neovim)
![Shell](https://img.shields.io/badge/Shell-Bash-green?style=for-the-badge&logo=gnu-bash)
![License](https://img.shields.io/github/license/Posedequebradaaa/neovim-setup?style=for-the-badge)

## ⚡ Quick Actions
[![Install Neovim](https://img.shields.io/badge/Install%20Neovim-%E2%AC%85-blue?style=for-the-badge)](#-installation)  
[![View Keymaps](https://img.shields.io/badge/View%20Keymaps-%F0%9F%94%8D-yellow?style=for-the-badge)](#-keymaps)

## 📌 About
This is a **powerful and optimized Neovim configuration**, designed to be used as a development IDE. With **LSP support, essential plugins, and a beautiful theme**, this setup improves **speed, productivity, and organization**.

> 🕒 **Startup time:** 44.1ms 🚀

If you already have a custom Neovim setup, you can **automatically back up your existing configuration** before applying this setup.

## 🖥️ Neovim Preview
![Neovim Preview](https://github.com/Posedequebradaaa/neovim-setup/raw/main/neovim.gif)

## 🎮 Keymaps

Here are some useful keymaps included in this Neovim setup:

### 📁 **File Management**
| Keymap        | Action |
|--------------|--------|
| `<leader>w`  | Save file |
| `<leader>q`  | Quit Neovim |

### 🖥️ **Window Management & Navigation**
| Keymap       | Action |
|-------------|--------|
| `<leader>sh` | Split window **horizontally** |
| `<leader>sv` | Split window **vertically** |
| `<C-k>` | Move **up** |
| `<C-j>` | Move **down** |
| `<C-h>` | Move **left** |
| `<C-l>` | Move **right** |
| `<leader>th` | Change window layout to **horizontal** |
| `<leader>tk` | Change window layout to **vertical** |

### 📌 **Editing & Selection**
| Keymap       | Action |
|-------------|--------|
| `J` (Visual) | Move selected line **down** |
| `K` (Visual) | Move selected line **up** |
| `<C-a>` | Select **all** |
| `<leader>co` | Toggle **comment** |

### 🔍 **Search & Files (Telescope)**
| Keymap       | Action |
|-------------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep search |
| `<leader>fr` | Open recent files |
| `<leader>fb` | Open buffers |

### 🔀 **Tabs & Buffers**
| Keymap       | Action |
|-------------|--------|
| `<Tab>` | Go to **next tab** |
| `<S-Tab>` | Go to **previous tab** |
| `<leader>x` | Close buffer |
| `<A-p>` | Pin buffer |

### 📂 **File Explorer (NeoTree)**
| Keymap       | Action |
|-------------|--------|
| `<leader>b` | Toggle NeoTree |
| `<leader>nb` | Reveal buffer in NeoTree |

### 🔥 **Advanced Search (Spectre)**
| Keymap       | Action |
|-------------|--------|
| `<leader>S` | Toggle Spectre |
| `<leader>sw` | Search for the selected word |
| `<leader>sp` | Search in the current file |

---

## 🎯 **Included Plugins**
This setup comes pre-configured with the following plugins:

✅ **Interface & Navigation**  
`Alpha`, `Barbar`, `Lualine`, `NeoTree`

✅ **Productivity & Utilities**  
`Autopairs`, `Comments`, `Spectre`, `Which-Key`

✅ **LSP & Autocompletion**  
`LSP Config`, `Completions`, `Conform`

✅ **Appearance & Themes**  
`Highlight-Colors`, `Indent-Blankline`, `Tokyo-Night`

✅ **Development**  
`Telescope`, `Treesitter`

---

## 🔄 **Acknowledgements**
This Neovim setup is based on the **dotfiles** by **Ghosts** (https://github.com/gh0stzk/dotfiles).  
Thank you for sharing your amazing configurations! 💻🔥

---

## 🛠️ **Requirements**
Before installing, make sure you have:
- **A Debian-based system (Ubuntu, Pop!_OS, etc.) _or_ a Pacman-based system (Arch, CachyOS, etc.)**
- **Git installed** (`sudo apt install git` _ou_ `sudo pacman -S git`)
- **Internet connection**

## 📥 **Installation**
To install Neovim with this configuration, run the following commands:

```bash
git clone https://github.com/Posedequebradaaa/neovim-setup.git
cd neovim-setup
chmod +x install.sh
./install.sh
