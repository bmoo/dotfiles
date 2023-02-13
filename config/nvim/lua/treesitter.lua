-- tree sitter config
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "vim", "help", "go" },
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    },
    indent = {
        enable = true,
    },
})
