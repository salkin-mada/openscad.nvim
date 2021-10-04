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
-- Maintainer: Niklas Adam <salkinmada@protonmail.com>
-- Version:	0.1
-- Modified:	2020-09-12
--

local M = {}
local W = require'openscad.window'
local U = require'openscad.utilities'
local T = require'openscad.terminal'
local t = T:new()
local api = vim.api
local fn = vim.fn

-- api.nvim_command([[ autocmd FileType openscad lua require'openscad'.load() ]])
-- api.nvim_command([[ autocmd BufRead,BufNewFile *.scad setfiletype openscad ]])
-- api.nvim_command([[ autocmd BufRead,BufNewFile *.scadhelp setfiletype openscad-help ]])

-- soon lua autocmd and augroup will be implemented
api.nvim_exec([[
augroup openscad_hook
autocmd!
autocmd FileType openscad lua require'openscad'.load()
autocmd BufRead,BufNewFile *.scad setfiletype openscad
autocmd BufRead,BufNewFile *.scadhelp setfiletype openscad-help
augroup END
]], true)

function M.topToggle()
    t:toggle()
end

function M.setup()
    vim.g.openscad_default_mappings = vim.g.openscad_default_mappings or false
    vim.g.openscad_auto_open = vim.g.openscad_auto_open or false
    vim.g.openscad_cheatsheet_window_blend = vim.g.openscad_cheatsheet_window_blend or 15 -- %
    vim.g.openscad_fuzzy_finder = vim.g.openscad_fuzzy_finder or 'skim'
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
    api.nvim_command('silent !zathura --fork '  .. path)
end

function M.help()
    local path = U.openscad_nvim_root_dir .. U.path_sep .. "help_source" .. U.path_sep .. "tree"
    if vim.g.openscad_fuzzy_finder == 'skim' then
        api.nvim_command('silent SK '  .. path)
        print("skim openscad help")
    elseif vim.g.openscad_fuzzy_finder == 'fzf' then
        api.nvim_command('silent FZF '  .. path)
        print("fzf openscad help")
    else
        print("openscad.nvim: this fuzzy finder (" .. vim.g.openscad_fuzzy_finder .. ") i dont know.. plz use 'skim' or 'fzf'")
    end
end

function M.exec_openscad()
    -- maybe just use api.jobstart .. instead
    api.nvim_command[[ call jobstart('openscad ' . shellescape(expand('%:p')), {'detach':1}) ]]
end

function M.default_mappings()
    vim.g.openscad_cheatsheet_toggle_key = vim.g.openscad_cheatsheet_toggle_key or '<Enter>'
    vim.g.openscad_help_trig_key = vim.g.openscad_help_trig_key or '<A-h>'
    vim.g.openscad_manual_trig_key = vim.g.openscad_manual_trig_key or '<A-m>'
    vim.g.openscad_exec_openscad_trig_key = vim.g.openscad_exec_openscad_trig_key or '<A-o>'
    vim.g.openscad_top_toggle = vim.g.openscad_top_toggle or '<A-c>'
end

function M.set_mappings()
    local options = { noremap = true, nowait = true, silent = true }
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_cheatsheet_toggle_key, '<cmd> lua require"openscad".toggle()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_help_trig_key, '<cmd> lua require"openscad".help()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_manual_trig_key, '<cmd> lua require"openscad".manual()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_exec_openscad_trig_key, '<cmd> lua require"openscad".exec_openscad()<cr>', options)
    api.nvim_buf_set_keymap(0, 'n', vim.g.openscad_top_toggle, ':OpenscadTopToggle<CR>', { noremap = true, silent = true })
    api.nvim_buf_set_keymap(0, 't', vim.g.openscad_top_toggle, '<C-\\><C-n>:OpenscadTopToggle<CR>', { noremap = true, silent = true })
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
    if vim.g.openscad_top_toggle then
        api.nvim_set_keymap('n', vim.g.openscad_top_toggle, ':OpenscadTopToggle<CR>', { noremap = true, silent = true })
        api.nvim_set_keymap('t', vim.g.openscad_top_toggle, '<C-\\><C-n>:OpenscadTopToggle<CR>', { noremap = true, silent = true })
    end
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
