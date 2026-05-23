-- Launch claude with the current background as an explicit --settings override.
-- Otherwise claude probes the terminal with OSC 11 ("what's your background?"),
-- and nvim's :terminal doesn't fully consume the response — the query body
-- `11;?` leaks into claude's input prompt.
local function claude_cmd(extra_args)
	local theme = vim.o.background == "light" and "light" or "dark"
	local settings = "--settings '{\"theme\":\"" .. theme .. "\"}'"
	vim.cmd("ClaudeCode " .. (extra_args and (extra_args .. " ") or "") .. settings)
end

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
		keys = {
			{ "<leader>a",  nil, desc = "AI/Claude Code" },
			{ "<leader>ac", function() claude_cmd() end, desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", function() claude_cmd("--resume") end, desc = "Resume Claude" },
			{ "<leader>aC", function() claude_cmd("--continue") end, desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "neo-tree", "oil", "minifiles", "netrw" },
			},
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
