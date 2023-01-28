require("packer_init")

vim.g.mapleader = ","

-- appearance
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "ON"
vim.o.termguicolors = true
vim.o.background = "light"
vim.o.mouse = "a"

-- tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- color scheme
require("ayu").colorscheme()

-- file browser
require("nvim-tree").setup()

-- lua line
require("lualine").setup({
    options = {
        theme = "ayu",
        globalstatus = true,
    },
    sections = {
        lualine_c = {
            {
                "filename",
                path = 1,
                shorting_target = 40,
            },
        },
    },
})

-- buffer line
require("bufferline").setup({
    options = {
        offsets = {
            {
                filetype = "NvimTree",
                text = function()
                    return vim.fn.getcwd()
                end,
                highlight = "Directory",
                text_align = "left"
            }
        }
    }
})

-- mason config
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
        },
    },
})
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua" },
})

-- nvim-tree config
vim.keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>")
require("nvim-tree").setup({
    sync_root_with_cwd = true,
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
                { key = "v", action = "vsplit" },
                { key = "s", action = "split" },
            },
        },
    },
    renderer = {
        group_empty = true,
        highlight_opened_files = "all",
        symlink_destination = false,
    },
    filters = {
        dotfiles = false,
    },
})

-- dark mode
local auto_dark_mode = require("auto-dark-mode")

auto_dark_mode.setup({
    set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        --		vim.cmd('colorscheme ayu')
    end,
    set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        --		vim.cmd('colorscheme ayu')
    end,
})
auto_dark_mode.init()

-- python
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)


-- telescope
require("telescope").setup({
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key",
            },
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    },
})

vim.keymap.set("n", "ff", require("telescope.builtin").find_files, opts)
vim.keymap.set("n", "fg", require("telescope.builtin").live_grep, opts)
vim.keymap.set("n", "fb", require("telescope.builtin").buffers, opts)
vim.keymap.set("n", "fh", require("telescope.builtin").help_tags, opts)

require("lsp")
