return {{
    "romgrk/barbar.nvim",
    version = "^1.0.0",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    config = function()
        require("barbar").setup({
            animation = false,
            icons = {
                buffer_number = true, -- nvim's internal buffer id, like the old `numbers = "buffer_id"`
                buffer_index = false,
                filetype = { enabled = true },
                separator = { left = "▎", right = "" },
                modified = { button = "●" },
                pinned = { button = "" },
                diagnostics = {
                    [vim.diagnostic.severity.ERROR] = { enabled = true },
                    [vim.diagnostic.severity.WARN]  = { enabled = true },
                    [vim.diagnostic.severity.INFO]  = { enabled = false },
                    [vim.diagnostic.severity.HINT]  = { enabled = false },
                },
            },
            sidebar_filetypes = {
                ["neo-tree"]        = { event = "BufWinLeave", align = "right" },
                ["snacks_terminal"] = { event = "BufWinLeave", align = "left" },
            },
        })

        -- Pull the palette live from the active colorscheme so light/dark
        -- flips track. Current tab sits on the editor bg in coral; every
        -- other tab recedes into the gray bar.
        local function build()
            local function get(name)
                return vim.api.nvim_get_hl(0, { name = name, link = false })
            end
            local function hex(n) return n and string.format("#%06x", n) or nil end
            local normal   = get("Normal")
            local coral    = hex(get("Keyword").fg)
            local text     = hex(normal.fg)
            local editorbg = hex(normal.bg)
            local dim      = hex(get("Comment").fg)
            local subtle   = hex(get("LineNr").fg)
            local recessed = hex(get("Pmenu").bg)
            local modified = hex(get("DiagnosticWarn").fg)

            return {
                BufferCurrent        = { fg = coral,    bg = editorbg, bold = true },
                BufferCurrentNumber  = { fg = coral,    bg = editorbg, bold = true },
                BufferCurrentMod     = { fg = modified, bg = editorbg, bold = true },
                BufferCurrentSign    = { fg = coral,    bg = editorbg },
                BufferCurrentTarget  = { fg = coral,    bg = editorbg, bold = true },
                BufferCurrentIcon    = { bg = editorbg },

                BufferVisible        = { fg = text,     bg = recessed },
                BufferVisibleNumber  = { fg = dim,      bg = recessed },
                BufferVisibleMod     = { fg = modified, bg = recessed },
                BufferVisibleSign    = { fg = subtle,   bg = recessed },
                BufferVisibleTarget  = { fg = text,     bg = recessed, bold = true },
                BufferVisibleIcon    = { bg = recessed },

                BufferInactive       = { fg = dim,      bg = recessed },
                BufferInactiveNumber = { fg = subtle,   bg = recessed },
                BufferInactiveMod    = { fg = modified, bg = recessed },
                BufferInactiveSign   = { fg = subtle,   bg = recessed },
                BufferInactiveTarget = { fg = text,     bg = recessed, bold = true },
                BufferInactiveIcon   = { bg = recessed },

                BufferTabpages       = { fg = subtle,   bg = recessed },
                BufferTabpageFill    = { fg = subtle,   bg = recessed },
                BufferOffset         = { fg = coral,    bg = recessed, bold = true },
            }
        end

        local function apply()
            for name, spec in pairs(build()) do
                vim.api.nvim_set_hl(0, name, spec)
            end
        end

        apply()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("ClaudeBarbar", { clear = true }),
            callback = apply,
        })
    end,
}}
