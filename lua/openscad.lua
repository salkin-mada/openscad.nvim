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
-- Version:	0.2
-- Modified: 2022-03-29T11:08:17 CEST
--

local M = {}
local W = require'openscad.window'
local U = require'openscad.utilities'
local T = require'openscad.terminal'
local t = T:new()
local api = vim.api
local fn = vim.fn
local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup

if fn.has "nvim-0.7" == 1 then
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
else
    api.nvim_exec([[
    augroup openscad_hook
    autocmd!
    autocmd FileType openscad lua require'openscad'.load()
    autocmd BufRead,BufNewFile *.scad setfiletype openscad
    autocmd BufRead,BufNewFile *.scadhelp setfiletype openscad-help
    augroup END
    ]], true)
end

function M.topToggle()
    t:toggle()
end

function M.setup()
    vim.g.openscad_default_mappings = vim.g.openscad_default_mappings or false
    vim.g.openscad_auto_open = vim.g.openscad_auto_open or false
    vim.g.openscad_cheatsheet_window_blend = vim.g.openscad_cheatsheet_window_blend or 15 -- %
    vim.g.openscad_fuzzy_finder = vim.g.openscad_fuzzy_finder or 'skim'
    vim.g.openscad_load_snippets = vim.g.openscad_load_snippets or false
    vim.g.openscad_pdf_command = vim.g.openscad_pdf_command or ''
    vim.bo.commentstring = '//%s'

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
    if vim.g.openscad_pdf_command == '' then
        print("openscad.nvim: pdf command is not set.. please set a pdf command")
    else
        api.nvim_command('silent !' .. vim.g.openscad_pdf_command .. ' ' .. path)
    end
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
	local jobCommand;
	local filename = '"' .. vim.fn.expand("%:p") .. '"'

	-- If Linux, just use basecommand, if on MacOS, use a special command
	if vim.fn.has('mac') == 1 then
		jobCommand = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ' .. filename
	else
		-- TODO: What about Windows?
		jobCommand = 'openscad ' .. filename
	end

	vim.fn.jobstart(jobCommand)
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

function M.get_snippets()
	return require"openscad.snippets"
end

function M.load_snippets()
    local path = U.openscad_nvim_root_dir .. U.path_sep .. "lua" .. U.path_sep .. "openscad" .. U.path_sep .. "snippets"
    require("luasnip.loaders.from_lua").load({paths = path})
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
