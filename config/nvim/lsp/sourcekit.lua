local shared = require("sharedlsp")

return {
	on_attach = shared.on_attach,
	capabilities = shared.capabilities,
	cmd = { "sourcekit-lsp" },
	filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
	root_markers = { "Package.swift", "*.xcodeproj", "*.xcworkspace", "compile_commands.json", ".git" },
}
