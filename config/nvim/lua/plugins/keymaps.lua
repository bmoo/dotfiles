return {
    "folke/which-key.nvim",
    opts = function()
        local whichkey = require("which-key")

        whichkey.add({{
            "<leader>b",
            group = "Buffer"
        }, {
            "<leader>bl",
            "<Cmd>blast<Cr>",
            desc = "Last Buffer"
        }, {
            "<leader>bf",
            "<Cmd>bfirst<Cr>",
            desc = "First Buffer"
        }, {
            "<leader>bp",
            "<Cmd>bprevious<Cr>",
            desc = "Previous Buffer"
        }, {
            "<leader>bn",
            "<Cmd>bnext<Cr>",
            desc = "Next Buffer"
        }, {
            "<leader>bb",
            "<Cmd>BufferLinePick<Cr>",
            desc = "Pick a Buffer"
        }, {
            "<leader>r",
            group = "Refactor"
        },
        {
            "<leader>rn",
            "<Cmd>IncRename<Cr>",
            desc = "Rename"
        },
        -- Telescope
        {
            "<leader>f",
            group = "Telescope"
        }, {
            "<leader>ff",
            "<cmd>lua require('telescope.builtin').find_files()<cr>",
            desc = "Find Files"
        }, {
            "<leader>fg",
            "<cmd>lua require('telescope.builtin').live_grep()<cr>",
            desc = "Live Grep"
        }, {
            "<leader>fb",
            "<cmd>lua require('telescope.builtin').buffers()<cr>",
            desc = "Find Buffer"
        }, {
            "<leader>fh",
            "<cmd>lua require('telescope.builtin').help_tags()<cr>",
            desc = "Find Help"
        }, {
            "<leader>t",
            "<cmd>NvimTreeToggle<cr>",
            desc = "File Tree"
        }, {
            "<leader>g",
            group = "LSP"
        }, {
            "<leader>gD",
            "<cmd>lua vim.lsp.buf.declaration()<cr>",
            desc = "Go to Declarations"
        }, {
            "<leader>gd",
            "<cmd>lua vim.lsp.buf.definition()<cr>",
            desc = "Go to Definition"
        }, {
            "<leader>gi",
            "<cmd>lua vim.lsp.buf.implementation()<cr>",
            desc = "Go to Implementation"
        }, {
            "<leader>q",
            "<cmd>lclose<bar>cclose<cr>",
            desc = "Close loclist/quickfix"
        }})

    end
}
