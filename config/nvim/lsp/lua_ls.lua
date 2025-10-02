vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
  Lua = {
	  runtime = { version = 'LuaJIT' },
	  diagnostics = {
		  globals = { 'vim' },
		  disable = { 'need-check-nil' },
	  },
	  workspace = {
		  checkThirdParty = false,
		  library = vim.api.nvim_get_runtime_file('', true),
	  },
	  telemetry = { enable = false },
  },  },
})
