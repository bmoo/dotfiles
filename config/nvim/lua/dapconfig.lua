local M = {}

M.setup = function()
    -- debugging
    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()
    require("dap-python").setup()

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
            name = "Debug test", -- configuration for debugging test files
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

    -- requires mason to be installed first
    require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve" },
    })

    require("dap-go").setup({
        -- Additional dap configurations can be added.
        -- dap_configurations accepts a list of tables where each entry
        -- represents a dap configuration. For more details do:
        -- :help dap-configuration
        dap_configurations = {
            {
                -- Must be "go" or it will be ignored by the plugin
                type = "go",
                name = "Attach remote",
                mode = "remote",
                request = "attach",
            },
        },
        -- delve configurations
        delve = {
            -- time to wait for delve to initialize the debug session.
            -- default to 20 seconds
            initialize_timeout_sec = 20,
            -- a string that defines the port to start delve debugger.
            -- default to string "${port}" which instructs nvim-dap
            -- to start the process in a random available port
            port = "${port}",
        },
    })
end

return M
