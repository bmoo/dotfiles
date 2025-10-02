-- vim.g is global
vim.g.mapleader = " "

require("lazyconfig").setup()

require("lsp").setup()
require("diagnostics").setup()
require("treesitter")
require("dapconfig")
require("telescopeconfig")

require("config.whichkey").setup()

-- appearance
-- vim.o is options
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "ON"
vim.o.termguicolors = true
vim.o.mouse = "a"
vim.o.timeout = true
vim.o.timeoutlen = 300

-- tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Ensure PATH includes Homebrew + Mason shims
vim.env.PATH = table.concat({
    "/opt/homebrew/bin",
    vim.fn.expand("~/.local/share/nvim/mason/bin"),
    vim.env.PATH,
}, ":")

-- python version
vim.g.python3_host_prog = vim.fn.trim(vim.fn.system("which python3"))
-- color scheme
local ayu = require("ayu")
ayu.setup({
    mirage = true,
})
ayu.colorscheme()

require("ibl").setup()

-- auto pairs
require("nvim-autopairs").setup()

local navic = require("nvim-navic")
navic.setup({
    icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
    },
})

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
            {
                function()
                    return navic.get_location()
                end,
                cond = function()
                    return navic.is_available()
                end,
            },
        },
    },
})

-- buffer line
require("bufferline").setup({
    options = {
        numbers = "buffer_id",
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
        diagnostics = "nvim_lsp",
    },
})

local nvimtree_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
end

-- nvim-tree config
require("nvim-tree").setup({
    sync_root_with_cwd = true,
    sort_by = "case_sensitive",
    on_attach = nvimtree_attach,
    view = {
        adaptive_size = true,
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
