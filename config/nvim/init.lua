-- vim.g is global
vim.g.mapleader = " "

-- vim.o is options
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.timeout = true
vim.o.timeoutlen = 300

-- tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- UI/UX
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6
vim.opt.wrap = false
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "" }

-- Performance & typing
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- python version
vim.g.python3_host_prog = vim.fn.trim(vim.fn.system("which python3"))

-- lazy computes a dependency graph and loads all plugins
require("config.lazy").setup()

require("diagnostics").setup()
require("completion").setup()
require("treesitter")
require("dapconfig")