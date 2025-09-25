# openscad.nvim

Syntax highlighting, cheatsheet, snippets, offline manual and fuzzy help plugin for the openscad language

OpenSCAD help system and syntax highlighting in Neovim.
This plugin was first created as a companion to [the original openscad syntax highlighting](https://github.com/sirtaj/vim-openscad).
But it now contains a modified and updated version. In addition a `openscad-help` filetype and syntax is implemented.

In the future maybe lsp, error checking, hints and completion will exist here. 

Note that some features of this plugin is `*NIX` only

## Requirements

Nvim >= 0.5

## Dependencies

Run `:checkhealth` to see if you fulfill the dependencies and requirements.

- [zathura](https://github.com/pwmt/zathura) or another pdf viewer
- [skim](https://github.com/lotabout/skim.vim), [fzf](https://github.com/junegunn/fzf.vim) or [snacks.nvim](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)
- [htop](https://htop.dev)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)(optional)

## Install

* Using `packer.nvim`
    ```lua
    use {
        'salkin-mada/openscad.nvim',
        config = function ()
            require('openscad')
            -- load snippets, note requires
            vim.g.openscad_load_snippets = true
        end,
        requires = 'L3MON4D3/LuaSnip'
    }
    ```
* Using `lazy.nvim`
    ```lua
    {
        "salkin-mada/openscad.nvim",
        config = function()
            vim.g.openscad_load_snippets = true
            require("openscad")
        end,
        dependencies = { "L3MON4D3/LuaSnip", "junegunn/fzf.vim" },
    },
    ```


## Available mappings

`<Enter>`/`<C-m>` in normal mode
Toggle cheatsheet window
![cheatsheet](https://oddodd.org/openscad.nvim-assets/cheatsheet-gifsicled.gif)

`<A-h>` in normal mode
Fuzzy find help resource
![help](https://oddodd.org/openscad.nvim-assets/help-gifsicled.gif)

`<A-m>` in normal mode
Open offline openscad manual in pdf via pdf command (if one is set)
![manual](https://oddodd.org/openscad.nvim-assets/manual-gifsicled.gif)

`<A-o>` in normal mode
Open file in OpenSCAD
![execute](https://oddodd.org/openscad.nvim-assets/execute-gifsicled.gif)

`<A-c>` in normal mode
toggle `htop` filtered for openscad processes
![execute](https://oddodd.org/openscad.nvim-assets/htop-gifsicled.gif)

## Options

These are the defaults:
```lua
vim.g.openscad_fuzzy_finder = 'skim'
-- when the pdf_command is run, the last argument will be the pdf filename
vim.g.openscad_pdf_command = ''
vim.g.openscad_cheatsheet_window_blend = 15 --%
vim.g.openscad_load_snippets = false
-- should the openscad project automatically be opened on startup
vim.g.openscad_auto_open = false
```

## Mappings

`openscad.nvim` mappings is by default *not* enabled.

```lua
vim.g.openscad_default_mappings = true
```

The default mappings are:
```lua
vim.g.openscad_cheatsheet_toggle_key = '<Enter>'
vim.g.openscad_help_trig_key = '<A-h>'
vim.g.openscad_manual_trig_key = '<A-m>'
vim.g.openscad_exec_openscad_trig_key = '<A-o>'
vim.g.openscad_top_toggle = '<A-c>'
```

* *Options* and *Mappings* may be defined in either Lua or Vimscript.
