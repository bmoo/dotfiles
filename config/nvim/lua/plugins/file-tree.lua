return {{
    "nvim-tree/nvim-tree.lua",
    dependencies = {'nvim-tree/nvim-web-devicons'},
    opts = {
        sync_root_with_cwd = true,
        sort_by = "case_sensitive",
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return {
                    desc = "nvim-tree: " .. desc,
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true
                }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
            vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
            vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
        end,
        view = {
            adaptive_size = true
        },
        renderer = {
            group_empty = true,
            highlight_opened_files = "all",
            symlink_destination = false
        },
        filters = {
            dotfiles = false
        }
    }
}}
