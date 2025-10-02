local M = {}

function M.setup()
    local lspkind = require("lspkind")
    -- completion
    local cmp = require("cmp")
    cmp.setup({
        completion = {
            keyword_length = 3
        },
        performance = {
            debounce = 30
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end
        },
        mapping = {
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<c-y>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            }),
            ["<c-space>"] = cmp.mapping.complete()
        },
        sources = cmp.config.sources({
            {
                name = "nvim_lsp"
            },
            -- auto complete neovim api calls
            {
                name = "nvim_lua"
            },
            {
                name = "luasnip"
            },
            native_menu = false,
            ghost_text = true
        }),
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                menu = {
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]"
                }
            })
        }
    })
end

return M

