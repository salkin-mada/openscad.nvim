local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

T = {}

function T:new()
    local x = {
        wins = {},
        bufs = {},
        config = {
            dimensions  = {
                height = 0.5, -- float 0.0-1.0 = 0-100%
                width = 0.5,
                row = 0.5,
                col = 0.5
            }
        }
    }

    self.__index = self
    return setmetatable(x, self)
end

function T:debug()
    print(vim.inspect(self))
end

function T:setup(c)
    c.dimensions = vim.tbl_extend('keep', c.dimensions or {}, self.config.dimensions)

    self.config = c
end

function T:store(name, win, buf)
    self.wins[name] = win
    self.bufs[name] = buf
end

function T:remember_cursor()
    self.last_win = fn.winnr()
    self.last_pos = fn.getpos('.')
end

function T:restore_cursor()
    if self.last_win and next(self.last_pos) then
        cmd(self.last_win.." wincmd w")
        fn.setpos('.', self.last_pos)
        self.last_win = nil
        self.last_pos = nil
    end
end

function T:win_dim()
    local d = self.config.dimensions
    local cl = vim.o.columns
    local ln = vim.o.lines
    local width = math.ceil(cl * d.width)
    local height = math.ceil(ln * d.height - 4)
    local col = math.ceil((cl - width) * d.col)
    local row = math.ceil((ln - height) * d.row - 1)


    return {
        width = width,
        height = height,
        col = col,
        row = row,
    }
end

function T:create_buf(name, do_border, height, width)
    local prev = self.bufs[name]
    if prev and api.nvim_buf_is_loaded(prev) then
        return prev
    end

    local buf = api.nvim_create_buf(false, true)

    if do_border then
        local border_lines = { '┌' .. string.rep('─', width) .. '┐' }
        for _ = 1, height do
            table.insert(border_lines, '|' .. string.rep(' ', width) .. '|')
        end
        table.insert(border_lines, '└' .. string.rep('─', width) .. '┘')
        api.nvim_buf_set_lines(buf, 0, -1, false, border_lines)
    end

    return buf
end

function T:create_win(buf, opts, bg_do)
    local win_handle = api.nvim_open_win(buf, true, opts)

    if bg_do then
        fn.nvim_win_set_option(win_handle, 'winhl', 'Normal:Normal')
    end

    return win_handle
end

function T:term()
    local first = false
    if vim.tbl_isempty(self.bufs) then
        first = true
        local pid = fn.termopen(os.getenv('SHELL'))
        self.terminal = pid
    end

    if first then
        cmd('call nvim_input(":term<CR>:startinsert<CR>htop<CR><F4>openscad<CR>")')
    end

    cmd("startinsert")

    function On_close()
        self:close(true)
    end

    cmd("autocmd! TermClose <buffer> lua On_close()")
end

function T:open()
    self:remember_cursor()

    local dim = self:win_dim()
    local opts = {
        relative = 'editor',
        style = 'minimal',
        width = dim.width + 2,
        height = dim.height + 2,
        col = dim.col - 1,
        row = dim.row - 1,
    }

    -- local bg_buf = self:create_buf('bg', true, dim.height, dim.width)
    local bg_buf = self:create_buf('bg', false, dim.height, dim.width) -- no border
    local bg_win = self:create_win(bg_buf, opts, true)

    opts.width = dim.width
    opts.height = dim.height
    opts.col = dim.col
    opts.row = dim.row

    local buf = self:create_buf('fg')
    local win = self:create_win(buf, opts)

    self:term()

    self:store('bg', bg_win, bg_buf)
    self:store('fg', win, buf)
end

function T:close(force)
    if next(self.wins) == nil then
        do return end
    end

    for _, win in pairs(self.wins) do
        if api.nvim_win_is_valid(win) then
            api.nvim_win_close(win, {})
        end
    end

    self.wins = {}

    if force then
        for _, buf in pairs(self.bufs) do
            if api.nvim_buf_is_loaded(buf) then
                -- api.nvim_buf_delete(buf, {})
                cmd(buf..'bd!')
            end
        end

        fn.jobstop(self.terminal)

        self.bufs = {}
        self.terminal = nil
    end

    self:restore_cursor()
end

function T:toggle()
    if vim.tbl_isempty(self.wins) then
        self:open()
    else
        self:close()
    end
end

return T
