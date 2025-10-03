return {
	{
		"mfussenegger/nvim-dap",
		lazy = true, -- Load on demand via DAP commands or keymaps
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go", -- Load only for Go files
		dependencies = { "mfussenegger/nvim-dap" },
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true, -- Load on demand
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true, -- Load on demand
		dependencies = { "mfussenegger/nvim-dap" },
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		lazy = true, -- Load on demand
		dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		lazy = true, -- Loaded via mason
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
	},
	{
		"neovim/nvim-lspconfig", -- Configurations for Nvim LSP
		event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
		dependencies = { { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" } },
	},
	{
		"mfussenegger/nvim-lint",
		lazy = false, -- Load immediately so mason-nvim-lint can access it
		priority = 85, -- Load after mason but before mason-nvim-lint
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" }, -- fast diagnostics from Ruff
				go = { "golangci_lint" }, -- Go linting via golangci-lint (auto-installed by mason-nvim-lint)
				--            lua = {"luacheck"}, -- optional if you want lua linting
				-- js/ts example: javascript = { "eslint_d" }, typescript = { "eslint_d" },
			}

			-- run linters on write and when you switch buffers
			local au = vim.api.nvim_create_augroup("NvimLint", {
				clear = true,
			})
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
				group = au,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	-- Note: auto-dark-mode.nvim is in appearance.lua, removing duplicate
	{
		"saadparwaiz1/cmp_luasnip",
		lazy = true, -- Loaded via nvim-cmp
	},
	{
		"onsails/lspkind.nvim",
		lazy = true, -- Loaded via nvim-cmp
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false, -- Keep loaded for seamless navigation
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" }, -- Load when opening files
		build = ":TSUpdate",
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" }, -- Load when opening files
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
