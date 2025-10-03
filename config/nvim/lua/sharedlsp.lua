local M = {}

M.capabilities = (function()
	local c = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp = pcall(require, "cmp_nvim_lsp")
	return ok and cmp.default_capabilities(c) or c
end)()

function M.on_attach(client, bufnr)
	local map = function(m, l, r, desc)
		vim.keymap.set(m, l, r, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Basic LSP navigation
	map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
	map("n", "gr", vim.lsp.buf.references, "Find References")

	-- Enable inlay hints if supported
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		-- Toggle inlay hints with a keymap
		map("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, "Toggle Inlay Hints")
	end

	-- Enable and refresh code lens if supported
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.refresh()
		-- Auto-refresh code lens on certain events
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = vim.lsp.codelens.refresh,
		})
		-- Keymap to run code lens action
		map("n", "<leader>ll", vim.lsp.codelens.run, "Run Code Lens")
	end

	vim.keymap.set({ "n", "x" }, "<leader>re", function()
		return require("refactoring").refactor("Extract Function")
	end, { expr = true, desc = "Extract Function" })
	vim.keymap.set({ "n", "x" }, "<leader>rf", function()
		return require("refactoring").refactor("Extract Function To File")
	end, { expr = true, desc = "Extract Function to File" })
	vim.keymap.set({ "n", "x" }, "<leader>rv", function()
		return require("refactoring").refactor("Extract Variable")
	end, { expr = true, desc = "Extract Variable" })
	vim.keymap.set({ "n", "x" }, "<leader>rI", function()
		return require("refactoring").refactor("Inline Function")
	end, { expr = true, desc = "Inline Function" })
	vim.keymap.set({ "n", "x" }, "<leader>ri", function()
		return require("refactoring").refactor("Inline Variable")
	end, { expr = true, desc = "Inline Variable" })

	vim.keymap.set({ "n", "x" }, "<leader>rbb", function()
		return require("refactoring").refactor("Extract Block")
	end, { expr = true, desc = "Extract Block" })
	vim.keymap.set({ "n", "x" }, "<leader>rbf", function()
		return require("refactoring").refactor("Extract Block To File")
	end, { expr = true, desc = "Extract Block to File" })

	-- TODO can this reference be cached?
	local navic = require("nvim-navic")
	navic.attach(client, bufnr)
end

return M
