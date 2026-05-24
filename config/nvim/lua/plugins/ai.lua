-- Launch claude with the current background as an explicit --settings override.
-- Otherwise claude probes the terminal with OSC 11 ("what's your background?"),
-- and nvim's :terminal doesn't fully consume the response — the query body
-- `11;?` leaks into claude's input prompt.
local function claude_cmd(extra_args)
    local theme = vim.o.background == "light" and "light" or "dark"
    local settings = "--settings '{\"theme\":\"" .. theme .. "\"}'"
    vim.cmd("ClaudeCode " .. (extra_args and (extra_args .. " ") or "") .. settings)
end

local function quit_all()
    local claude_buf
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal"
            and vim.api.nvim_buf_get_name(buf):lower():match("claude") then
            claude_buf = buf
            break
        end
    end

    if not claude_buf then
        vim.cmd("qa")
        return
    end

    local job = vim.b[claude_buf].terminal_job_id
    pcall(vim.cmd, "ClaudeCodeStop")
    if job then
        vim.fn.chansend(job, "/exit\r")
    end

    local timer = vim.uv.new_timer()
    local waited = 0
    timer:start(50, 100, vim.schedule_wrap(function()
        waited = waited + 100
        local still_running = job and vim.fn.jobwait({ job }, 0)[1] == -1
        if not still_running or waited > 2000 then
            timer:stop(); timer:close()
            vim.cmd("qa!")
        end
    end))
end

require("keymap").register({
    { "<leader>ac", function() claude_cmd() end,            desc = "Toggle Claude",      group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",             desc = "Focus Claude",       group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>ar", function() claude_cmd("--resume") end,  desc = "Resume Claude",      group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>aC", function() claude_cmd("--continue") end,desc = "Continue Claude",    group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>",       desc = "Select Claude model",group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",             desc = "Add current buffer", group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",              desc = "Send to Claude",     group = "ai", lazy = true, plugin = "claudecode", mode = "v" },
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",           desc = "Add file",           group = "ai", lazy = true, plugin = "claudecode", ft = { "neo-tree", "oil", "minifiles", "netrw" } },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",        desc = "Accept diff",        group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",          desc = "Deny diff",          group = "ai", lazy = true, plugin = "claudecode" },
    { "<leader>aq", quit_all,                               desc = "Quit Claude + nvim", group = "ai", lazy = true, plugin = "claudecode" },
})

return {
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            terminal = {
                split_side = "left",
                split_width_percentage = 0.35,
            },
        },
        config = function(_, opts)
            require("claudecode").setup(opts)

            vim.api.nvim_create_autocmd("BufWinEnter", {
                group = vim.api.nvim_create_augroup("ClaudeFixedWidth", { clear = true }),
                callback = function(args)
                    if vim.api.nvim_buf_get_name(args.buf):lower():match("claude") then
                        vim.wo[vim.fn.bufwinid(args.buf)].winfixwidth = true
                    end
                end,
            })
        end,
        keys = require("keymap").lazy_for("claudecode"),
    },
}
