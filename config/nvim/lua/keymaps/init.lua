local M = {}

function M.setup()
	require("keymaps.global").setup()
end

function M.attach_lsp(client, bufnr)
	require("keymaps.lsp").attach(client, bufnr)
end

function M.attach_markdown(bufnr)
	require("keymaps.markdown").attach(bufnr)
end

function M.wk_groups()
	return {
		{ "<leader>a", group = "AI/Claude Code" },
		{ "<leader>b", group = "Buffer" },
		{ "<leader>f", group = "Telescope" },
		{ "<leader>g", group = "LSP" },
		{ "<leader>l", group = "LSP Actions" },
		{ "<leader>r", group = "Refactor" },
	}
end

return M
