return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        require("keymap").register_groups_with_wk()
    end,
}
