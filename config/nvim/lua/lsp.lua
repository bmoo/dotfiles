-- completion

local cmp = require("cmp")

-- lspkind makes the dialogs look cool
local lspkind = require("lspkind")
cmp.setup({
    completion = {
        keyword_length = 3,
    },
    performance = {
        debounce = 300,
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs( -4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<c-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<c-space>"] = cmp.mapping.complete(),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
    }, {
        { name = "buffer" },
    }),
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
            },
        }),
    },
})

-- lsp is built in to neovim but the config is external
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
    },
    on_attach = function(client, pbufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = pbufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = pbufnr,
                callback = function()
                    vim.lsp.buf.format({
                        options = { bufnr = pbufnr },
                        -- don't use null-ls to format lua files
                        filter = function(cl)
                            return cl.name ~= "null-ls"
                        end,
                    })
                end,
            })
        end
    end,
})

local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

if not configs.golangcilsp then
    configs.golangcilsp = {
        default_config = {
            cmd = { "golangci-lint-langserver" },
            root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
            init_options = {
                command = {
                    "golangci-lint",
                    "run",
                    "--enable-all",
                    "--disable",
                    "lll",
                    "--out-format",
                    "json",
                    "--issues-exit-code=1",
                },
            },
        },
    }
end
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- format on save
    vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>F", vim.lsp.buf.formatting, bufopts)
end

local nvim_lsp = require("lspconfig")
nvim_lsp.golangci_lint_ls.setup({
    filetypes = { "go", "gomod" },
    on_attach = on_attach,
})
nvim_lsp.pyright.setup({
    on_attach = on_attach,
})

nvim_lsp.tsserver.setup({
    on_attach = on_attach,
})

nvim_lsp.gopls.setup({
    cmd = { "gopls" },
    on_attach = on_attach,
})

nvim_lsp.sumneko_lua.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
                disable = { "need-check-nil" },
            },
            --       workspace = {
            --         -- Make the server aware of Neovim runtime files
            --         library = vim.api.nvim_get_runtime_file("", true),
            --       },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
