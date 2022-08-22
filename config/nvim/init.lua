require("packer_init")

vim.g.mapleader = ","

-- appearance
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "ON"
vim.o.termguicolors = true
vim.o.background = "light"
vim.o.mouse = "a"

-- tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- color scheme
require("ayu").colorscheme()

-- file browser
require("nvim-tree").setup()

-- lua line
require("lualine").setup({
  options = {
    theme = "ayu",
    globalstatus = true,
  },
  sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
        shorting_target = 40,
      },
    },
  },
})

-- buffer line
require("bufferline").setup({
    options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = "Directory",
        text_align = "left"
      }
    }
}
})

-- mason config
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
    },
  },
})
require("mason-lspconfig").setup({
  ensure_installed = { "sumneko_lua" },
})

-- nvim-tree config
vim.keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>")
require("nvim-tree").setup({
  sync_root_with_cwd = true,
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "v", action = "vsplit" },
        { key = "s", action = "split" },
      },
    },
  },
  renderer = {
    group_empty = true,
    highlight_opened_files = "all",
    symlink_destination = false,
  },
  filters = {
    dotfiles = false,
  },
})

-- dark mode
local auto_dark_mode = require("auto-dark-mode")

auto_dark_mode.setup({
  set_dark_mode = function()
    vim.api.nvim_set_option("background", "dark")
    --		vim.cmd('colorscheme ayu')
  end,
  set_light_mode = function()
    vim.api.nvim_set_option("background", "light")
    --		vim.cmd('colorscheme ayu')
  end,
})
auto_dark_mode.init()

-- completion
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
  completion = {
    keyword_length = 3,
  },
  performance = {
    debounce = 300,
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<c-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<c-space>"] = cmp.mapping.complete(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" }, -- For luasnip users.
  }, {
    { name = "buffer" },
  }),
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      },
    }),
  },
})

-- python
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- telescope
require("telescope").setup({
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
})

vim.keymap.set("n", "ff", require("telescope.builtin").find_files, opts)
vim.keymap.set("n", "fg", require("telescope.builtin").live_grep, opts)
vim.keymap.set("n", "fb", require("telescope.builtin").buffers, opts)
vim.keymap.set("n", "fh", require("telescope.builtin").help_tags, opts)

-- lsp is built in to neovim but the config is external
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.completion.spell,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- seq_sync picks the first language server it finds
          vim.lsp.buf.formatting_seq_sync()
        end,
      })
    end
  end,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
end

local nvim_lsp = require("lspconfig")
nvim_lsp.pyright.setup({
  on_attach = on_attach,
})

nvim_lsp.tsserver.setup({
  on_attach = on_attach,
})

nvim_lsp.gopls.setup({
  cmd = { "gopls" },
  on_attach = on_attach,
})

nvim_lsp.sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
        disable = { "need-check-nil" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
