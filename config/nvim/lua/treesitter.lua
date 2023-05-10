-- tree sitter config
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "python",
        "css",
        "lua",
        "vim",
        "vimdoc",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "make",
        "sql",
        "yaml",
        "typescript",
        "javascript",
        "java",
        "json",
        "markdown",
        "terraform",
    },
    auto_install = true,
    autotag = {
        enable = true,
    },
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
