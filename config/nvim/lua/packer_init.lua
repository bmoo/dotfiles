local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })
    vim.o.runtimepath = vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath
end

-- Autocommand that reloads neovim whenever you save the packer_init.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_init.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Install plugins
return packer.startup(function(use)
        -- Add you plugins here:
        use("wbthomason/packer.nvim") -- packer can manage itself

        use {
            'folke/noice.nvim',
            requires = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify",
            }
        }

        -- mason config
        use({ "williamboman/mason.nvim" })
        use({ "williamboman/mason-lspconfig.nvim" })

        -- buffer line
        use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })

        -- color scheme
        use("Shatur/neovim-ayu")

        use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
        use("jose-elias-alvarez/null-ls.nvim")

        use("f-person/auto-dark-mode.nvim")

        use({
            "nvim-lualine/lualine.nvim",
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
        })

        -- completion
        use("hrsh7th/nvim-cmp")
        use("hrsh7th/cmp-buffer")
        use("hrsh7th/cmp-path")
        use("hrsh7th/cmp-nvim-lua")
        use("hrsh7th/cmp-nvim-lsp")
        use("saadparwaiz1/cmp_luasnip")
        use("onsails/lspkind.nvim")

        -- telescope
        use({
            "nvim-telescope/telescope.nvim",
            tag = "0.1.0",
            requires = {
                "nvim-lua/plenary.nvim",
                "sharkdp/fd",
                "BurntSushi/ripgrep",
            },
        })

        use({
            "kyazdani42/nvim-tree.lua",
            requires = {
                "kyazdani42/nvim-web-devicons", -- optional, for file icons
            },
        })

        use("christoomey/vim-tmux-navigator") -- enable tmux keybinds while using vim

        use("nvim-treesitter/nvim-treesitter")

        -- Statusline
        use({
            "feline-nvim/feline.nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
        })

        -- git labels
        use({
            "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("gitsigns").setup({})
            end,
        })

        -- Dashboard (start screen)
        use({
            "goolord/alpha-nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require("alpha").setup(require("alpha.themes.startify").config)
            end,
        })

        use({
            "jamestthompson3/nvim-remote-containers",
            requires = { "nvim-treesitter/nvim-treesitter" },
        })

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require("packer").sync()
        end
    end)
