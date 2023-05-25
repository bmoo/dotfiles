local M = {}

local whichkey = require("which-key")

local conf = {
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
    },
}
whichkey.setup(conf)

local opts = {
    mode = "n",  -- Normal mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
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

        g = {
            name = "LSP",
            D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declarations" },
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
            i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation" },
            K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover text" },
            r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Show references" },
            F = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format code" },
        },
        --         vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        --         vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        --         vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        --         vim.keymap.set("n", "<space>wl", function()
        --             print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --         end, bufopts)
        --         vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        --         -- is this a duplicate?
        --         vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        --
        --         vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
        --         vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
        --         vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)

        --         vim.keymap.set("n", "<F5>", function()
        --             -- start or continue debugging
        --             require("dap").continue()
        --         end)
        --         vim.keymap.set("n", "<F10>", function()
        --             require("dap").step_over()
        --         end)
        --         vim.keymap.set("n", "<F11>", function()
        --             require("dap").step_into()
        --         end)
        --         vim.keymap.set("n", "<F12>", function()
        --             require("dap").step_out()
        --         end)
        --         vim.keymap.set("n", "<Leader>b", function()
        --             require("dap").toggle_breakpoint()
        --         end)
        --         vim.keymap.set("n", "<Leader>B", function()
        --             require("dap").set_breakpoint()
        --         end)
        --         vim.keymap.set("n", "<Leader>lp", function()
        --             require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        --         end)
        --         vim.keymap.set("n", "<Leader>dr", function()
        --             require("dap").repl.open()
        --         end)
        --         vim.keymap.set("n", "<Leader>dl", function()
        --             require("dap").run_last()
        --         end)
        --         vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
        --             require("dap.ui.widgets").hover()
        --         end)
        --         vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
        --             require("dap.ui.widgets").preview()
        --         end)
        --         vim.keymap.set("n", "<Leader>df", function()
        --             local widgets = require("dap.ui.widgets")
        --             widgets.centered_float(widgets.frames)
        --         end)
        --         vim.keymap.set("n", "<Leader>ds", function()
        --             local widgets = require("dap.ui.widgets")
        --             widgets.centered_float(widgets.scopes)
        --         end)
        --
    }

    whichkey.register(keymap, opts)
end

function M.setup()
    normal_keymap()
end

return M
