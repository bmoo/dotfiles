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
require("nav_keys").setup()
require("lsp").setup()

require("keymap").group({
  ["<leader>a"] = "AI/Claude Code",
  ["<leader>b"] = "Buffer",
  ["<leader>f"] = "Find",
  ["<leader>g"] = "LSP",
  ["<leader>G"] = "Git",
  ["<leader>l"] = "LSP Actions",
  ["<leader>r"] = "Refactor",
})
require("keymap").finalize()

-- Open Claude (left) and file tree (right) on startup; land focus in Claude
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argc = vim.fn.argc()
    local opened_with_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
    if argc > 0 and not opened_with_dir then
      return
    end
    vim.schedule(function()
      require("lazy").load({ plugins = { "neo-tree.nvim", "claudecode.nvim" } })
      -- ClaudeCode first: it focuses its own terminal window. Neotree show
      -- then saves that focused window and restores it after opening the
      -- tree, leaving us on Claude. Reversing the order makes neo-tree's
      -- async restore-focus snap us back to [No Name].
      vim.cmd("ClaudeCode")
      vim.cmd("Neotree show")
      vim.schedule(function()
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[b].filetype == "snacks_terminal"
              and vim.api.nvim_buf_get_name(b):lower():match("claude") then
            -- snacks sets ft=snacks_terminal before opening the window, so barbar's
            -- sidebar_filetypes listener captures bufwinid=-1 in a closure and never
            -- applies the bufferline-exclusion offset. Re-fire FileType so barbar
            -- re-registers its nested listener, then BufWinEnter to trigger it.
            vim.api.nvim_exec_autocmds("FileType", { buffer = b, modeline = false })
            vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = b, modeline = false })
            local win = vim.fn.bufwinid(b)
            if win ~= -1 then
              vim.api.nvim_set_current_win(win)
              vim.cmd("startinsert")
            end
            break
          end
        end
      end)
    end)
  end,
})
