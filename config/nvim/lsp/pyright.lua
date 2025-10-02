-- pyright
local shared = require("sharedlsp")

vim.lsp.config("pyright", {
	on_attach = shared.on_attach,
	capabilities = shared.capabilities,
	settings = {
		python = {
			pythonPath = vim.fn.exepath("python3"),
			analysis = {
				typeCheckingMode = "basic", -- or 'strict'
				autoImportCompletions = true,
			},
		},
	},
})
