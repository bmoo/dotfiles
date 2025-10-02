vim.lsp.config("gopls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            usePlaceholders = true,
            analyses = { unusedparams = true, unreachable = true },
            staticcheck = true,
        },
    },
})
