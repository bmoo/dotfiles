require("keymap").register({
    { "<leader>Gh", "<cmd>DiffviewFileHistory<cr>",                       desc = "Repo History",        group = "git", lazy = true, plugin = "diffview" },
    { "<leader>Gf", "<cmd>DiffviewFileHistory %<cr>",                     desc = "File History",        group = "git", lazy = true, plugin = "diffview" },
    { "<leader>Gb", "<cmd>DiffviewFileHistory --range=HEAD~20..HEAD<cr>", desc = "Branch History (20)", group = "git", lazy = true, plugin = "diffview" },
    { "<leader>Go", "<cmd>DiffviewOpen<cr>",                              desc = "Open Diff vs Index",  group = "git", lazy = true, plugin = "diffview" },
    { "<leader>GO", "<cmd>DiffviewOpen HEAD~1<cr>",                       desc = "Open Diff vs HEAD~1", group = "git", lazy = true, plugin = "diffview" },
    { "<leader>Gm", "<cmd>DiffviewOpen origin/main...HEAD<cr>",           desc = "Diff vs origin/main", group = "git", lazy = true, plugin = "diffview" },
    { "<leader>Gc", "<cmd>DiffviewClose<cr>",                             desc = "Close Diffview",      group = "git", lazy = true, plugin = "diffview" },
})

return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewRefresh" },
    keys = require("keymap").lazy_for("diffview"),
    opts = {
        enhanced_diff_hl = true,
        view = {
            merge_tool = { layout = "diff3_mixed" },
        },
        file_panel = {
            listing_style = "tree",
            win_config = { position = "left", width = 35 },
        },
        keymaps = {
            view = {
                { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            },
            file_panel = {
                { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            },
            file_history_panel = {
                { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            },
        },
    },
}
