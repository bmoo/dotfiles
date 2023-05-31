-- mason config
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
        },
    },
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "tailwindcss",
        "tsserver",
        "lua_ls",
        "gopls",
        "pyright",
        "terraformls",
    },
})

-- Disable virtual_text since it's redundant due to lsp_lines.
-- vim.diagnostic.config({
--     virtual_text = false,
-- })
-- require("lsp_lines").setup()

-- lspkind makes the dialogs look cool
local lspkind = require("lspkind")

-- completion
local cmp = require("cmp")
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
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
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
        -- auto complete neovim api calls
        { name = "nvim_lua" },
        { name = "luasnip" }, -- For luasnip users.
    }, {
        -- { name = "buffer" },
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

local navic = require("nvim-navic")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- format on save
    vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
end

local nvim_lsp = require("lspconfig")

-- should linters go here?
nvim_lsp.tflint.setup({
    on_attach = function()
        vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
    end,
})

local servers = {
    "tsserver",
    "tailwindcss",
    "gopls",
    "terraformls",
    "pyright",
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
        on_attach = on_attach,
    })
end

-- nvim_lsp.pyright.setup({
--     on_attach = on_attach,
--     on_new_config = function(config, root_dir)
--         local env = vim.trim(vim.fn.system('cd "' .. root_dir .. '"; poetry env info -p 2>/dev/null'))
--         if string.len(env) > 0 then
--             config.settings.python.pythonPath = env .. "/bin/python"
--         end
--     end,
-- })

nvim_lsp.lua_ls.setup({
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
            telemetry = {
                enable = false,
            },
        },
    },
})

local null_ls = require("null-ls")
local nulldiag = null_ls.builtins.diagnostics

-- lsp is built in to neovim but the config is external
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length=120 " },
        }),
        null_ls.builtins.diagnostics.eslint,
    },
    on_attach = function(client, pbufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = pbufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = pbufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end
    end,
})
