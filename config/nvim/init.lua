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
require("keymaps").setup()
require("lsp").setup()

-- Open file tree (left) and Claude (right) on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argc = vim.fn.argc()
    local opened_with_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
    if argc > 0 and not opened_with_dir then
      return
    end
    vim.schedule(function()
      require("lazy").load({ plugins = { "neo-tree.nvim", "claudecode.nvim" } })
      vim.cmd("Neotree show")
      local theme = vim.o.background == "light" and "light" or "dark"
      vim.cmd("ClaudeCode --settings '{\"theme\":\"" .. theme .. "\"}'")
      -- claudecode lands us in terminal-insert. Drop back to normal mode so
      -- <C-h>/<C-l> (tmux-navigator) and other normal-mode bindings work
      -- without a manual <C-\><C-n> first. Scheduled to run after
      -- claudecode's own startinsert fires.
      vim.schedule(function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true),
          "n", false
        )
      end)
    end)
  end,
})
