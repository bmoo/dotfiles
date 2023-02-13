require("packer_init")

require("lsp")
require("treesitter")
require("dapconfig")
require("telescopeconfig")

-- vim.g is global
vim.g.mapleader = ","

-- appearance
-- vim.o is options
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "ON"
vim.o.termguicolors = true
vim.o.mouse = "a"

-- tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- color scheme
local ayu = require("ayu")
ayu.setup({
    mirage = true,
})
ayu.colorscheme()

-- better UI prompts and toasts
require("noice").setup()

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
                text_align = "left",
            },
        },
    },
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
        vim.o.background = "dark"
    end,
    set_light_mode = function()
        if os.getenv("DARK") then
            vim.o.background = "dark"
        else
            vim.o.background = "light"
        end
    end,
})
auto_dark_mode.init()
