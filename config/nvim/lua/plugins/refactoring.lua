-- refactoring.nvim's functions return a string (a normal-mode command
-- sequence). Combined with `expr = true`, Neovim feeds the returned string
-- back as the keypress. That's why these are wrapped in a function that
-- returns the call.
local function call(method)
    return function() return require("refactoring")[method]() end
end

require("keymap").register({
    { "<leader>re", call("extract_func"),         mode = { "n", "x" }, expr = true, desc = "Extract Function",         group = "refactor", lazy = true, plugin = "refactoring" },
    { "<leader>rf", call("extract_func_to_file"), mode = { "n", "x" }, expr = true, desc = "Extract Function to File", group = "refactor", lazy = true, plugin = "refactoring" },
    { "<leader>rv", call("extract_var"),          mode = { "n", "x" }, expr = true, desc = "Extract Variable",         group = "refactor", lazy = true, plugin = "refactoring" },
    { "<leader>rI", call("inline_func"),          mode = { "n", "x" }, expr = true, desc = "Inline Function",          group = "refactor", lazy = true, plugin = "refactoring" },
    { "<leader>ri", call("inline_var"),           mode = { "n", "x" }, expr = true, desc = "Inline Variable",          group = "refactor", lazy = true, plugin = "refactoring" },
})

return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim" },
    opts = {},
    keys = require("keymap").lazy_for("refactoring"),
}
