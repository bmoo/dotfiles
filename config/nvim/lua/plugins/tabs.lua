return {{
    'akinsho/bufferline.nvim',
    version = "*",
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
