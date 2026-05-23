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
                require("keymaps").attach_markdown(ev.buf)
            end,
        })
    end,
}
