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
-- Pin background early so nvim's built-in OSC 11 auto-detect doesn't fire
-- and get a lying answer from tmux (which fabricates rgb:ffff/ffff/ffff for
-- the screen-256color default). The appearance plugin will upgrade this
-- when a real terminal responds to a tmux-wrapped OSC 11 query.
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6
vim.opt.wrap = true
vim.opt.foldlevelstart = 99
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "" }

-- Performance & typing
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Auto-reload files changed on disk
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk, buffer reloaded", vim.log.levels.INFO)
  end,
})

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- python version
vim.g.python3_host_prog = vim.fn.trim(vim.fn.system("which python3"))

-- lazy computes a dependency graph and loads all plugins
require("config.lazy").setup()

-- colorscheme + terminal light/dark sync
require("appearance").setup()

require("diagnostics").setup()
require("treesitter")
require("dapconfig")
require("keymaps").setup()

-- Global LSP defaults — per-language config in lsp/<server>.lua merges on top.
-- mason-lspconfig auto-enables servers in its ensure_installed list;
-- non-mason servers (e.g. sourcekit) need an explicit vim.lsp.enable.
local sharedlsp = require("sharedlsp")
vim.lsp.config("*", {
	capabilities = sharedlsp.capabilities,
	on_attach = sharedlsp.on_attach,
})
vim.lsp.enable("sourcekit")
