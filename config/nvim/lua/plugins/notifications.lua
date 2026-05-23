return {
    "folke/noice.nvim",
    event = "VeryLazy", -- Load after startup
    dependencies = {"MunifTanjim/nui.nvim", "folke/snacks.nvim"},
    opts = {
        -- Let snacks.notifier own vim.notify; noice would otherwise wrap it
        -- and the two fight on startup.
        notify = { enabled = false },
        messages = {
            enabled = true,
            view = "notify", -- default view for messages
            view_error = "notify", -- view for errors
            view_warn = "notify", -- view for warnings
            view_history = "messages", -- view for :messages
            view_search = "virtualtext" -- view for search count messages. Set to `false` to disable
        },
        presets = {
            inc_rename = true,
            command_palette = true,
            long_message_to_split = true,
            lsp_doc_border = true
        }
    }
}
