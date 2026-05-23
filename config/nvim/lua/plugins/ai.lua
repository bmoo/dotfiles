return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			terminal = {
				split_side = "right",
				split_width_percentage = 0.35,
			},
		},
		config = function(_, opts)
			require("claudecode").setup(opts)

			local target_pct = opts.terminal.split_width_percentage

			local function find_claude_win()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_buf_get_name(buf):lower():match("claude") then
						return win
					end
				end
			end

			vim.api.nvim_create_autocmd("BufWinEnter", {
				group = vim.api.nvim_create_augroup("ClaudeFixedWidth", { clear = true }),
				callback = function()
					local claude_win = find_claude_win()
					if not claude_win or vim.api.nvim_get_current_win() == claude_win then
						return
					end
					local target = math.floor(vim.o.columns * target_pct)
					if vim.api.nvim_win_get_width(claude_win) ~= target then
						vim.api.nvim_win_set_width(claude_win, target)
					end
				end,
			})
		end,
		keys = require("keymaps.ai").lazy_keys,
	},
	{
		"folke/snacks.nvim",
		lazy = true,
		opts = {},
	},
}
