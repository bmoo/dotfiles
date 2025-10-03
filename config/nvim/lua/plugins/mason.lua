return {
	{
		"mason-org/mason.nvim",
		lazy = false, -- Load mason immediately
		priority = 100, -- Load before other tools
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false, -- Load immediately after mason
		priority = 90,
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "lua_ls", "pyright", "gopls" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		priority = 80,
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"golangci-lint", -- Go linter
				"ruff",          -- Python linter
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
