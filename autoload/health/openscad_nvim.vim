function! s:check_nvim_version_minimum() abort
	if !has('nvim-0.5.0')
		call health#report_error('has(nvim-0.5.0)','requires nvim 0.5.0 or later')
	else
		call health#report_ok("nvim version: satisfied")
	endif
endfunction

function! s:check_zathura_installed() abort
	if !executable('zathura')
		call health#report_error('has(zathura)','install zathura')
	else
		call health#report_ok("zathura is installed")
	endif
endfunction

function! s:check_htop_installed() abort
	if !executable('htop')
		call health#report_error('has(htop)','install htop')
	else
		call health#report_ok("htop is installed")
	endif
endfunction

function! s:check_fuzzy_finder() abort
	if match(&runtimepath, 'skim.vim') != -1
		call health#report_ok('skim.vim is installed')
	elseif match(&runtimepath, 'fzf.vim') != -1
		call health#report_ok('fzf.vim is installed')
	else
		call health#report_error('No fuzzy finder :( install skim.vim or fzf.vim')
	endif
endfunction

function! health#openscad_nvim#check() abort
	call health#report_start('openscad.nvim')
	call s:check_nvim_version_minimum()
	call s:check_zathura_installed()
	call s:check_htop_installed()
	call s:check_fuzzy_finder()
endfunction
