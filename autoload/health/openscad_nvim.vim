function! s:check_nvim_version_minimum() abort
	if !has('nvim-0.5.0')
		call v:lua.vim.health.error('has(nvim-0.5.0)','requires nvim 0.5.0 or later')
	else
		call v:lua.vim.health.ok("nvim version: satisfied")
	endif
endfunction

function! s:check_htop_installed() abort
	if !executable('htop')
		call v:lua.vim.health.error('has(htop)','install htop')
	else
		call v:lua.vim.health.ok("htop is installed")
	endif
endfunction

function! s:check_fuzzy_finder() abort
	if match(&runtimepath, 'skim.vim') != -1
		call v:lua.vim.health.ok('skim.vim is installed')
	elseif match(&runtimepath, 'fzf.vim') != -1
		call v:lua.vim.health.ok('fzf.vim is installed')
	elseif match(&runtimepath, 'snacks.nvim') != -1
    try
        if luaeval("pcall(function() local s = require('snacks'); return s.picker ~= nil end)") 
            call v:lua.vim.health.ok('snacks.nvim is installed and picker is available')
        else
            call v:lua.vim.health.warn('snacks.nvim is installed but picker is missing')
        endif
    catch
        call v:lua.vim.health.error('No fuzzy finder :( install skim.vim, fzf.vim, or snacks.nvim')
    endtry
	else
		call v:lua.vim.health.error('No fuzzy finder :( install skim.vim or fzf.vim')
	endif
endfunction

function! health#openscad_nvim#check() abort
	call v:lua.vim.health.start('openscad.nvim')
	call s:check_nvim_version_minimum()
	call s:check_zathura_installed()
	call s:check_htop_installed()
	call s:check_fuzzy_finder()
endfunction
