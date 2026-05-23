-- DAP: adapters, language launch configs, UI. Lazy-loads on :Dap* commands
-- (and on Go ft for nvim-dap-go's filetype integration).

local function configure_dap()
	local dap = require("dap")

	dap.adapters.delve = {
		type = "server",
		port = "${port}",
		executable = {
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}" },
		},
	}

	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{
			type = "delve",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "delve",
			name = "Debug test",
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		-- works with go.mod packages and sub packages
		{
			type = "delve",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}

	require("dapui").setup()
	require("nvim-dap-virtual-text").setup()

	require("mason-nvim-dap").setup({
		ensure_installed = { "python", "delve" },
	})

	require("dap-go").setup({
		dap_configurations = {
			{
				type = "go",
				name = "Attach remote",
				mode = "remote",
				request = "attach",
			},
		},
		delve = {
			initialize_timeout_sec = 20,
			port = "${port}",
		},
	})
end

return {
	{
		"mfussenegger/nvim-dap",
		cmd = {
			"DapToggleBreakpoint", "DapContinue", "DapStepOver", "DapStepInto",
			"DapStepOut", "DapTerminate", "DapRestartFrame", "DapShowLog",
		},
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "mason-org/mason.nvim" },
			},
		},
		config = configure_dap,
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
	},
}
