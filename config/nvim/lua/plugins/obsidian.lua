-- Buffer-local mappings in markdown notes mirror the LSP code-nav keys
-- (<leader>gd, <leader>gr) so the same muscle memory works in notes and code.
-- The leader pair are registered as ft-scoped overrides; `gf` (not leader-
-- scoped) stays as a raw FileType binding inside config.

local function follow_or(fallback)
    return function()
        if require("obsidian.api").cursor_link() then
            return "<cmd>Obsidian follow_link<cr>"
        end
        return fallback
    end
end

require("keymap").register({
    { "<leader>gd", follow_or("gf"),
        ft = "markdown", overrides = true, expr = true, noremap = false,
        desc = "Follow Link", group = "obsidian" },
    { "<leader>gr", "<cmd>Obsidian backlinks<cr>",
        ft = "markdown", overrides = true,
        desc = "Backlinks", group = "obsidian" },
})

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        workspaces = {
            {
                name = "campaign",
                path = "~/dev/campaignbot/campaign",
            },
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        legacy_commands = false,
        ui = { enable = false },
    },
    config = function(_, opts)
        require("obsidian").setup(opts)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function(ev)
                vim.keymap.set("n", "gf", follow_or("gf"),
                    { noremap = false, expr = true, buffer = ev.buf })
            end,
        })
    end,
}
