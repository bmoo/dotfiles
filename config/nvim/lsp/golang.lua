local shared = require("sharedlsp")

vim.lsp.config("gopls", {
    on_attach = shared.on_attach,
    capabilities = shared.capabilities,
    settings = {
        gopls = {
            usePlaceholders = true,
            analyses = { unusedparams = true, unreachable = true },
            staticcheck = true,
            -- Enable inlay hints
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})
