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
end


return M
