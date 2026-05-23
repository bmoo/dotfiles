local M = {}

M.capabilities = (function()
	local c = vim.lsp.protocol.make_client_capabilities()
	local ok, blink = pcall(require, "blink.cmp")
	return ok and blink.get_lsp_capabilities(c) or c
end)()

function M.on_attach(client, bufnr)
	require("keymaps").attach_lsp(client, bufnr)
	require("nvim-navic").attach(client, bufnr)
end

return M
