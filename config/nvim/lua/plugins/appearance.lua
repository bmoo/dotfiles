return {
    {
        "Shatur/neovim-ayu",
        lazy = false, -- Load colorscheme immediately at startup
        priority = 1000, -- Ensure it loads before other plugins
        config = function()
            local ayuLocal = require("ayu")

            ayuLocal.setup({
                mirage = true,
                terminal = false,
            })
            ayuLocal.colorscheme()
        end,
     },
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false, -- Load immediately for dark mode detection
        priority = 999, -- Load right after colorscheme
        opts = {
            set_dark_mode = function()
                vim.o.background = "dark"
            end,
            set_light_mode = function()
                if os.getenv("DARK") then
                    vim.o.background = "dark"
                else
                    vim.o.background = "light"
                end
            end
        }
    }
}
