-- Plugin spec only. Runtime config (parser install + per-buffer enable) lives
-- in lua/treesitter.lua, which is required at startup from init.lua.
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false, -- the main branch doesn't support lazy-loading
	build = ":TSUpdate",
}
