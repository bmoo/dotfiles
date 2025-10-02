local M = {}

function M.setup()
  -- Mason core + mason-lspconfig
  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "pyright",
      "gopls",
    },
  })

  -- (Optional) global diagnostics look & feel
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
  do
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end
end

return M
