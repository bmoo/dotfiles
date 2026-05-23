-- Raw navigation keymaps that don't go through the leader-scoped registry:
-- terminal-mode escape + tmux navigation, diagnostic prev/next. Leader-scoped
-- globals (buffer nav, find, quickfix, IncRename) are declared via
-- require("keymap").register() so they're audited and collision-checked.

local M = {}

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

function M.setup()
    local keymap = require("keymap")
    local pick = function(name) return function() Snacks.picker[name]() end end

    keymap.register({
        { "<leader>bl", "<cmd>blast<cr>",      desc = "Last Buffer",      group = "buffer" },
        { "<leader>bf", "<cmd>bfirst<cr>",     desc = "First Buffer",     group = "buffer" },
        { "<leader>bp", "<cmd>bprevious<cr>",  desc = "Previous Buffer",  group = "buffer" },
        { "<leader>bn", "<cmd>bnext<cr>",      desc = "Next Buffer",      group = "buffer" },
        { "<leader>bb", "<cmd>BufferPick<cr>", desc = "Pick a Buffer",    group = "buffer" },

        { "<leader>ff", pick("files"),         desc = "Find Files",       group = "find" },
        { "<leader>fg", pick("grep"),          desc = "Live Grep",        group = "find" },
        { "<leader>fb", pick("buffers"),       desc = "Find Buffer",      group = "find" },
        { "<leader>fh", pick("help"),          desc = "Find Help",        group = "find" },

        { "<leader>q",  "<cmd>lclose<bar>cclose<cr>", desc = "Close loclist/quickfix" },
        { "<leader>rn", "<cmd>IncRename<cr>",  desc = "Rename",           group = "refactor" },
    })

    map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")
    map("t", "<C-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]],  "tmux nav left")
    map("t", "<C-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]],  "tmux nav down")
    map("t", "<C-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]],    "tmux nav up")
    map("t", "<C-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], "tmux nav right")

    map("n", "[d", function() vim.diagnostic.goto_prev() end, "Previous Diagnostic")
    map("n", "]d", function() vim.diagnostic.goto_next() end, "Next Diagnostic")
end

return M
