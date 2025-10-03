
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

  vim.keymap.set({ "n", "x" }, "<leader>re", function() return require('refactoring').refactor('Extract Function') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>rf", function() return require('refactoring').refactor('Extract Function To File') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>rv", function() return require('refactoring').refactor('Extract Variable') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>rI", function() return require('refactoring').refactor('Inline Function') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>ri", function() return require('refactoring').refactor('Inline Variable') end, { expr = true })

vim.keymap.set({ "n", "x" }, "<leader>rbb", function() return require('refactoring').refactor('Extract Block') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>rbf", function() return require('refactoring').refactor('Extract Block To File') end, { expr = true })

  -- TODO can this reference be cached?
  local navic = require("nvim-navic")
  navic.attach(client, bufnr)
end

return M