-- Open the [text](path) link spanning the cursor, even when the cursor sits
-- on the label. Path resolves against the buffer's directory, not :pwd, so
-- `[X](../foo.md)` works regardless of where nvim was launched. Falls through
-- to gf for bare paths and URLs.
local function follow_link()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".")
    local i = 1
    while true do
        local s, e, path = line:find("%[[^%]]*%]%(([^%)]+)%)", i)
        if not s then break end
        if col >= s and col <= e then
            local file = path:match("^([^#]+)") or path
            local target = vim.fn.simplify(vim.fn.expand("%:p:h") .. "/" .. file)
            vim.cmd("edit " .. vim.fn.fnameescape(target))
            return
        end
        i = e + 1
    end
    vim.cmd("normal! gf")
end

require("keymap").register({
    { "<leader>gd", follow_link,
        ft = "markdown", overrides = true,
        desc = "Follow Link" },
    { "<leader>gr", function()
        Snacks.picker.grep({ search = vim.fn.expand("%:t:r") })
      end,
        ft = "markdown", overrides = true,
        desc = "References to this note" },
})

return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
}
