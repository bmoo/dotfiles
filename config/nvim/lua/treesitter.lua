-- nvim-treesitter (main branch — full rewrite of the legacy `master` API).
-- Setup is intentionally minimal: install parsers, then enable highlight /
-- indent / fold per buffer via a FileType autocmd.

local nts = require("nvim-treesitter")

nts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Equivalent of legacy `ensure_installed`. Async; no-op if already installed.
nts.install({
	"bash",
	"python",
	"css",
	"lua",
	"vim",
	"vimdoc",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"make",
	"sql",
	"swift",
	"yaml",
	"typescript",
	"javascript",
	"java",
	"json",
	"markdown",
	"terraform",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		if not pcall(vim.treesitter.start, ev.buf) then
			return
		end
		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
	end,
})
