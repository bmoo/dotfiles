-- Buffer-local mappings in markdown notes mirror the LSP code-nav keys
-- (<leader>gd, <leader>gr) so the same muscle memory works in notes and code.
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
                local bufnr = ev.buf
                vim.keymap.set("n", "gf", function()
                    return require("obsidian").util.gf_passthrough()
                end, { noremap = false, expr = true, buffer = bufnr })
                vim.keymap.set("n", "<leader>gd", "<cmd>Obsidian follow_link<cr>",
                    { buffer = bufnr, desc = "Follow Wikilink" })
                vim.keymap.set("n", "<leader>gr", "<cmd>Obsidian backlinks<cr>",
                    { buffer = bufnr, desc = "Backlinks" })
            end,
        })
    end,
}
