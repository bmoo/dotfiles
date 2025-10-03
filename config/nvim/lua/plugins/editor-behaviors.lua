return {
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter", -- Load when entering insert mode for tag editing
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" }, -- Load when opening files
    },
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename", -- Load when running the IncRename command
        opts = {}
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- Load when entering insert mode
    }
}
