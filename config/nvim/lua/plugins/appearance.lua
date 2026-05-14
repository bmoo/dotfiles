return {
    {
        "Shatur/neovim-ayu",
        lazy = false,
        priority = 1000,
        config = function()
            local ayu = require("ayu")
            ayu.setup({ mirage = true, terminal = false })

            -- Ask the terminal for its current background via OSC 11.
            -- Response arrives async on the TermResponse autocmd below.
            -- Inside tmux, wrap in a DCS passthrough envelope; otherwise
            -- tmux answers OSC 11 itself with its own (white) default
            -- instead of forwarding to the outer terminal.
            -- Requires `set -g allow-passthrough on` in tmux.conf.
            local function query_terminal_bg()
                local q = "\027]11;?\027\\"
                if vim.env.TMUX then
                    q = "\027Ptmux;" .. q:gsub("\027", "\027\027") .. "\027\\"
                end
                io.stdout:write(q)
            end

            vim.api.nvim_create_autocmd("TermResponse", {
                callback = function(args)
                    local seq = type(args.data) == "string" and args.data or ""
                    local r, g, b = seq:match("rgb:(%x+)/(%x+)/(%x+)")
                    if not r then return end
                    local function norm(h) return tonumber(h, 16) / (16 ^ #h - 1) end
                    local luma = 0.299 * norm(r) + 0.587 * norm(g) + 0.114 * norm(b)
                    local new_bg = luma > 0.5 and "light" or "dark"
                    if vim.o.background ~= new_bg then
                        vim.o.background = new_bg
                    end
                end,
            })

            vim.api.nvim_create_autocmd("OptionSet", {
                pattern = "background",
                callback = function() ayu.colorscheme() end,
            })

            vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
                callback = query_terminal_bg,
            })

            -- Manual toggle for terminals that don't answer OSC 11 (e.g.
            -- Secure Shellfish on iPad). Falls back to flipping by hand
            -- when auto-detection isn't possible.
            vim.api.nvim_create_user_command("ToggleBackground", function()
                vim.o.background = vim.o.background == "dark" and "light" or "dark"
            end, {})
            vim.keymap.set("n", "<leader>tb", "<cmd>ToggleBackground<cr>",
                { desc = "Toggle light/dark background" })

            ayu.colorscheme()
        end,
    },
}
