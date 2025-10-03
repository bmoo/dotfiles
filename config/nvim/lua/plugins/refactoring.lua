return {
    "ThePrimeagen/refactoring.nvim",
    keys = {
        { "<leader>r", mode = { "n", "v" }, desc = "Refactor" }, -- Load when using refactor keymaps
    },
    dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
    opts = {}
}