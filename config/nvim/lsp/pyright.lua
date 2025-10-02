-- pyright
vim.lsp.config("pyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic", -- or 'strict'
				autoImportCompletions = true,
			},
		},
	},
})
