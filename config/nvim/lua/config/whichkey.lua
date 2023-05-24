local M = {}

local whichkey = require("which-key")

local conf = {
    window = {
        border = "single",   -- none, single, double, shadow
        position = "bottom", -- bottom, top
    },
}
whichkey.setup(conf)

local opts = {
    mode = "n",     -- Normal mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
    local keymap = {
        b = {
            name = "Buffer",
            l = { "<Cmd>blast<Cr>", "Last Buffer" },
            f = { "<Cmd>bfirst<Cr>", "First Buffer" },
            p = { "<Cmd>bprevious<Cr>", "Previous Buffer" },
            n = { "<Cmd>bnext<Cr>", "Next Buffer" },
            F = { "<Cmd>BDelete! this<Cr>", "Force Close Buffer" },
            D = { "<Cmd>BWipeout other<Cr>", "Delete All Buffers" },
            b = { "<Cmd>BufferLinePick<Cr>", "Pick a Buffer" },
        },

        r = {
            name = "Refactor",
            n = { "<Cmd>IncRename<Cr>", "Rename" },
        },

        -- Database
        D = {
            name = "Database",
            u = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
            f = { "<Cmd>DBUIFindBuffer<Cr>", "Find buffer" },
            r = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
            q = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
        },

        f = {
            name = "Telescope",
            f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
            g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
            b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Find Buffer" },
            h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Find Help" },
        },

        ["t"] = { "<cmd>NvimTreeToggle<cr>", "File Tree" },
    }

    whichkey.register(keymap, opts)
end

function M.setup()
    normal_keymap()
end

return M
