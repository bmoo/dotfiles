return {
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
