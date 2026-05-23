-- Owns the global LSP attach lifecycle: capabilities, on_attach (inlay hints,
-- codelens, navic), and the vim.lsp.config('*') wiring. Per-language settings
-- live in lsp/<server>.lua and are merged on top by Neovim.
--
-- LSP keymaps live in the registry as global eager entries (they no-op safely
-- in buffers with no LSP attached). The on_attach hook only turns features on
-- when the attached server actually supports them.
--
-- mason-lspconfig auto-enables servers in its ensure_installed list; non-mason
-- servers (e.g. sourcekit) need an explicit vim.lsp.enable here.

local M = {}

M.capabilities = (function()
    local c = vim.lsp.protocol.make_client_capabilities()
    local ok, blink = pcall(require, "blink.cmp")
    return ok and blink.get_lsp_capabilities(c) or c
end)()

local function pick(name) return function() Snacks.picker[name]() end end

require("keymap").register({
    { "<leader>gd", pick("lsp_definitions"),      desc = "Go to Definition",      group = "lsp" },
    { "<leader>gr", pick("lsp_references"),       desc = "Find References",       group = "lsp" },
    { "<leader>gi", pick("lsp_implementations"),  desc = "Go to Implementation",  group = "lsp" },
    { "<leader>gy", pick("lsp_type_definitions"), desc = "Go to Type Definition", group = "lsp" },
    { "<leader>gD", vim.lsp.buf.declaration,      desc = "Go to Declaration",     group = "lsp" },
    { "<leader>lh", function()
        local bufnr = 0
        vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
            { bufnr = bufnr })
    end, desc = "Toggle Inlay Hints", group = "lsp" },
    { "<leader>ll", vim.lsp.codelens.run, desc = "Run Code Lens", group = "lsp" },
})

function M.on_attach(client, bufnr)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end
    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
end

function M.setup()
    vim.lsp.config("*", {
        capabilities = M.capabilities,
        on_attach    = M.on_attach,
    })
    vim.lsp.enable("sourcekit")
end

return M
