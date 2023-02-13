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

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "ff", require("telescope.builtin").find_files, opts)
vim.keymap.set("n", "fg", require("telescope.builtin").live_grep, opts)
vim.keymap.set("n", "fb", require("telescope.builtin").buffers, opts)
vim.keymap.set("n", "fh", require("telescope.builtin").help_tags, opts)