# openscad.nvim

Syntax highlighting, cheatsheet, snippets, offline manual and fuzzy help plugin for the openscad language

OpenSCAD help system and syntax highlighting in Neovim.
This plugin was first created as a companion to [the original openscad syntax highlighting](https://github.com/sirtaj/vim-openscad).
But it now contains a modified and updated version. In addition a `openscad-help` filetype and syntax is implemented.

In the future maybe lsp, error checking, hints and completion will exist here. 

**This plugin needs Neovim version => `v0.10.0`

## Dependencies

- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)(optional)

Run `:checkhealth openscad` to see if all is good.

## Install

* Using rocks.nvim
```vim
:Rocks install salkin-mada/openscad.nvim
:Rocks install ibhagwan/fzf-lua
:Rocks install L3MON4D3/LuaSnip
```
* Using lazy.nvim

```lua
    {
        'salkin-mada/openscad.nvim',
        enabled = true,
        config = function ()
            require('openscad')
            vim.g.openscad_load_snippets = true
        end,
        dependencies = {
            'ibhagwan/fzf-lua',
            'L3MON4D3/LuaSnip'
        }
    }
```

## Available mappings

`<Enter>`/`<C-m>` in normal mode
Toggle cheatsheet window
![cheatsheet](https://oddodd.org/openscad.nvim-assets/cheatsheet-gifsicled.gif)

`<A-h>` in normal mode
Fuzzy find help resource
![help](https://oddodd.org/openscad.nvim-assets/help-gifsicled.gif)

`<A-m>` in normal mode
Open offline openscad manual in pdf via `zathura`
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
vim.g.openscad_fuzzy_profile = 'default'
vim.g.openscad_cheatsheet_window_blend = 15 --%
vim.g.openscad_load_snippets = false
-- should the openscad project automatically be opened on startup
vim.g.openscad_auto_open = false
```

## Fuzzy profiles

| Profile          | Details                                    |
| ---------------- | ------------------------------------------ |
| `default`          | fzf-lua defaults, uses neovim "builtin" previewer and devicons (if available) for git/files/buffers |
| `fzf-native`       | utilizes fzf's native previewing ability in the terminal where possible using `bat` for previews |
| `fzf-tmux`         | similar to `fzf-native` and opens in a tmux popup (requires tmux > 3.2) |
| `max-perf`         | similar to `fzf-native` and disables icons globally for max performance |
| `telescope`        | closest match to telescope defaults in look and feel and keybinds |
| `skim`             | uses [`skim`](https://github.com/lotabout/skim) as an fzf alternative, (requires the `sk` binary) |

## Mappings

`openscad.nvim` mappings is by default *not* enabled.

```lua
vim.g.openscad_default_mappings = true
```

The default mappings are:
```lua
vim.g.openscad_cheatsheet_toggle_key = '<Enter>'
vim.g.openscad_help_trig_key = '<A-h>'
vim.g.openscad_help_manual_trig_key = '<A-m>'
vim.g.openscad_exec_openscad_trig_key = '<A-o>'
vim.g.openscad_top_toggle = '<A-c>'
```

* *Options* and *Mappings* may be defined in either Lua or Vimscript.
