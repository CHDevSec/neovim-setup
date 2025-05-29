return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = {
                -- Web Development
                "html",           -- HTML
                "cssls",          -- CSS
                "ts_ls",          -- TypeScript/JavaScript
                "emmet_ls",       -- Emmet para HTML/CSS
                "tailwindcss",    -- Tailwind CSS
                
                -- Backend/Systems
                "lua_ls",         -- Lua
                "bashls",         -- Bash
                "pyright",        -- Python
                "gopls",          -- Go
                "rust_analyzer",  -- Rust
                
                -- C/C++
                "clangd",         -- C/C++
                
                -- .NET/C#
                "omnisharp",      -- C#
                
                -- DevOps/Config
                "yamlls",         -- YAML
                "jsonls",         -- JSON
                "dockerls",       -- Docker
                
                -- Other useful ones
                "marksman",       -- Markdown
                "sqlls",          -- SQL
            },
            auto_install = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            
            -- Configuração comum para todos os LSPs
            local common_opts = {
                capabilities = capabilities,
            }
            
            -- Web Development
            lspconfig.html.setup(common_opts)
            lspconfig.cssls.setup(common_opts)
            
            -- TypeScript/JavaScript
            lspconfig.ts_ls.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    }
                }
            }))
            
            -- Emmet para HTML/CSS
            lspconfig.emmet_ls.setup(vim.tbl_extend("force", common_opts, {
                filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" }
            }))
            
            -- Tailwind CSS
            lspconfig.tailwindcss.setup(common_opts)
            
            -- Python
            lspconfig.pyright.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic"
                        }
                    }
                }
            }))
            
            -- Go
            lspconfig.gopls.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            }))
            
            -- Rust
            lspconfig.rust_analyzer.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    ["rust-analyzer"] = {
                        assist = {
                            importGranularity = "module",
                            importPrefix = "by_self",
                        },
                        cargo = {
                            loadOutDirsFromCheck = true
                        },
                        procMacro = {
                            enable = true
                        },
                        checkOnSave = {
                            command = "clippy"
                        },
                    }
                }
            }))
            
            -- C/C++
            lspconfig.clangd.setup(vim.tbl_extend("force", common_opts, {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            }))
            
            -- C# (OmniSharp)
            lspconfig.omnisharp.setup(vim.tbl_extend("force", common_opts, {
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                settings = {
                    FormattingOptions = {
                        EnableEditorConfigSupport = true,
                        OrganizeImports = true,
                    },
                    MsBuild = {
                        LoadProjectsOnDemand = false,
                    },
                    RoslynExtensionsOptions = {
                        EnableAnalyzersSupport = true,
                        EnableImportCompletion = true,
                        AnalyzeOpenDocumentsOnly = false,
                    },
                    Sdk = {
                        IncludePrereleases = true,
                    },
                }
            }))
            
            -- Lua
            lspconfig.lua_ls.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }))
            
            -- Bash
            lspconfig.bashls.setup(common_opts)
            
            -- YAML
            lspconfig.yamlls.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    yaml = {
                        schemas = {
                            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose*.yml",
                        },
                    },
                },
            }))
            
            -- JSON
            lspconfig.jsonls.setup(vim.tbl_extend("force", common_opts, {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
            }))
            
            -- Docker
            lspconfig.dockerls.setup(common_opts)
            
            -- Markdown
            lspconfig.marksman.setup(common_opts)
            
            -- SQL
            lspconfig.sqlls.setup(common_opts)
            
            -- Keymaps para LSP
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
            vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Show references" })
            vim.keymap.set("n", "<leader>gs", vim.lsp.buf.signature_help, { desc = "Show signature help" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
            vim.keymap.set("n", "<leader>gf", function()
                vim.lsp.buf.format({ async = true })
            end, { desc = "Format code" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
            
            -- Diagnostics keymaps
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
            
            -- Configurar símbolos de diagnóstico
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
            
            -- Configurar diagnósticos
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●", -- Could be '■', '▎', 'x'
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
            
            -- Configurar bordas para janelas flutuantes do LSP
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or "rounded"
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end
        end,
    },
    -- Plugin adicional para esquemas JSON
    {
        "b0o/schemastore.nvim",
        lazy = true,
    },
}
