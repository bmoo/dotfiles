return {
    "stevearc/conform.nvim",
    opts = {
        -- map filetypes to the external tools you want
        formatters_by_ft = {
            lua = {"stylua"},
            python = {"ruff_format", "black"}, -- ruff_format first, black as fallback
            go = {"goimports", "gofmt"},
            json = {"jq"},
            yaml = {"yamlfmt"}
            -- add more as you need: javascript = { "prettier" }, etc.
        },
        -- on save: run the above; if none configured for the filetype,
        -- fall back to LSP's formatting (if the server supports it)
        format_on_save = function(bufnr)
            return {
                timeout_ms = 2000,
                lsp_fallback = true
            }
        end,
        -- nice default; keeps your cursor/extmarks stable
        notify_on_error = true
    }
}