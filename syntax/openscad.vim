" This file is part of openscad.nvim
"
" openscad.nvim is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" openscad.nvim is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with openscad.nvim.  If not, see <http://www.gnu.org/licenses/>.
"
" Vim syntax file
" Language: openscad (openscad file markup)
"
" Maintainer: Niklas Adam <salkinmada@protonmail.com>
" Version:	0.1
" Modified:	2020-09-12
" 
"
" Building on the work of Sirtaj Singh Kang and others for vim-openscad

scriptencoding utf-8

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'openscad'

setlocal iskeyword=a-z,A-Z,48-57,_

syn match openscadAoperator "{"
syn match openscadAoperator "}"
syn match openscadLi "\["
syn match openscadLi "\]"
syn match openscadPar "("
syn match openscadPar ")"

syn match openscadSpecialVariable "\$[a-zA-Z_]\+\>" display
syn match openscadModifier "^\s*[\*\!\#\%]" display

syn match openscadBinaryoperator "+"
syn match openscadBinaryoperator "-"
syn match openscadBinaryoperator "*"
syn match openscadBinaryoperator "/"
syn match openscadBinaryoperator "%"
syn match openscadBinaryoperator "\*\*"
syn match openscadBinaryoperator "<"
syn match openscadBinaryoperator "<="
syn match openscadBinaryoperator ">"
syn match openscadBinaryoperator ">="
syn match openscadBinaryoperator "="
syn match openscadBinaryoperator "=="
syn match openscadBinaryoperator "==="
syn match openscadBinaryoperator "!="
syn match openscadBinaryoperator "!=="
syn match openscadBinaryoperator "&"
syn match openscadBinaryoperator "|"
syn match openscadBinaryoperator "<!"
syn match openscadBinaryoperator "?"
syn match openscadBinaryoperator "??"
syn match openscadBinaryoperator "!?"
syn match openscadBinaryoperator "!"
syn match openscadBinaryoperator "#"
syn match openscadBinaryoperator "_"
syn match openscadBinaryoperator "\.\."
syn match openscadBinaryoperator "\.\.\."
syn match openscadBinaryoperator "`"
syn match openscadBinaryoperator ":"

syn keyword openscadFunctionDef function nextgroup=openscadFunction skipwhite skipempty
syn match openscadFunction /\<\h\w*\>/ contained display

syn keyword openscadModuleDef module nextgroup=openscadModule skipwhite skipempty
syn match openscadModule /\<\h\w*\>/ contained display

syn keyword openscadStatement echo assign let assert
syn keyword openscadConditional if else
syn keyword openscadRepeat for intersection_for
syn keyword openscadInclude include use
syn keyword openscadCsgKeyword union difference intersection render intersection_for
syn keyword openscadTransform scale rotate translate resize mirror multmatrix color minkowski hull projection linear_extrude rotate_extrude offset
syn keyword openscadPrimitiveSolid cube sphere cylinder polyhedron surface
syn keyword openscadPrimitive2D square circle polygon import_dxf text
syn keyword openscadPrimitiveImport import child children

syn match openscadNumbers "\<\d\|\.\d" contains=openscadNumber display transparent
syn match openscadNumber "\d\+" display contained 
syn match openscadNumber "\.\d\+" display contained 

syn region openscadString start=/"/ skip=/\\"/ end=/"/

syn keyword openscadBoolean true false

syn keyword openscadCommentTodo TODO FIXME XXX NOTE contained display
syn match openscadInlineComment ://.*$: contains=openscadCommentTodo
syn region openscadBlockComment start=:/\*: end=:\*/: fold contains=openscadCommentTodo

syn region openscadBlock start="{" end="}" transparent fold
syn region openscadVector start="\[" end="\]" transparent fold

syn keyword openscadBuiltin abs acos asin atan atan2 ceil cos exp floor ln log
syn keyword openscadBuiltin lookup max min pow rands round sign sin sqrt tan
syn keyword openscadBuiltin str len search version version_num concat chr ord cross norm
syn keyword openscadBuiltin parent_module
syn keyword openscadBuiltin dxf_cross dxf_dim
syn keyword openscadBuiltinSpecial PI undef

"""""""""""""""""""""""""""""""""""""""""
" linkage
"""""""""""""""""""""""""""""""""""""""""
hi def link openscadFunctionDef			Structure
hi def link openscadAoperator 			Function
hi def link openscadLi 		 			Function
" hi def link openscadPar 	 			Structure
hi def link openscadBuiltinSpecial 		Special
hi def link openscadBinaryoperator 		Special
hi def link openscadFunction			Function
hi def link openscadModuleDef			Structure
hi def link openscadModule			    Function
hi def link openscadBlockComment		Comment
hi def link openscadBoolean			    Boolean
hi def link openscadBuiltin			    Function
hi def link openscadConditional			Conditional
hi def link openscadCsgKeyword			Structure
hi def link openscadInclude			    Include
hi def link openscadInlineComment	    Comment
hi def link openscadModifier			Special
hi def link openscadStatement			Statement
hi def link openscadNumbers			    Number
hi def link openscadNumber			    Number
hi def link openscadPrimitiveSolid		Keyword
hi def link openscadPrimitive2D 		Keyword
hi def link openscadPrimitiveImport 	Keyword
hi def link openscadRepeat			    Repeat
hi def link openscadSpecialVariable		Special
hi def link openscadString			    String
hi def link openscadTransform			Statement
hi def link openscadCommentTodo			Todo

" Blatantly stolen from vim74\syntax\c.vim
"when wanted, highlight trailing white space
if exists("openscad_space_errors")
  if !exists("openscad_no_trail_space_error")
    syn match	openscadSpaceError	display excludenl "\s\+$"
  endif
  if !exists("openscad_no_tab_space_error")
    syn match	openscadSpaceError	display " \+\t"me=e-1
  endif
endif
