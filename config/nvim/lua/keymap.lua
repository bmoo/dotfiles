-- Leader-scoped keymap registry.
--
-- Plugin files and lua/lsp.lua call M.register({...}) with their leader
-- bindings. Plugin specs that lazy-load on keypress add `keys = M.lazy_for("name")`
-- to their spec; lazy.nvim creates the on-demand stubs.
--
-- init.lua finishes with M.group({...}) + M.finalize() to validate (collisions,
-- undeclared overrides), bind eager entries, and install ft-scoped autocmds.
-- Non-leader keys (terminal nav, [d/]d, gf) stay as raw vim.keymap.set calls.

local M = {}

-- Storage --------------------------------------------------------------------

local entries = {}      -- list of normalized entries
local groups = {}       -- prefix string -> human label
local lazy_index = {}   -- plugin name -> list of entries shaped for lazy.nvim

local ALLOWED_OPTS = {
    desc = true, mode = true, group = true, ft = true,
    overrides = true, lazy = true, plugin = true,
    expr = true, noremap = true, silent = true, nowait = true,
}

-- Helpers --------------------------------------------------------------------

local function as_list(v)
    if v == nil then return nil end
    if type(v) == "table" then return v end
    return { v }
end

-- Returns "file:line" of the frame `levels` above the function that calls
-- this. Level 0 = caller_location, level 1 = direct caller, etc.
local function caller_location(levels)
    local info = debug.getinfo(2 + (levels or 0), "Sl")
    if not info then return "<unknown>" end
    local src = info.short_src or info.source or "?"
    return src .. ":" .. (info.currentline or 0)
end

local function normalize(entry, declarer)
    local key, action = entry[1], entry[2]
    assert(type(key) == "string" and key ~= "",
        "keymap.register: missing key at " .. declarer)
    assert(action ~= nil,
        "keymap.register: missing action for " .. key .. " at " .. declarer)
    assert(type(entry.desc) == "string" and entry.desc ~= "",
        "keymap.register: missing desc for " .. key .. " at " .. declarer)
    assert(key:match("^<[Ll]eader>") or key:match("^<[Ll]ocal[Ll]eader>"),
        "keymap.register: key '" .. key .. "' is not leader-scoped (" .. declarer .. ")")

    for k in pairs(entry) do
        if type(k) == "string" and not ALLOWED_OPTS[k] then
            error("keymap.register: unknown option '" .. k .. "' on " .. key .. " (" .. declarer .. ")")
        end
    end

    local modes = as_list(entry.mode) or { "n" }
    local fts = as_list(entry.ft)
    local lazy = entry.lazy == true

    if lazy then
        assert(type(entry.plugin) == "string" and entry.plugin ~= "",
            "keymap.register: lazy entry needs plugin= (" .. key .. " at " .. declarer .. ")")
    end

    return {
        key = key,
        action = action,
        modes = modes,
        fts = fts,                       -- nil => global
        desc = entry.desc,
        group = entry.group,
        overrides = entry.overrides == true,
        lazy = lazy,
        plugin = entry.plugin,
        expr = entry.expr,
        noremap = entry.noremap,
        silent = entry.silent ~= false,  -- default true
        nowait = entry.nowait,
        declarer = declarer,
    }
end

-- Public surface --------------------------------------------------------------

--- Register one or more entries.
function M.register(list)
    assert(type(list) == "table", "keymap.register: expected a list of entries")
    local declarer = caller_location(1)
    for _, raw in ipairs(list) do
        local e = normalize(raw, declarer)
        table.insert(entries, e)
        if e.lazy then
            lazy_index[e.plugin] = lazy_index[e.plugin] or {}
            table.insert(lazy_index[e.plugin], e)
        end
    end
end

--- Return entries tagged with `plugin`, shaped for lazy.nvim's `keys = ...`.
function M.lazy_for(plugin)
    local out = {}
    for _, e in ipairs(lazy_index[plugin] or {}) do
        local spec = {
            e.key, e.action,
            mode = e.modes,
            desc = e.desc,
            expr = e.expr,
            noremap = e.noremap,
            silent = e.silent,
            nowait = e.nowait,
        }
        if e.fts then spec.ft = e.fts end
        table.insert(out, spec)
    end
    return out
end

--- Declare prefix -> which-key label. May be called multiple times.
function M.group(prefix_to_label)
    for prefix, label in pairs(prefix_to_label) do
        groups[prefix] = label
    end
end

--- Validate the full registry, then bind eager entries. Called once at the
--- end of init.lua. Lazy entries are not touched (lazy.nvim binds them).
function M.finalize()
    M._validate()
    M._bind_eager()
end

--- Called from the which-key plugin's config function so wk.add fires after
--- which-key has loaded itself.
function M.register_groups_with_wk()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    local list = {}
    for prefix, label in pairs(groups) do
        table.insert(list, { prefix, group = label })
    end
    wk.add(list)
end

--- Debug: print every entry with its declarer. :lua require("keymap").audit()
function M.audit()
    local sorted = vim.deepcopy(entries)
    table.sort(sorted, function(a, b)
        if a.key ~= b.key then return a.key < b.key end
        return table.concat(a.modes, ",") < table.concat(b.modes, ",")
    end)
    for _, e in ipairs(sorted) do
        local scope = e.fts and ("ft=" .. table.concat(e.fts, ",")) or "global"
        local tag = e.lazy and (" [lazy:" .. e.plugin .. "]") or ""
        local ov = e.overrides and " [overrides]" or ""
        print(string.format("%-18s %-10s %-20s %s%s%s   @ %s",
            e.key, table.concat(e.modes, ","), scope, e.desc, tag, ov, e.declarer))
    end
end

-- Internals ------------------------------------------------------------------

-- Fan an entry out into one (key, mode, ft) virtual record per (mode, ft).
-- ft = nil represents a global binding.
local function fan_out(e)
    local out = {}
    for _, m in ipairs(e.modes) do
        if e.fts then
            for _, ft in ipairs(e.fts) do
                table.insert(out, { mode = m, ft = ft, entry = e })
            end
        else
            table.insert(out, { mode = m, ft = nil, entry = e })
        end
    end
    return out
end

function M._validate()
    -- Group by (key, mode). Within each, separate global from ft-scoped.
    local buckets = {}  -- "key|mode" -> { global = {entry,...}, by_ft = { [ft] = {entry,...} } }
    for _, e in ipairs(entries) do
        local virtuals = fan_out(e)
        for _, v in ipairs(virtuals) do
            local k = v.entry.key .. "|" .. v.mode
            buckets[k] = buckets[k] or { global = {}, by_ft = {} }
            if v.ft == nil then
                table.insert(buckets[k].global, v.entry)
            else
                buckets[k].by_ft[v.ft] = buckets[k].by_ft[v.ft] or {}
                table.insert(buckets[k].by_ft[v.ft], v.entry)
            end
        end
    end

    local errors = {}

    local function describe(e)
        return string.format("    %s  desc=%q  @ %s",
            e.key, e.desc, e.declarer)
    end

    for k, b in pairs(buckets) do
        -- Multiple globals on same key+mode -> collision.
        if #b.global > 1 then
            local lines = { "keymap collision (global) on " .. k .. ":" }
            for _, e in ipairs(b.global) do table.insert(lines, describe(e)) end
            table.insert(errors, table.concat(lines, "\n"))
        end

        -- Multiple entries scoped to the same ft -> collision.
        for ft, list in pairs(b.by_ft) do
            if #list > 1 then
                local lines = { "keymap collision (ft=" .. ft .. ") on " .. k .. ":" }
                for _, e in ipairs(list) do table.insert(lines, describe(e)) end
                table.insert(errors, table.concat(lines, "\n"))
            end
        end

        -- Global + ft-scoped -> ft-scoped entries must declare overrides=true.
        if #b.global == 1 then
            for ft, list in pairs(b.by_ft) do
                for _, e in ipairs(list) do
                    if not e.overrides then
                        local lines = {
                            "keymap shadow without overrides=true on " .. k .. " (ft=" .. ft .. "):",
                            describe(b.global[1]),
                            describe(e),
                            "    set overrides = true on the ft-scoped entry to declare intent.",
                        }
                        table.insert(errors, table.concat(lines, "\n"))
                    end
                end
            end
        end
    end

    if #errors > 0 then
        error("\n" .. table.concat(errors, "\n\n"), 0)
    end
end

local function set_opts(e, extra)
    local o = { desc = e.desc, silent = e.silent }
    if e.expr ~= nil then o.expr = e.expr end
    if e.noremap ~= nil then o.noremap = e.noremap end
    if e.nowait ~= nil then o.nowait = e.nowait end
    if extra then for k, v in pairs(extra) do o[k] = v end end
    return o
end

function M._bind_eager()
    local ft_entries = {}
    for _, e in ipairs(entries) do
        if not e.lazy then
            if e.fts == nil then
                vim.keymap.set(e.modes, e.key, e.action, set_opts(e))
            else
                for _, ft in ipairs(e.fts) do
                    ft_entries[ft] = ft_entries[ft] or {}
                    table.insert(ft_entries[ft], e)
                end
            end
        end
    end

    if next(ft_entries) then
        local group = vim.api.nvim_create_augroup("KeymapRegistryFt", { clear = true })
        for ft, list in pairs(ft_entries) do
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = ft,
                callback = function(ev)
                    for _, e in ipairs(list) do
                        vim.keymap.set(e.modes, e.key, e.action, set_opts(e, { buffer = ev.buf }))
                    end
                end,
            })
        end
    end
end

return M
