-- refactoring.nvim's functions return a string (a normal-mode command
-- sequence). Combined with `expr = true`, Neovim feeds the returned string
-- back as the keypress. That's why these are wrapped in a function that
-- returns the call.
local function call(method)
	return function() return require("refactoring")[method]() end
end

return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = { "lewis6991/async.nvim" },
	opts = {},
	keys = {
		{ "<leader>re", call("extract_func"),         mode = { "n", "x" }, expr = true, desc = "Extract Function" },
		{ "<leader>rf", call("extract_func_to_file"), mode = { "n", "x" }, expr = true, desc = "Extract Function to File" },
		{ "<leader>rv", call("extract_var"),          mode = { "n", "x" }, expr = true, desc = "Extract Variable" },
		{ "<leader>rI", call("inline_func"),          mode = { "n", "x" }, expr = true, desc = "Inline Function" },
		{ "<leader>ri", call("inline_var"),           mode = { "n", "x" }, expr = true, desc = "Inline Variable" },
	},
}
