local M = {}

function M.check()
    vim.health.start('openscad.nvim')

    -- Neovim version
    if vim.fn.has('nvim-0.10') ~= 1 then
        vim.health.error('openscad.nvim requires Neovim >= 0.10')
    else
        vim.health.ok('Neovim version OK')
    end

    -- Fuzzy finder (at least one required)
    local has_fzf    = pcall(require, 'fzf-lua')
    local has_snacks = pcall(require, 'snacks')
    local finder     = vim.g.openscad_fuzzy_finder or 'auto'

    if finder == 'fzf-lua' then
        if has_fzf then
            vim.health.ok('fuzzy finder: fzf-lua')
        else
            vim.health.error('vim.g.openscad_fuzzy_finder = "fzf-lua" but fzf-lua is not installed',
                { 'Install ibhagwan/fzf-lua' })
        end
    elseif finder == 'snacks' then
        if has_snacks then
            vim.health.ok('fuzzy finder: snacks.nvim')
        else
            vim.health.error('vim.g.openscad_fuzzy_finder = "snacks" but snacks.nvim is not installed',
                { 'Install folke/snacks.nvim' })
        end
    else -- 'auto'
        if has_fzf then
            vim.health.ok('fuzzy finder: fzf-lua (auto-detected)')
        elseif has_snacks then
            vim.health.ok('fuzzy finder: snacks.nvim (auto-detected)')
        else
            vim.health.error(
                'no fuzzy finder found',
                { 'Install ibhagwan/fzf-lua or folke/snacks.nvim' }
            )
        end
    end

    -- PDF viewer (optional, needed for :OpenscadManual)
    local pdf_cmd = vim.g.openscad_pdf_cmd
    if not pdf_cmd or pdf_cmd == '' then
        vim.health.warn(
            'vim.g.openscad_pdf_cmd is not set',
            { 'Set it to your PDF viewer binary, e.g. "zathura" (Linux) or "open" (macOS)' }
        )
    elseif vim.fn.executable(pdf_cmd) ~= 1 then
        vim.health.error(('pdf viewer "%s" is not executable'):format(pdf_cmd))
    else
        vim.health.ok(('pdf viewer: %s'):format(pdf_cmd))
    end

    -- LuaSnip (optional)
    if pcall(require, 'luasnip') then
        vim.health.ok('LuaSnip is installed (snippets available)')
    else
        vim.health.info('LuaSnip not found — install L3MON4D3/LuaSnip to enable snippets')
    end
end

return M
