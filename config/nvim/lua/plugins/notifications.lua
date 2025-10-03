return {
    "folke/noice.nvim",
    dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"},
    opts = {
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
