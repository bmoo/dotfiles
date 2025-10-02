local shared = require("sharedlsp")

vim.lsp.config('lua_ls', {
  on_attach = shared.on_attach,
  capabilities = shared.capabilities,
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
