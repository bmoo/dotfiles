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
	lazy_keys = {
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
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
