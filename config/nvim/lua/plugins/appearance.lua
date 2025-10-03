return {
    {
        "Shatur/neovim-ayu",
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
