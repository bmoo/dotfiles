
local M = {}

M.capabilities = (function()
  local c = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  return ok and cmp.default_capabilities(c) or c
end)()

function M.on_attach(client, bufnr)
  local map = function(m, l, r) vim.keymap.set(m, l, r, { buffer = bufnr, silent = true }) end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
end

return M