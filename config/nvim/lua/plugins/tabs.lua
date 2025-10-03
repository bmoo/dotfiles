return {{
    'akinsho/bufferline.nvim',
    version = "*",
    event = "VeryLazy", -- Load bufferline slightly after startup
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            numbers = "buffer_id",
            offsets = {{
                filetype = "NvimTree",
                text = function()
                    return vim.fn.getcwd()
                end,
                highlight = "Directory",
                text_align = "left"
            }},
            diagnostics = "nvim_lsp"
        }
    }
}}
