return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile", "BufWritePost" },
	config = function()
		require("lint").linters_by_ft = {
			python = { "ruff" },
			go = { "golangci_lint" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
			callback = function()
				-- silently skip if a linter isn't installed yet
				pcall(function() require("lint").try_lint() end)
			end,
		})
	end,
}
