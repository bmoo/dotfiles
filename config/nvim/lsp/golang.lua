local shared = require("sharedlsp")

vim.lsp.config("gopls", {
    on_attach = shared.on_attach,
    capabilities = shared.capabilities,
    settings = {
        gopls = {
            usePlaceholders = true,
            analyses = { unusedparams = true, unreachable = true },
            staticcheck = true,
        },
    },
})
