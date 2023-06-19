local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local Window = {}
local win_id
local cheatsheet_filetype = 'openscad-help'

-- function Window:new(tbl, self_close_mapping)
function Window:new(tbl)
    helpwin_buffer_visible = false;
    helpwin_border_buffer_visible = false;
	tbl = tbl or {}
	setmetatable(tbl, self)
	self.__index = self
	self.bufnr = api.nvim_create_buf(helpwin_buffer_visible, true)
	-- api.nvim_buf_set_option(self.bufnr, 'buftype', 'nowrite')
	vim.bo[self.bufnr].buftype = 'nowrite'
	-- vim.bo[self.bufnr].modifiable = false
	api.nvim_buf_set_name(self.bufnr, 'openscad-help-' .. self.bufnr)

	self.border_bufnr = api.nvim_create_buf(helpwin_border_buffer_visible, true)
	-- api.nvim_buf_set_option(self.border_bufnr, 'buftype', 'nowrite')
	vim.bo[self.border_bufnr].buftype = 'nowrite'
	api.nvim_buf_set_name(self.border_bufnr, 'openscad-help_border-' .. self.border_bufnr)
	local options = { noremap = true, nowait = true, silent = true }
	-- local key = tostring(vim.g.openscad_cheatsheet_toggle_key)
	-- api.nvim_buf_set_keymap(self.bufnr, 'n', key, '<cmd> lua require"openscad".self_close()<cr>', options)
	-- api.nvim_buf_set_keymap(self.bufnr, 'n', '<Enter>', '<cmd> lua require"openscad".self_close()<cr>', options)
    -- if vim.g.openscad_cheatsheet_toggle_key then
	api.nvim_buf_set_keymap(self.bufnr, 'n', vim.g.openscad_cheatsheet_toggle_key or '<Enter>', '<cmd> lua require"openscad".self_close()<cr>', options)
	api.nvim_buf_set_keymap(self.bufnr, 'n', '<esc>', '<cmd> lua require"openscad".self_close()<cr>', options)
    -- end
	return tbl
end

function Window:is_open()
	return self:is_valid() and vim.fn.bufwinnr(self.bufnr) > 0
end

function Window:is_valid()
	return self.bufnr and api.nvim_buf_is_loaded(self.bufnr) or false
end

function Window:set_lines(data)
	if self:is_valid() then
		api.nvim_buf_set_lines(self.bufnr, -1, -1, true, {data})
		if self:is_open() then
			local num_lines = api.nvim_buf_line_count(self.bufnr)
			api.nvim_win_set_cursor(self.winnr, {num_lines, 0})
		end
	end
end

function Window:create_border(options, margin)
	vim.validate {
		options = {options, 'table'}
	}
	margin = margin or 2
	local opts = {
		width = options.width + margin,
		height = options.height + margin,
		col = options.col - (margin / 2),
		row = options.row - (margin / 2),
		focusable = false,
	}
	local border = {}
	local t = '┌' .. string.rep('─', opts.width - margin) .. '┐'
	local s = '│' .. string.rep(' ', opts.width - margin) .. '│'
	local b = '╰' .. string.rep('*', opts.width - margin) .. '╯'
	table.insert(border, t);
	for _=1, opts.height - margin do
		table.insert(border, s);
	end
	table.insert(border, b);
	api.nvim_buf_set_lines(self.border_bufnr, 0, -1, true, border)
	return vim.tbl_extend('keep', opts, options)
end

function Window:store(name, win, buf)
	self.wins[name] = win
	self.bufs[name] = buf
end

function Window:open()
	-- self:load_cursor_pos()
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	-- if the editor is big enough
	if (width > 80 and height > 15) then
		-- the window height is 3/4 of the max height, but not more than 30
		local win_height = math.min(math.ceil(height * 3 / 4), 30)
		local win_width
		-- brute scale to width
		if (width < 100) then
			win_width = math.ceil(width * 0.5)
		else
			win_width = math.ceil(width * 0.3)
		end
		local opts = {
			relative = 'editor',
			style = 'minimal',
			width = win_width,
			height = win_height,
			row = math.ceil((height - win_height) / 2),
			col = math.ceil((width - win_width) / 1.5)
		}
		local border_options = self:create_border(opts)
		-- self.winnr = api.nvim_open_win(self.bufnr, false, opts)
		self.winnr = api.nvim_open_win(self.bufnr, true, opts)
		win_id = self.winnr
		self.border_winnr = api.nvim_open_win(self.border_bufnr, false, border_options)
		api.nvim_win_set_option(self.border_winnr, 'winhl', 'Normal:Floating')
		api.nvim_win_set_option(self.border_winnr, 'winblend', vim.g.openscad_cheatsheet_window_blend)
		api.nvim_win_set_option(self.winnr, 'winhl', 'Normal:Floating')
		api.nvim_win_set_option(self.winnr, 'winblend', vim.g.openscad_cheatsheet_window_blend)
		api.nvim_buf_set_option(self.bufnr, 'filetype', cheatsheet_filetype)
		self.read_file()
		-- print("openscad cheatsheet")
		self.place_cursor()

		-- Autoclose window when the WinLeave event is triggered
		api.nvim_command('autocmd WinLeave <buffer> lua require"openscad".self_close()')

	else
		print("w:", width, "h:", height, "term window is too small")
	end
end

function Window:close()
	-- Check if window is even open
	if not self:is_open() then
		return
	end

	self.save_cursor_pos()
	api.nvim_win_close(self.winnr, true)
	api.nvim_win_close(self.border_winnr, true)
end

function Window:destroy()

	-- Check if buffer is even open
	local buffer_is_open = api.nvim_buf_is_loaded(self.bufnr)
	if not self:is_valid() or not buffer_is_open then
		return
	end

	self.save_cursor_pos()

	if api.nvim_buf_is_loaded(self.bufnr) and api.nvim_buf_is_valid(self.bufnr) then
		api.nvim_buf_delete(self.bufnr, { force = true })
	end

	if api.nvim_buf_is_loaded(self.border_bufnr) and api.nvim_buf_is_valid(self.border_bufnr) then
		api.nvim_buf_delete(self.border_bufnr, { force = true })
	end
end


function Window:unload()

	-- Check if buffer is even open
	local buffer_is_open = api.nvim_buf_is_loaded(self.bufnr)
	if not self:is_valid() or not buffer_is_open then
		return
	end

	self.save_cursor_pos()

	if api.nvim_buf_is_loaded(self.bufnr) and api.nvim_buf_is_valid(self.bufnr) then
		api.nvim_buf_delete(self.bufnr, { unload = true })
	end

	if api.nvim_buf_is_loaded(self.border_bufnr) and api.nvim_buf_is_valid(self.border_bufnr) then
		api.nvim_buf_delete(self.border_bufnr, { unload = true })
	end
end

function Window:place_cursor()
	local pos = Window.last_cursor_pos or {1,0}
	api.nvim_win_set_cursor(0,pos)
end

function Window:save_cursor_pos()
	-- buggy..
	if fn.win_getid() == win_id then
		Window.last_cursor_pos = api.nvim_win_get_cursor(win_id)
	end
	-- print("O",win_id,"current", fn.win_getid())
	-- self.last_win = fn.winnr()
	-- self.last_pos = fn.getpos('.')
end

function Window:read_file()
	local path = require"openscad/utilities".get_plugin_root_dir() .. U.path_sep .. "help_source" .. U.path_sep .. "openscad_cheatsheet.scadhelp"
	api.nvim_command('silent read '  .. path)
end

-- function Window:load_cursor_pos()
-- 	if self.last_win and next(self.last_pos) then
-- 		cmd(self.last_win.." wincmd w")
-- 		fn.setpos('.', self.last_pos)
-- 		self.last_win = nil
-- 		self.last_pos = nil
-- 	end
-- end
return Window
