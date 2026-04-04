-- This file is part of openscad.nvim
--
-- openscad.nvim is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- openscad.nvim is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with openscad.nvim.  If not, see <http://www.gnu.org/licenses/>.
--
-- Maintainer: Niklas Adam <adam@oddodd.org>
-- Version: 0.4

local M = {}
local W = require('openscad.window')
local U = require('openscad.utilities')

vim.filetype.add({
    extension = {
        scad     = 'openscad',
        scadhelp = 'openscad-help',
    },
})

vim.api.nvim_create_autocmd('FileType', {
    pattern  = 'openscad',
    callback = function() require('openscad').load() end,
})

-- ── setup ──────────────────────────────────────────────────────────────────

function M.setup()
    vim.g.openscad_default_mappings        = vim.g.openscad_default_mappings or false
    vim.g.openscad_auto_open               = vim.g.openscad_auto_open or false
    -- 'auto' detects fzf-lua then snacks; or set explicitly to 'fzf-lua' / 'snacks'
    vim.g.openscad_fuzzy_finder            = vim.g.openscad_fuzzy_finder or 'auto'
    vim.g.openscad_load_snippets           = vim.g.openscad_load_snippets or false
end

-- ── load (called per .scad buffer via FileType autocmd) ────────────────────

local _initialized = false

function M.load()
    -- One-time global initialization
    if not _initialized then
        M.window = W:new()
        M.setup()
        require('openscad.commands')
        if vim.g.openscad_auto_open   then M.exec_openscad() end
        if vim.g.openscad_load_snippets then M.load_snippets() end
        _initialized = true
    end

    -- Per-buffer setup
    vim.bo.commentstring = '//%s'
    if vim.g.openscad_default_mappings then
        M.default_mappings()
    end
    M.set_mappings()
end

-- ── cheatsheet ─────────────────────────────────────────────────────────────

function M.self_close()
    M.window:close()
end

function M.toggle()
    if M.window:is_open() then
        M.window:close()
    else
        M.window:open()
    end
end

-- ── help ───────────────────────────────────────────────────────────────────

function M.help()
    local path   = U.openscad_nvim_root_dir .. '/help_source/tree'
    local finder = vim.g.openscad_fuzzy_finder or 'auto'

    -- Resolve 'auto': prefer fzf-lua, fall back to snacks
    if finder == 'auto' then
        if pcall(require, 'fzf-lua') then
            finder = 'fzf-lua'
        elseif pcall(require, 'snacks') then
            finder = 'snacks'
        else
            vim.notify(
                'openscad.nvim: no fuzzy finder found — install fzf-lua or snacks.nvim',
                vim.log.levels.ERROR
            )
            return
        end
    end

    if finder == 'fzf-lua' then
        local ok, fzf = pcall(require, 'fzf-lua')
        if not ok then
            vim.notify('openscad.nvim: fzf-lua is not installed', vim.log.levels.ERROR)
            return
        end
        fzf.files({
            prompt  = 'OpenSCAD Help> ',
            cwd     = path,
            winopts = { title = ' OpenSCAD Help ' },
        })
    elseif finder == 'snacks' then
        local ok, snacks = pcall(require, 'snacks')
        if not ok then
            vim.notify('openscad.nvim: snacks.nvim is not installed', vim.log.levels.ERROR)
            return
        end
        snacks.picker.files({
            prompt = 'OpenSCAD Help> ',
            cwd    = path,
            title  = ' OpenSCAD Help ',
        })
    else
        vim.notify(('openscad.nvim: unknown fuzzy finder "%s"'):format(finder), vim.log.levels.ERROR)
    end
end

-- ── manual ─────────────────────────────────────────────────────────────────

function M.manual()
    local pdf_cmd = vim.g.openscad_pdf_cmd
    if not pdf_cmd or pdf_cmd == '' then
        vim.notify('openscad.nvim: vim.g.openscad_pdf_cmd is not set', vim.log.levels.WARN)
        return
    end
    local path = U.openscad_nvim_root_dir .. '/help_source/openscad-manual.pdf'
    vim.system({ pdf_cmd, path }, { detach = true })
end

-- ── exec ───────────────────────────────────────────────────────────────────

function M.exec_openscad()
    local bin = vim.fn.has('mac') == 1
        and '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
        or  'openscad'
    vim.system({ bin, vim.fn.expand('%:p') }, { detach = true })
end

-- ── justfile ───────────────────────────────────────────────────────────────

function M.deploy_justfile(force)
    require('openscad.justfile').deploy(force)
end

-- ── snippets ───────────────────────────────────────────────────────────────

function M.load_snippets()
    local path = U.openscad_nvim_root_dir .. '/lua/openscad/snippets'
    require('luasnip.loaders.from_lua').load({ paths = path })
end

-- ── mappings ───────────────────────────────────────────────────────────────

function M.default_mappings()
    vim.g.openscad_cheatsheet_toggle_key  = vim.g.openscad_cheatsheet_toggle_key  or '<Enter>'
    vim.g.openscad_help_trig_key          = vim.g.openscad_help_trig_key          or '<A-h>'
    vim.g.openscad_manual_trig_key        = vim.g.openscad_manual_trig_key        or '<A-m>'
    vim.g.openscad_exec_openscad_trig_key = vim.g.openscad_exec_openscad_trig_key or '<A-o>'
end

-- Single mapping function — nil keys are silently skipped.
-- Call M.default_mappings() first to fill in keys from defaults.
function M.set_mappings()
    local opts = { noremap = true, nowait = true, silent = true, buffer = 0 }
    local function map(key, fn, desc)
        if not key then return end
        opts.desc = desc
        vim.keymap.set('n', key, fn, opts)
    end
    map(vim.g.openscad_cheatsheet_toggle_key,  function() M.toggle() end,       'openscad: toggle cheatsheet')
    map(vim.g.openscad_help_trig_key,          function() M.help() end,          'openscad: fuzzy search help')
    map(vim.g.openscad_manual_trig_key,        function() M.manual() end,        'openscad: open PDF manual')
    map(vim.g.openscad_exec_openscad_trig_key, function() M.exec_openscad() end, 'openscad: open file in OpenSCAD')
end

return M
