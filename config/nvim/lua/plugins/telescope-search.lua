return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- Load when running Telescope command
    keys = {
        { "<leader>f", desc = "Telescope" }, -- Load when using telescope keymaps
    },
    dependencies = {"nvim-lua/plenary.nvim", "sharkdp/fd", "BurntSushi/ripgrep"}
}