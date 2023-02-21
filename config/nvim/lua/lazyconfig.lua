local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local devicons = "kyazdani42/nvim-web-devicons"

-- Install plugins
require("lazy").setup({
    -- editor help
    "windwp/nvim-autopairs",
    "windwp/nvim-ts-autotag",

    -- debugger
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
    },
    {
        "folke/noice.nvim",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },
    -- golang
    {
        "ray-x/go.nvim",
        requires = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },


    -- mason config
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- buffer line
    {
        "akinsho/bufferline.nvim",
        dependencies = devicons,
    },

    -- color scheme
    "Shatur/neovim-ayu",

    "neovim/nvim-lspconfig", -- Configurations for Nvim LSP
    "jose-elias-alvarez/null-ls.nvim",

    "f-person/auto-dark-mode.nvim",
    "folke/which-key.nvim",

    {
        "nvim-lualine/lualine.nvim",
        dependencies = devicons,
    },

    -- completion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim", -- format error dialogs nicely

    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sharkdp/fd",
            "BurntSushi/ripgrep",
        },
    },

    {
        "kyazdani42/nvim-tree.lua",
        dependencies = devicons,
    },

    "christoomey/vim-tmux-navigator", -- enable tmux keybinds while using vim
    "nvim-treesitter/nvim-treesitter",

    -- Statusline
    {
        "feline-nvim/feline.nvim",
        dependencies = devicons,
    },

    -- git labels
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({})
        end,
    },

    -- Dashboard (start screen)
    {
        "goolord/alpha-nvim",
        dependencies = devicons,
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end,
    },
})
