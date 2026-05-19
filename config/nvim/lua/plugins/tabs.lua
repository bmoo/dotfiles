return {{
    'akinsho/bufferline.nvim',
    version = "*",
    event = "VeryLazy", -- Load bufferline slightly after startup
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local bufferline = require("bufferline")

        local options = {
            numbers = "buffer_id",
            offsets = {{
                filetype = "NvimTree",
                text = function() return vim.fn.getcwd() end,
                highlight = "Directory",
                text_align = "left",
            }},
            diagnostics = "nvim_lsp",
        }

        -- Read the live `claude` palette. The selected buffer sits on the
        -- editor background in coral; every other tab recedes into a gray
        -- bar. Reading from the colorscheme means this tracks light/dark.
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
                fill                  = { bg = recessed },
                background            = { fg = dim,      bg = recessed },
                buffer_visible        = { fg = text,     bg = recessed },
                buffer_selected       = { fg = coral,    bg = editorbg, bold = true, italic = false },
                numbers               = { fg = subtle,   bg = recessed },
                numbers_visible       = { fg = dim,      bg = recessed },
                numbers_selected      = { fg = coral,    bg = editorbg, bold = true, italic = false },
                close_button          = { fg = subtle,   bg = recessed },
                close_button_visible  = { fg = dim,      bg = recessed },
                close_button_selected = { fg = coral,    bg = editorbg },
                modified              = { fg = modified, bg = recessed },
                modified_visible      = { fg = modified, bg = recessed },
                modified_selected     = { fg = modified, bg = editorbg },
                duplicate             = { fg = dim,      bg = recessed, italic = true },
                duplicate_visible     = { fg = dim,      bg = recessed, italic = true },
                duplicate_selected    = { fg = coral,    bg = editorbg, italic = true },
                separator             = { fg = subtle,   bg = recessed },
                separator_visible     = { fg = subtle,   bg = recessed },
                separator_selected    = { fg = subtle,   bg = editorbg },
                indicator_visible     = { fg = recessed, bg = recessed },
                indicator_selected    = { fg = coral,    bg = editorbg },
                offset_separator      = { fg = subtle,   bg = recessed },
                trunc_marker          = { fg = dim,      bg = recessed },
            }
        end

        -- highlights key (buffer_selected) -> group name (BufferLineBufferSelected)
        local function group_name(key)
            return "BufferLine" .. (key:gsub("_(%l)", string.upper):gsub("^%l", string.upper))
        end

        local function apply()
            local hls = build()
            -- Feed bufferline its colors so it derives the filetype-icon
            -- highlights from the same table — an icon's background then
            -- always matches the rest of its tab.
            bufferline.setup({ options = options, highlights = hls })
            -- bufferline registers its groups as `default` highlights, which
            -- a later colorscheme change cannot overwrite. Re-assert them as
            -- hard highlights so the light/dark flip actually takes.
            for key, spec in pairs(hls) do
                vim.api.nvim_set_hl(0, group_name(key), spec)
            end
        end

        apply()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("ClaudeBufferline", { clear = true }),
            callback = apply,
        })
    end,
}}
