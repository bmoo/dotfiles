-- Owns the global LSP attach lifecycle: capabilities, on_attach (maps, inlay
-- hints, codelens, navic), and the vim.lsp.config('*') wiring. Per-language
-- settings live in lsp/<server>.lua and are merged on top by Neovim.
--
-- mason-lspconfig auto-enables servers in its ensure_installed list; non-mason
-- servers (e.g. sourcekit) need an explicit vim.lsp.enable here.

local M = {}

M.capabilities = (function()
	local c = vim.lsp.protocol.make_client_capabilities()
	local ok, blink = pcall(require, "blink.cmp")
	return ok and blink.get_lsp_capabilities(c) or c
end)()

function M.on_attach(client, bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end
	local pick = function(name) return function() Snacks.picker[name]() end end

	-- Navigation
	map("n", "<leader>gd", pick("lsp_definitions"),      "Go to Definition")
	map("n", "<leader>gr", pick("lsp_references"),       "Find References")
	map("n", "<leader>gi", pick("lsp_implementations"),  "Go to Implementation")
	map("n", "<leader>gy", pick("lsp_type_definitions"), "Go to Type Definition")
	map("n", "<leader>gD", vim.lsp.buf.declaration,      "Go to Declaration")

	-- Inlay hints
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		map("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(
				not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
				{ bufnr = bufnr })
		end, "Toggle Inlay Hints")
	end

	-- Code lens (auto-refreshes on buffer changes)
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
		map("n", "<leader>ll", vim.lsp.codelens.run, "Run Code Lens")
	end

	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
end

function M.setup()
	vim.lsp.config("*", {
		capabilities = M.capabilities,
		on_attach    = M.on_attach,
	})
	vim.lsp.enable("sourcekit")
end

return M
