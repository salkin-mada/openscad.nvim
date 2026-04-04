# openscad.nvim

Syntax highlighting, cheatsheet, snippets, offline manual and fuzzy help plugin for the OpenSCAD language.

> **This is a rewritten version targeting Neovim 0.10+
> The previous version is preserved on the [`old`](../../tree/old) branch if you need it.

**Requires Neovim >= 0.10

## Dependencies

- [fzf-lua](https://github.com/ibhagwan/fzf-lua) or [snacks.nvim](https://github.com/folke/snacks.nvim) (for the help picker)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (optional, for snippets)

Run `:checkhealth openscad` to verify your setup.

## Install

### vim.pack (Neovim 0.12 built-in)

Add to `init.lua` or the `plugin` folder:

```lua
vim.pack.add({
    'https://github.com/salkin-mada/openscad.nvim',
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/L3MON4D3/LuaSnip', -- optional, for snippets
})

vim.g.openscad_load_snippets = true
require('openscad')
```

> **Note:** `vim.pack.add` only accepts remote URLs — local paths are not supported.
> For local development or forks, prepend the path to the runtime instead:
>
> ```lua
> vim.opt.runtimepath:prepend('/path/to/openscad.nvim')
> require('openscad')
> ```

### lazy.nvim

```lua
{
    'salkin-mada/openscad.nvim',
    config = function()
        vim.g.openscad_load_snippets = true
        require('openscad')
    end,
    dependencies = {
        'ibhagwan/fzf-lua',
        'L3MON4D3/LuaSnip', -- optional
    },
}
```

## Available mappings

`<Enter>` in normal mode — toggle cheatsheet window

![cheatsheet](https://oddodd.org/openscad.nvim-assets/cheatsheet-gifsicled.gif)

`<A-h>` in normal mode — fuzzy-search help files

![help](https://oddodd.org/openscad.nvim-assets/help-gifsicled.gif)

`<A-m>` in normal mode — open offline OpenSCAD manual via your PDF viewer

![manual](https://oddodd.org/openscad.nvim-assets/manual-gifsicled.gif)

`<A-o>` in normal mode — open current file in OpenSCAD

![execute](https://oddodd.org/openscad.nvim-assets/execute-gifsicled.gif)

## Options

```lua
-- Enable the default key mappings listed above (off by default)
vim.g.openscad_default_mappings = false

-- PDF viewer binary used by <A-m> / :OpenscadManual
-- Linux:  vim.g.openscad_pdf_cmd = 'zathura'
-- macOS:  vim.g.openscad_pdf_cmd = 'open'
vim.g.openscad_pdf_cmd = ''

-- Fuzzy finder for the help picker.
-- 'auto'    — use fzf-lua if installed, fall back to snacks.nvim (default)
-- 'fzf-lua' — always use fzf-lua
-- 'snacks'  — always use snacks.nvim
vim.g.openscad_fuzzy_finder = 'auto'

-- Load LuaSnip snippets on startup
vim.g.openscad_load_snippets = false

-- Automatically open the current file in OpenSCAD on startup
vim.g.openscad_auto_open = false
```

## Custom mappings

Mappings are disabled by default. Set `vim.g.openscad_default_mappings = true` to enable the defaults, or configure individual keys:

```lua
vim.g.openscad_cheatsheet_toggle_key  = '<Enter>'
vim.g.openscad_help_trig_key          = '<A-h>'
vim.g.openscad_manual_trig_key        = '<A-m>'
vim.g.openscad_exec_openscad_trig_key = '<A-o>'
```

Options and mappings may be defined in either Lua or Vimscript.

## Commands

| Command                | Action                                      |
| ---------------------- | ------------------------------------------- |
| `:OpenscadCheatsheet`  | Toggle cheatsheet floating window           |
| `:OpenscadHelp`        | Fuzzy-search help files with fzf-lua        |
| `:OpenscadManual`      | Open the offline PDF manual                 |
| `:OpenscadExecFile`    | Open current file in OpenSCAD               |
| `:OpenscadJustfile[!]` | Deploy a justfile export template (see below) |

## Justfile export templates (overseer.nvim)

`:OpenscadJustfile` writes a `justfile` into the directory of the current `.scad` file. The `src` variable is pre-filled with the current filename stem — editing `wheel.scad` gives you `src := "wheel"`.

Use `!` to overwrite an existing file: `:OpenscadJustfile!`

### Usage with overseer.nvim

[overseer.nvim](https://github.com/stevearc/overseer.nvim) has a built-in `just` template provider, so once the justfile is deployed you can launch any export recipe directly from Neovim:

```
:OverseerRun
```

overseer will list all available recipes. Select one and it runs in a managed task window.

### Usage from the terminal

```sh
just stl              # export STL
just png              # render PNG (full, slow)
just all              # export all formats
just stl src=mypart   # override the source file
```

### Export recipes

| Recipe        | Output file   | Notes                                       |
| ------------- | ------------- | ------------------------------------------- |
| `stl`         | `.stl`        | ASCII STL (OpenSCAD default)                |
| `stl-ascii`   | `.stl`        | Explicitly ASCII                            |
| `stl-binary`  | `.stl`        | Binary STL (smaller file)                   |
| `off`         | `.off`        | Object File Format                          |
| `amf`         | `.amf`        | Additive Manufacturing Format               |
| `threemf`     | `.3mf`        | 3D Manufacturing Format                     |
| `csg`         | `.csg`        | OpenSCAD CSG tree                           |
| `svg`         | `.svg`        | 2D — requires a 2D object                  |
| `dxf`         | `.dxf`        | 2D — requires a 2D object                  |
| `pdf`         | `.pdf`        | 2D — requires a 2D object                  |
| `png`         | `.png`        | Full render, 1920×1080, autocenter/viewall  |
| `png-preview` | `.png`        | Fast thrown-together preview                |
| `all-3d`      | —             | Runs: `stl off amf threemf`                 |
| `all-2d`      | —             | Runs: `svg dxf pdf`                         |
| `all`         | —             | Runs: `all-3d all-2d png`                   |

The `openscad` variable in the justfile is auto-detected by OS — it uses the macOS `.app` bundle path on macOS and `openscad` from `$PATH` on Linux.
