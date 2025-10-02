local M = {}

function M.setup()
  -- Configure how diagnostics appear
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",  -- or "■", "▎", "x"
      spacing = 2,
    },
    underline = true,
    update_in_insert = false, -- don’t update while typing
    severity_sort = true,
  })
  
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })
end

return M
