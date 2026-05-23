local M = {}

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

function M.setup()
	-- Terminal mode
	map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")
	map("t", "<C-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]],  "tmux nav left")
	map("t", "<C-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]],  "tmux nav down")
	map("t", "<C-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]],    "tmux nav up")
	map("t", "<C-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], "tmux nav right")

	-- Buffer navigation
	map("n", "<leader>bl", "<cmd>blast<cr>",         "Last Buffer")
	map("n", "<leader>bf", "<cmd>bfirst<cr>",        "First Buffer")
	map("n", "<leader>bp", "<cmd>bprevious<cr>",     "Previous Buffer")
	map("n", "<leader>bn", "<cmd>bnext<cr>",         "Next Buffer")
	map("n", "<leader>bb", "<cmd>BufferPick<cr>",    "Pick a Buffer")

	-- Find (snacks.picker)
	local pick = function(name) return function() Snacks.picker[name]() end end
	map("n", "<leader>ff", pick("files"),   "Find Files")
	map("n", "<leader>fg", pick("grep"),    "Live Grep")
	map("n", "<leader>fb", pick("buffers"), "Find Buffer")
	map("n", "<leader>fh", pick("help"),    "Find Help")

	-- Diagnostics navigation
	map("n", "[d", function() vim.diagnostic.goto_prev() end, "Previous Diagnostic")
	map("n", "]d", function() vim.diagnostic.goto_next() end, "Next Diagnostic")

	-- Quickfix / loclist
	map("n", "<leader>q", "<cmd>lclose<bar>cclose<cr>", "Close loclist/quickfix")

	-- IncRename (built-in rename; plugin-driven refactors live with the plugin)
	map("n", "<leader>rn", "<cmd>IncRename<cr>", "Rename")
end

return M
