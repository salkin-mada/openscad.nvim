local U = require("openscad.utilities")
local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local info = vim.health.info or vim.health.report_info
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local M = {}

M.checks = {}

M.log = {
    ---@class OpenscadHealthLog
    checkhealth = {
        start = function(msg)
            start(msg or "openscad.nvim")
        end,
        info = function(msg, ...)
            info(msg:format(...))
        end,
        ok = function(msg, ...)
            ok(msg:format(...))
        end,
        warn = function(msg, ...)
            warn(msg:format(...))
        end,
        error = function(msg, ...)
            error(msg:format(...))
        end
    },
    ascii = {
        run = function ()
            if vim.fn.executable('figlet') == 1 then
                local obj = vim.system({'figlet', '-f', 'lean', '.scad'}, { text = true }):wait()
                info(obj.stdout)
            end
        end
    }
}

local version = "0.10.0"

---@param opts? {checkhealth?: boolean}
function M.check(opts)
    opts = opts or {}
    opts.checkhealth = opts.checkhealth == nil and true or opts.checkhealth

    local log = M.log

    log.checkhealth.start()

    if vim.fn.has("nvim-"..version) ~= 1 then
        log.checkhealth.error("`openscad.nvim` needs Neovim >= "..version)
        if not opts.checkhealth then
            return
        end
    else
        log.ascii.run()
        log.checkhealth.ok("Neovim >= "..version)
        -- if opts.checkhealth and vim.fn.has("nvim-0.9.0") ~= 1 then
        --   log.warn("**Neovim** 0.9.1 (nightly) is recommended, since it fixes some issues related to `vim.ui_attach`")
        -- end
    end

    if opts.checkhealth then
        -- if not U.module_exists("FzfLua") then
		if not vim.inspect(FzfLua) then
            log.checkhealth.warn("Openscad needs `fzf-lua` for fuzzy selection in the `help` view")
            if not opts.checkhealth then
                return
            end
        else
            log.checkhealth.ok("`fzf-lua` is installed")
        end

        for _, bin in ipairs({ "zathura", "htop" }) do
            if vim.fn.executable(bin) == 1 then
            -- if U.toboolean(tostring(vim.fn.executable(bin))) then
                log.checkhealth.ok(
                    "`" .. bin .. "`"
                    .. " is installed"
                )
            else
                log.checkhealth.warn(
                    "`"..bin.."`"
                    .. " is not installed"
                )
            end
        end
    end

    return true
end

function M.get_source(fn)
    local info = debug.getinfo(fn, "S")
    local source = info.source:sub(2)
    ---@class FindSource
    local ret = {
        line = info.linedefined,
        source = source,
        plugin = "unknown",
    }
    if source:find("openscad") then
        ret.plugin = "openscad.nvim"
    elseif source:find("/runtime/lua/") then
        ret.plugin = "nvim"
    else
        local opt = source:match("/pack/[^%/]-/opt/([^%/]-)/")
        local start = source:match("/pack/[^%/]-/start/([^%/]-)/")
        ret.plugin = opt or start or "unknown"
    end
    return ret
end

-- M.check({ checkhealth = false })

return M
