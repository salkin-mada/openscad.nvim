local api = vim.api
local Window = {}
local cheatsheet_filetype = 'openscad-help'

function Window:new(tbl)
    tbl = tbl or {}
    setmetatable(tbl, self)
    self.__index = self

    tbl.bufnr        = api.nvim_create_buf(false, true)
    tbl.backdrop_buf = api.nvim_create_buf(false, true)
    vim.bo[tbl.bufnr].buftype   = 'nofile'
    vim.bo[tbl.bufnr].buflisted = false

    local toggle_key = vim.g.openscad_cheatsheet_toggle_key or '<Enter>'
    local close = function() require('openscad').self_close() end
    local opts = { buffer = tbl.bufnr, noremap = true, nowait = true, silent = true,
                   desc = 'openscad: close cheatsheet' }
    vim.keymap.set('n', toggle_key, close, opts)
    vim.keymap.set('n', '<Esc>',    close, opts)

    return tbl
end

function Window:is_open()
    return self.winnr ~= nil and api.nvim_win_is_valid(self.winnr)
end

function Window:is_valid()
    return self.bufnr ~= nil and api.nvim_buf_is_loaded(self.bufnr)
end

function Window:open()
    local width  = vim.o.columns
    local height = vim.o.lines

    -- Full-screen backdrop at zindex 49 dims everything behind the cheatsheet
    self.backdrop_win = api.nvim_open_win(self.backdrop_buf, false, {
        relative  = 'editor',
        style     = 'minimal',
        border    = 'none',
        width     = width,
        height    = height,
        row       = 0,
        col       = 0,
        focusable = false,
        zindex    = 49,
    })
    api.nvim_set_hl(0, 'OpenscadBackdrop', { bg = 0x000000 })
    vim.wo[self.backdrop_win].winhighlight = 'Normal:OpenscadBackdrop'
    vim.wo[self.backdrop_win].winblend     = 55

    -- Cheatsheet window on top
    local win_width  = math.min(math.max(math.floor(width  * 0.45), 30), width  - 4)
    local win_height = math.min(math.max(math.floor(height * 0.7),   5), height - 4)

    self.winnr = api.nvim_open_win(self.bufnr, true, {
        relative    = 'editor',
        style       = 'minimal',
        border      = 'single',
        title       = ' openscad.nvim ',
        title_pos   = 'center',
        width       = win_width,
        height      = win_height,
        row         = math.floor((height - win_height) / 2),
        col         = math.floor((width  - win_width)  / 2),
        zindex      = 50,
    })

    -- Border fg: pure white on dark backgrounds, pure black on light — max contrast regardless of colorscheme
    local border_fg = vim.o.background == 'dark' and 0xffffff or 0x000000
    api.nvim_set_hl(0, 'OpenscadCheatsheetBorder', { fg = border_fg })

    vim.wo[self.winnr].winhighlight = 'Normal:Normal,FloatBorder:OpenscadCheatsheetBorder,FloatTitle:Normal'
    vim.wo[self.winnr].winblend     = 0
    vim.wo[self.winnr].winfixbuf    = true
    vim.bo[self.bufnr].filetype     = cheatsheet_filetype

    -- Only read the file once; subsequent opens reuse the buffered content
    if api.nvim_buf_line_count(self.bufnr) <= 1 then
        self:read_file()
    end

    self:place_cursor()

    api.nvim_create_autocmd('WinClosed', {
        pattern  = tostring(self.winnr),
        once     = true,
        callback = function() require('openscad').self_close() end,
    })
end

function Window:close()
    if not self:is_open() then return end
    self:save_cursor_pos()
    if self.backdrop_win and api.nvim_win_is_valid(self.backdrop_win) then
        api.nvim_win_close(self.backdrop_win, true)
        self.backdrop_win = nil
    end
    api.nvim_win_close(self.winnr, true)
end

function Window:place_cursor()
    local pos = Window.last_cursor_pos or { 1, 0 }
    api.nvim_win_set_cursor(self.winnr, pos)
end

function Window:save_cursor_pos()
    if self.winnr and api.nvim_win_is_valid(self.winnr) then
        Window.last_cursor_pos = api.nvim_win_get_cursor(self.winnr)
    end
end

function Window:read_file()
    local U = require('openscad.utilities')
    local path = U.openscad_nvim_root_dir .. '/help_source/openscad_cheatsheet.scadhelp'
    vim.cmd('silent read ' .. vim.fn.fnameescape(path))
end

return Window
