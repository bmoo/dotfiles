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

	-- Telescope
	local tb = function(name) return function() require("telescope.builtin")[name]() end end
	map("n", "<leader>ff", tb("find_files"), "Find Files")
	map("n", "<leader>fg", tb("live_grep"),  "Live Grep")
	map("n", "<leader>fb", tb("buffers"),    "Find Buffer")
	map("n", "<leader>fh", tb("help_tags"),  "Find Help")

	-- File tree
	map("n", "<leader>t", "<cmd>NvimTreeToggle<cr>", "File Tree")

	-- Diagnostics navigation
	map("n", "[d", function() vim.diagnostic.goto_prev() end, "Previous Diagnostic")
	map("n", "]d", function() vim.diagnostic.goto_next() end, "Next Diagnostic")

	-- Quickfix / loclist
	map("n", "<leader>q", "<cmd>lclose<bar>cclose<cr>", "Close loclist/quickfix")

	-- IncRename (built-in rename; plugin-driven refactors live in keymaps.refactor)
	map("n", "<leader>rn", "<cmd>IncRename<cr>", "Rename")
end

return M
