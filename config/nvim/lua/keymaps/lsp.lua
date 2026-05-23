local M = {}

function M.attach(client, bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end
	local tb = function(name) return function() require("telescope.builtin")[name]() end end

	-- Navigation
	map("n", "<leader>gd", tb("lsp_definitions"),      "Go to Definition")
	map("n", "<leader>gr", tb("lsp_references"),       "Find References")
	map("n", "<leader>gi", tb("lsp_implementations"),  "Go to Implementation")
	map("n", "<leader>gy", tb("lsp_type_definitions"), "Go to Type Definition")
	map("n", "<leader>gD", vim.lsp.buf.declaration,    "Go to Declaration")

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
end

return M
