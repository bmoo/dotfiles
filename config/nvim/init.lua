-- vim.g is global
vim.g.mapleader = " "

require("lazyconfig").setup()

require("lsp").setup()
require("treesitter")
require("dapconfig").setup()
require("telescopeconfig")

require("config.whichkey").setup()

-- appearance
-- vim.o is options
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "ON"
vim.o.termguicolors = true
vim.o.mouse = "a"

-- tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- color scheme
local ayu = require("ayu")
ayu.setup({
	mirage = true,
})
ayu.colorscheme()

require("indent_blankline").setup({
	-- for example, context is off by default, use this to turn it on
	show_current_context = true,
	show_current_context_start = true,
})

-- auto pairs
require("nvim-autopairs").setup()

local navic = require("nvim-navic")
navic.setup({
	icons = {
		File = " ",
		Module = " ",
		Namespace = " ",
		Package = " ",
		Class = " ",
		Method = " ",
		Property = " ",
		Field = " ",
		Constructor = " ",
		Enum = " ",
		Interface = " ",
		Function = " ",
		Variable = " ",
		Constant = " ",
		String = " ",
		Number = " ",
		Boolean = " ",
		Array = " ",
		Object = " ",
		Key = " ",
		Null = " ",
		EnumMember = " ",
		Struct = " ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
	},
})

-- lua line
require("lualine").setup({
	options = {
		theme = "ayu",
		globalstatus = true,
	},
	sections = {
		lualine_b = {
			"branch",
			"diff",
			{
				"diagnostics",

				-- Table of diagnostic sources, available sources are:
				--   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
				-- or a function that returns a table as such:
				--   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
				sources = { "nvim_diagnostic", "coc" },

				-- Displays diagnostics for the defined severity types
				sections = { "error", "warn", "info", "hint" },

				diagnostics_color = {
					-- Same values as the general color option can be used here.
					error = "DiagnosticError", -- Changes diagnostics' error color.
					warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
					info = "DiagnosticInfo", -- Changes diagnostics' info color.
					hint = "DiagnosticHint", -- Changes diagnostics' hint color.
				},
				symbols = { error = "E", warn = "W", info = "I", hint = "H" },
				colored = true, -- Displays diagnostics status in color if set to true.
				update_in_insert = false, -- Update diagnostics in insert mode.
				always_visible = false, -- Show diagnostics even if there are none.
			},
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				shorting_target = 40,
			},
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
	},
})

-- buffer line
require("bufferline").setup({
	options = {
		numbers = "buffer_id",
		offsets = {
			{
				filetype = "NvimTree",
				text = function()
					return vim.fn.getcwd()
				end,
				highlight = "Directory",
				text_align = "left",
			},
		},
		diagnostics = "nvim_lsp",
	},
})

local nvimtree_attach = function(bufnr)
	local api = require("nvim-tree.api")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
end

-- nvim-tree config
require("nvim-tree").setup({
	sync_root_with_cwd = true,
	sort_by = "case_sensitive",
	on_attach = nvimtree_attach,
	view = {
		adaptive_size = true,
	},
	renderer = {
		group_empty = true,
		highlight_opened_files = "all",
		symlink_destination = false,
	},
	filters = {
		dotfiles = false,
	},
})

-- dark mode
local auto_dark_mode = require("auto-dark-mode")
auto_dark_mode.setup({
	set_dark_mode = function()
		vim.o.background = "dark"
	end,
	set_light_mode = function()
		if os.getenv("DARK") then
			vim.o.background = "dark"
		else
			vim.o.background = "light"
		end
	end,
})
auto_dark_mode.init()
