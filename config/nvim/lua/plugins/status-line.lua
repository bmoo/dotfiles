return {{
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons", "Shatur/neovim-ayu", "SmiteshP/nvim-navic"},
    opts = function()
      local has_navic, navic = pcall(require, "nvim-navic")

      local sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1, shorting_target = 40 },
          -- Breadcrumbs from nvim-navic when available
          has_navic and {
            function() return navic.get_location() end,
            cond = function() return navic.is_available() end,
          } or nil,
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }

      return {
        options = {
          theme = "auto",
          icons_enabled = true,
          globalstatus = true, -- requires Neovim 0.8+ (laststatus=3)
          component_separators = { "│", "│" },
          section_separators = { "", "" },
          disabled_filetypes = { statusline = { "alpha" } },
        },
        sections = sections,
      }
    end,
}, {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
        icons = {
            File = " ",
            Module = " ",
            Namespace = " ",
            Package = " ",
            Class = " ",
            Method = " ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = " ",
            Interface = " ",
            Function = " ",
            Variable = " ",
            Constant = " ",
            String = " ",
            Number = " ",
            Boolean = " ",
            Array = " ",
            Object = " ",
            Key = " ",
            Null = " ",
            EnumMember = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " "
        }
    }
}}
