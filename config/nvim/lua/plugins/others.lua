return {"mfussenegger/nvim-dap", "leoluz/nvim-dap-go", {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
}, "theHamsta/nvim-dap-virtual-text", "nvim-telescope/telescope-dap.nvim", {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {"williamboman/mason.nvim"}
},
{
    "neovim/nvim-lspconfig", -- Configurations for Nvim LSP
    dependencies = {{"SmiteshP/nvim-navic", "MunifTanjim/nui.nvim"}}
}, {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = {"ruff"}, -- fast diagnostics from Ruff
            lua = {"luacheck"}, -- optional if you want lua linting
            go = {"golangci_lint"} -- optional; only if you use it
            -- js/ts example: javascript = { "eslint_d" }, typescript = { "eslint_d" },
        }

        -- run linters on write and when you switch buffers
        local au = vim.api.nvim_create_augroup("NvimLint", {
            clear = true
        })
        vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter", "InsertLeave"}, {
            group = au,
            callback = function()
                require("lint").try_lint()
            end
        })
    end
}, "f-person/auto-dark-mode.nvim", -- completion
"saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim", "christoomey/vim-tmux-navigator", "nvim-treesitter/nvim-treesitter",
        {
    "lewis6991/gitsigns.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    opts = {}
}}
