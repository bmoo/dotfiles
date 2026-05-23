-- Applies the local `claude` colorscheme and keeps vim.o.background in sync
-- with the host terminal, so the light/dark palette follows the terminal.

local M = {}

-- Ask the terminal for its current background via OSC 11. The response
-- arrives async on the TermResponse autocmd below. Inside tmux, wrap the
-- query in a DCS passthrough envelope; otherwise tmux answers OSC 11 itself
-- with its own (white) default instead of forwarding to the outer terminal.
-- Requires `set -g allow-passthrough on` in tmux.conf.
local function query_terminal_bg()
    local q = "\027]11;?\027\\"
    if vim.env.TMUX then
        q = "\027Ptmux;" .. q:gsub("\027", "\027\027") .. "\027\\"
    end
    io.stdout:write(q)
end

function M.setup()
    vim.cmd.colorscheme("claude")

    vim.api.nvim_create_autocmd("TermResponse", {
        callback = function(args)
            -- Neovim 0.11+ delivers the OSC reply as args.data.sequence;
            -- older versions passed the raw string directly.
            local d = args.data
            local seq = (type(d) == "table" and d.sequence)
                or (type(d) == "string" and d)
                or ""
            local r, g, b = seq:match("rgb:(%x+)/(%x+)/(%x+)")
            if not r then return end
            local function norm(h) return tonumber(h, 16) / (16 ^ #h - 1) end
            local luma = 0.299 * norm(r) + 0.587 * norm(g) + 0.114 * norm(b)
            local new_bg = luma > 0.5 and "light" or "dark"
            if vim.o.background ~= new_bg then
                -- Defer the flip out of this autocmd. Setting `background`
                -- makes Neovim auto-reload the colorscheme, which fires
                -- `ColorScheme`/`OptionSet`; those events are suppressed if
                -- triggered from inside a (non-nested) autocmd, so plugins
                -- like barbar and nvim-web-devicons would miss the
                -- reload and keep stale highlights (black tab-icon glyph).
                -- vim.schedule runs the assignment at top level instead.
                vim.schedule(function() vim.o.background = new_bg end)
            end
        end,
    })

    -- Note: do NOT re-source the colorscheme on an OptionSet/background
    -- autocmd. Neovim already re-applies the active colorscheme when
    -- `background` changes, and that automatic reload fires a normal
    -- ColorScheme event. A manual `colorscheme` inside a (non-nested)
    -- OptionSet autocmd reloads it a *second* time, but its ColorScheme
    -- event is suppressed — so claude.lua's `highlight clear` wipes plugin
    -- highlight groups (notably barbar's devicon groups) without
    -- letting the plugins rebuild them. That left a black tab-icon glyph
    -- until the next manual colorscheme change.

    vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
        callback = query_terminal_bg,
    })

    -- Manual toggle for terminals that don't answer OSC 11 (e.g. Secure
    -- Shellfish on iPad). Falls back to flipping by hand.
    vim.api.nvim_create_user_command("ToggleBackground", function()
        vim.o.background = vim.o.background == "dark" and "light" or "dark"
    end, {})
    vim.keymap.set("n", "<leader>bg", "<cmd>ToggleBackground<cr>",
        { desc = "Toggle light/dark background" })
end

return M
