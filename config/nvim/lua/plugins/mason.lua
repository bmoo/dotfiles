return {{
    "mason-org/mason.nvim",
    opts = {}
}, {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {{
        "mason-org/mason.nvim",
        opts = {}
    }, "neovim/nvim-lspconfig"},
    opts = {
        ensure_installed = {"lua_ls", "pyright", "gopls", "ruff"},
        automatic_enable = true
    }
}}
