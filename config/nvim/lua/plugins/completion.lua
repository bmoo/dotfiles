return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*",
		dependencies = {
			"folke/lazydev.nvim",
			"saghen/blink.compat",
		},
		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			keymap = {
				-- Default preset already matches the prior cmp bindings for
				-- <C-n>/<C-p>/<C-y>/<C-e>/<C-space>/<C-f>. The one mismatch
				-- is doc-scroll-up, which the default preset binds to <C-b>;
				-- preserve <C-d> for muscle memory.
				preset = "default",
				["<C-d>"] = { "scroll_documentation_up", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				keyword = { range = "full" },
				list = {
					selection = { preselect = false, auto_insert = false },
				},
				menu = { auto_show = true },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = { enabled = true },
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "buffer", "lazydev" },
				per_filetype = {
					sql = { "dadbod", "buffer" },
					mysql = { "dadbod", "buffer" },
					plsql = { "dadbod", "buffer" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					dadbod = {
						name = "Dadbod",
						module = "blink.compat.source",
						opts = { source_name = "vim-dadbod-completion" },
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}
