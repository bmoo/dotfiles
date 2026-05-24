require("keymap").register({
    { "<leader>gd", "gf",
        ft = "markdown", overrides = true,
        desc = "Follow Link" },
    { "<leader>gr", function()
        Snacks.picker.grep({ search = vim.fn.expand("%:t:r") })
      end,
        ft = "markdown", overrides = true,
        desc = "References to this note" },
})

return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
}
