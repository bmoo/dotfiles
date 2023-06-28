local M = {}

local whichkey = require("which-key")

local conf = {
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
	},
}
whichkey.setup(conf)

local opts = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
	local keymap = {
		b = {
			name = "Buffer",
			l = { "<Cmd>blast<Cr>", "Last Buffer" },
			f = { "<Cmd>bfirst<Cr>", "First Buffer" },
			p = { "<Cmd>bprevious<Cr>", "Previous Buffer" },
			n = { "<Cmd>bnext<Cr>", "Next Buffer" },
			F = { "<Cmd>BDelete! this<Cr>", "Force Close Buffer" },
			D = { "<Cmd>BWipeout other<Cr>", "Delete All Buffers" },
			b = { "<Cmd>BufferLinePick<Cr>", "Pick a Buffer" },
		},

		["r"] = { "<Cmd>lua vim.lsp.buf.rename()<Cr>", "Rename" },

		-- Database
		D = {
			name = "Database",
			u = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
			f = { "<Cmd>DBUIFindBuffer<Cr>", "Find buffer" },
			r = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
			q = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
		},

		f = {
			name = "Telescope",
			f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
			g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
			b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Find Buffer" },
			h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Find Help" },
		},

		["t"] = { "<cmd>NvimTreeToggle<cr>", "File Tree" },

		g = {
			name = "LSP",
			D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declarations" },
			d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation" },
			K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover text" },
			R = { "<cmd>lua vim.lsp.buf.references()<cr>", "Show references" },
			F = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format code" },
			c = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions" },
			r = { "<cmd>TroubleToggle lsp_references<cr>", "Trouble LSP References" },
		},

		x = {
			name = "Trouble",
			x = { "<cmd>TroubleToggle<cr>", "Toggle" },
			w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
			d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
			q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
			l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
		},
		h = {
			name = "Gitsigns",
			s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
			r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
			S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
			u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
			R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
			p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
			b = { '<cmd>lua require"gitsigns".blame_line{full=true}<cr>', "Blame Line" },
			d = { "<cmd>Gitsigns diffthis<cr>", "Diff This" },
			D = { '<cmd>lua require"gitsigns".diffthis{"~"}<cr>', "Lua Diff This" },
		},
		d = {
			name = "Debug",
			R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
			E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
			C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
			U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
			b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
			c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
			d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
			e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
			g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
			h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
			S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
			i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
			o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
			p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
			q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
			r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
			s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
			t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
			x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
			u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
		},
	}

	whichkey.register(keymap, opts)
end

local visual_opts = {
	mode = "v", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local function visual_keymap()
	local keymap = {
		name = "Gitsigns",
		h = {
			s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
			r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
		},
	}

	whichkey.register(keymap, visual_opts)
end

function M.setup()
	normal_keymap()
	visual_keymap()
end

return M
