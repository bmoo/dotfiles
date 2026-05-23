-- Buffer-local mappings in markdown notes. The leader-keys mirror the LSP
-- code-nav keys (<leader>gd, <leader>gr) so the same muscle memory works in
-- notes and code.
local M = {}

function M.attach(bufnr)
	vim.keymap.set("n", "gf", function()
		return require("obsidian").util.gf_passthrough()
	end, { noremap = false, expr = true, buffer = bufnr })
	vim.keymap.set("n", "<leader>gd", "<cmd>Obsidian follow_link<cr>",
		{ buffer = bufnr, desc = "Follow Wikilink" })
	vim.keymap.set("n", "<leader>gr", "<cmd>Obsidian backlinks<cr>",
		{ buffer = bufnr, desc = "Backlinks" })
end

return M
