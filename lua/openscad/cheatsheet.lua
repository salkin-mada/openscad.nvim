local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local C = {}
local W = require'openscad.window'
local win_id
local window -- instance
function C:new()
	local tbl =  {
		name = 'openscad-cheatsheet',
		filetype = 'openscad-help',
		wins = {},
		bufs = {},
		config = {
			bufconstructor = {
				win_buftype = 'nowrite',
				is_win_buflisted = true,
				border_buftype = 'nowrite',
				is_border_buflisted = true,
			},
			dimensions = {
				height = 0.5, -- float 0.0-1.0 = 0-100%
				width = 0.5,
				row = 0.5,
				col = 0.5
			}
		}
	}

	window = W:new(tbl)
	self.__index = self
	local options = { noremap = true, nowait = true, silent = true }
	-- local key = tostring(vim.g.openscad_cheatsheet_toggle_key)
	-- api.nvim_buf_set_keymap(self.bufnr, 'n', key, '<cmd> lua require"openscad".self_close()<cr>', options)
	api.nvim_buf_set_keymap(window.bufnr, 'n', '<Enter>', '<cmd> lua require"openscad".self_close()<cr>', options)
	return tbl
end

function C:is_open()
	return window.is_open()
end

function C:is_valid()
	return self.bufnr and api.nvim_buf_is_loaded(self.bufnr) or false
end

function C:store(name, win, buf)
	self.wins[name] = win
	self.bufs[name] = buf
end

function C:open()
	-- self:load_cursor_pos()
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	-- if the editor is big enough
	-- if (width > 80 and height > 15) then
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
		self.store('bg', self.border_winnr, self.border_bufnr)
		self.store('fg', self.winnr, self.bufnr)
		self.place_cursor()
	-- else
	-- 	print("w:", width, "h:", height, "term window is too small")
	-- end
end

function C:close()
	window.close()
end

function C:destroy()
	window.destroy()
end

function C:unload()
	window.unload()
end

function C:place_cursor()
	-- local pos = Window.last_cursor_pos or {1,0}
	-- api.nvim_win_set_cursor(0,pos)
	if self.last_win and next(self.last_pos) then
		cmd(self.last_win.." wincmd w")
		fn.setpos('.', self.last_pos)
		self.last_win = nil
		self.last_pos = nil
	end
end

function C:save_cursor_pos()
	-- buggy..
	-- if fn.win_getid() == win_id then
	-- 	Window.last_cursor_pos = api.nvim_win_get_cursor(win_id)
	-- end
	-- print("O",win_id,"current", fn.win_getid())
	self.last_win = fn.winnr()
	self.last_pos = fn.getpos('.')
end

function C:read_file()
	local path = U.openscad_nvim_root_dir .. U.path_sep .. "help_source" .. U.path_sep .. "openscad_cheatsheet.scadhelp"
	api.nvim_command('silent read '  .. path)
end

return C
