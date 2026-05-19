local shared = require("sharedlsp")

return {
	on_attach = shared.on_attach,
	capabilities = shared.capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = { "vim" },
				disable = { "need-check-nil" },
			},
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = { enable = false },
			-- Enable inlay hints
			hint = {
				enable = true,
				arrayIndex = "Auto",
				setType = true,
				paramName = "All",
				paramType = true,
				await = true,
			},
		},
	},
}
