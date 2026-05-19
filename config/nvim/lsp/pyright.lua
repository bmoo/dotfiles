-- pyright
local shared = require("sharedlsp")

return {
	on_attach = shared.on_attach,
	capabilities = shared.capabilities,
	settings = {
		python = {
			pythonPath = vim.fn.exepath("python3"),
			analysis = {
				typeCheckingMode = "basic", -- or 'strict'
				autoImportCompletions = true,
				-- Enable inlay hints (Pyright/Pylance feature)
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = true,
					pytestParameters = true,
				},
			},
		},
	},
}
