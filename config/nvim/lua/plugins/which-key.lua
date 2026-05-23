return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>a", group = "AI/Claude Code" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "LSP" },
			{ "<leader>l", group = "LSP Actions" },
			{ "<leader>r", group = "Refactor" },
		})
	end,
}
