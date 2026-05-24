require("keymap").register({
    { "<leader>t", "<cmd>Neotree toggle<cr>", desc = "File Tree", lazy = true, plugin = "neo-tree" },
})

return {{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = require("keymap").lazy_for("neo-tree"),
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        close_if_last_window = true,
        filesystem = {
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
            },
        },
        window = {
            position = "right",
            width = 30,
            mappings = {
                ["u"] = "navigate_up",
                ["v"] = "open_vsplit",
                ["s"] = "open_split",
            },
        },
        default_component_configs = {
            indent = { with_markers = true },
            git_status = { symbols = { unstaged = "", staged = "" } },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "neo-tree",
            group = vim.api.nvim_create_augroup("NeoTreeFixedWidth", { clear = true }),
            callback = function(args)
                vim.wo[vim.fn.bufwinid(args.buf)].winfixwidth = true
            end,
        })
    end,
}}
