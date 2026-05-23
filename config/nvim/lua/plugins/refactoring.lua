local function refactor(name)
    return function() return require("refactoring").refactor(name) end
end

return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
        { "<leader>re",  refactor("Extract Function"),         mode = { "n", "x" }, expr = true, desc = "Extract Function" },
        { "<leader>rf",  refactor("Extract Function To File"), mode = { "n", "x" }, expr = true, desc = "Extract Function to File" },
        { "<leader>rv",  refactor("Extract Variable"),         mode = { "n", "x" }, expr = true, desc = "Extract Variable" },
        { "<leader>rI",  refactor("Inline Function"),          mode = { "n", "x" }, expr = true, desc = "Inline Function" },
        { "<leader>ri",  refactor("Inline Variable"),          mode = { "n", "x" }, expr = true, desc = "Inline Variable" },
        { "<leader>rbb", refactor("Extract Block"),            mode = { "n", "x" }, expr = true, desc = "Extract Block" },
        { "<leader>rbf", refactor("Extract Block To File"),    mode = { "n", "x" }, expr = true, desc = "Extract Block to File" },
    },
    opts = {},
}
