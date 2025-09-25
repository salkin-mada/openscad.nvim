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
--
-- Maintainer: Niklas Adam <adam@oddodd.org>
-- Version:	0.3
-- Modified: 2023-06-26T19:52:26 CEST


local M = {}
local W = require'openscad.window'
local U = require'openscad.utilities'
local T = require'openscad.terminal'
local t = T:new()
local api = vim.api
local fn = vim.fn
local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup

-- vim.filetype.add {
--     extension = {
--         scad = "openscad",
--         scadhelp = "openscad-help"
--     }
-- }
-- augroup("OpenSCAD", {clear = true})
autocmd({"BufRead", "BufNewFile"}, {pattern = "*.scad", command = 'setfiletype openscad'})
autocmd({"BufRead", "BufNewFile"}, {pattern = "*.scadhelp", command = 'setfiletype openscad-help'})
autocmd({"FileType"}, {
    pattern = "openscad",
    callback = function ()
        require'openscad'.load()
    end
})

function M.setup()
    vim.g.openscad_default_mappings = vim.g.openscad_default_mappings or false
    vim.g.openscad_auto_open = vim.g.openscad_auto_open or false
    vim.g.openscad_cheatsheet_window_blend = vim.g.openscad_cheatsheet_window_blend or 15 -- %
    vim.g.openscad_fuzzy_profile = vim.g.openscad_fuzzy_profile or 'default'
    vim.g.openscad_load_snippets = vim.g.openscad_load_snippets or false
end

function M.load()
    M.window = W:new()
    M.setup()
    require('openscad/commands')
    if vim.g.openscad_default_mappings then
        M.default_mappings()
        M.set_mappings()
    else
        M.set_user_mappings()
    end
    if vim.g.openscad_auto_open then
        M.exec_openscad()
    end
    if vim.g.openscad_load_snippets then
        M.load_snippets()
    end

end

function M.self_close()
    M.window:unload()
    -- print("close cheatsheet")
end

function M.toggle()
    if M.window:is_open() then
        M.window:close()
    else
        M.window:open()
    end
end

function M.manual()
    local path = U.openscad_nvim_root_dir .. U.path_sep .. "help_source" .. U.path_sep .. "openscad-manual.pdf"
	if vim.g.openscad_pdf_cmd then
		vim.cmd('silent !' .. vim.g.openscad_pdf_cmd .. ' ' .. path)
	else
		print("openscad: vim.g.openscad_pdf_cmd is not set")
	end
end

function M.help()
    local fzf = require('fzf-lua')
    local path = U.openscad_nvim_root_dir .. U.path_sep .. "help_source" .. U.path_sep .. "tree"

    -- coroutine.wrap(function()
    -- local result = fzf.fzf("fd", "--preview {}", {fzf_cwd = path, fzf_binary = vim.g.openscad_fuzzy_profile})
    --     if result then
    --         vim.cmd("spl " .. path .. result[1])
    --     end

    fzf.setup({vim.g.openscad_fuzzy_profile})
    fzf.files({ cwd = path })

end

function M.exec_openscad()
    local bin;

    if vim.fn.has('linux') == 1 then
        bin = 'openscad'
    elseif vim.fn.has('mac') == 1 then
        bin = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
    elseif vim.fn.has('windows') == 1 then
        bin = 'openscad' -- not tested
    else
        print("openscad missing jobcommand implementation")
    end

    -- vim.fn.jobstart(bin .. vim.fn.expand('%:p'))

    local on_exit = function(obj)
        -- print(obj.code)
        -- print(obj.signal)
        print(obj.stdout)
        -- print(obj.stderr)
    end
    -- vim.system({"echo", "openscad system call"}, {text = true}, on_exit)
    vim.system({bin, vim.fn.expand('%:p')}, {detach = true}, on_exit)
end

function M.default_mappings()
    vim.g.openscad_cheatsheet_toggle_key = vim.g.openscad_cheatsheet_toggle_key or '<Enter>'
    vim.g.openscad_help_trig_key = vim.g.openscad_help_trig_key or '<A-h>'
    vim.g.openscad_manual_trig_key = vim.g.openscad_manual_trig_key or '<A-m>'
    vim.g.openscad_exec_openscad_trig_key = vim.g.openscad_exec_openscad_trig_key or '<A-o>'
end

function M.set_mappings()
    local options = { noremap = true, nowait = true, silent = true }
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_cheatsheet_toggle_key, '<cmd> lua require"openscad".toggle()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_help_trig_key, '<cmd> lua require"openscad".help()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_manual_trig_key, '<cmd> lua require"openscad".manual()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_exec_openscad_trig_key, '<cmd> lua require"openscad".exec_openscad()<cr>', options)
end

function M.set_user_mappings()
    local options = { noremap = true, nowait = true, silent = true }
    if vim.g.openscad_cheatsheet_toggle_key then
        api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_cheatsheet_toggle_key, '<cmd> lua require"openscad".toggle()<cr>', options)
    end
    if vim.g.openscad_help_trig_key then
        api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_help_trig_key, '<cmd> lua require"openscad".help()<cr>', options)
    end
    if vim.g.openscad_manual_trig_key then
        api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_manual_trig_key, '<cmd> lua require"openscad".manual()<cr>', options)
    end
    if vim.g.openscad_exec_openscad_trig_key then
        api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_exec_openscad_trig_key, '<cmd> lua require"openscad".exec_openscad()<cr>', options)
    end
end

function M.get_snippets()
	return require"openscad.snippets"
end

function M.load_snippets()
    local path = U.openscad_nvim_root_dir .. U.path_sep .. "lua" .. U.path_sep .. "openscad" .. U.path_sep .. "snippets"
    require("luasnip.loaders.from_lua").load({paths = path})
end

--------------------------------------------------
--                 dev reloader                 --
--------------------------------------------------
if vim.g.openscad_dev then
    vim.api.nvim_create_user_command("OpenscadDevUpdate", function()
        if vim.fn.expand("%:p:h:h:t") == "openscad.nvim" then
            package.loaded.openscad = nil
            require("openscad")
        else
            print("working dir is: ".. vim.fn.getcwd())
        end
    end, {})
end



return M
-- NOTE(salkin):
-- local mappings = {
    -- 	['['] = 'update_view(-1)',
    -- 	[']'] = 'update_view(1)',
    -- 	['<cr>'] = 'open_file()',
    -- 	h = 'update_view(-1)',
    -- 	l = 'update_view(1)',
    -- 	q = 'close_window()',
    -- 	k = 'move_cursor()'
    -- }

    -- for k,v in pairs(mappings) do
    -- 	api.nvim_buf_set_keymap(0, 'n', k, ':lua require"whid".'..v..'<cr>', {
        -- 		nowait = true, noremap = true, silent = true
        -- 	})
        -- end
