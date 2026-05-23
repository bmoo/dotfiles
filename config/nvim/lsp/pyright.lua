return {
	settings = {
		python = {
			pythonPath = vim.fn.exepath("python3"),
			analysis = {
				typeCheckingMode = "basic",
				autoImportCompletions = true,
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
