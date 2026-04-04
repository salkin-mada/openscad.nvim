local M = {}

-- Template uses __STEM__ as a placeholder replaced at deploy time.
-- Everything else ({{src}}, {{openscad}}, etc.) is just justfile syntax.
local TEMPLATE = [[
# openscad.nvim — generated justfile
# Usage with overseer.nvim : :OverseerRun
# Usage from terminal      : just stl
# Override source file     : just stl src=other_model

src := "__STEM__"

# OpenSCAD binary (auto-detected by OS)
openscad := if os() == "macos" { "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" } else { "openscad" }

# PNG options
imgsize     := "1920x1080"
colorscheme := "Cornfield"

# ── 3D formats ────────────────────────────────────────────────────────────────

stl:
    {{openscad}} -o {{src}}.stl {{src}}.scad

stl-ascii:
    {{openscad}} --export-format asciistl -o {{src}}.stl {{src}}.scad

stl-binary:
    {{openscad}} --export-format binstl -o {{src}}.stl {{src}}.scad

off:
    {{openscad}} -o {{src}}.off {{src}}.scad

amf:
    {{openscad}} -o {{src}}.amf {{src}}.scad

# threemf (.3mf) - 3D Manufacturing Format
threemf:
    {{openscad}} -o {{src}}.3mf {{src}}.scad

csg:
    {{openscad}} -o {{src}}.csg {{src}}.scad

# ── 2D formats ────────────────────────────────────────────────────────────────

svg:
    {{openscad}} -o {{src}}.svg {{src}}.scad

dxf:
    {{openscad}} -o {{src}}.dxf {{src}}.scad

pdf:
    {{openscad}} -o {{src}}.pdf {{src}}.scad

# ── Image ─────────────────────────────────────────────────────────────────────

# Full render (slow, accurate)
png:
    {{openscad}} --render --imgsize={{imgsize}} --autocenter --viewall \
        --colorscheme={{colorscheme}} -o {{src}}.png {{src}}.scad

# Fast preview render (thrown-together)
png-preview:
    {{openscad}} --preview=throwntogether --imgsize={{imgsize}} --autocenter --viewall \
        --colorscheme={{colorscheme}} -o {{src}}.png {{src}}.scad

# ── Bundles ───────────────────────────────────────────────────────────────────

all-3d: stl off amf threemf

all-2d: svg dxf pdf

all: all-3d all-2d png
]]

---Deploy a justfile into the directory of the current .scad file (or cwd).
---@param force boolean overwrite an existing justfile when true
function M.deploy(force)
    local buf_path = vim.fn.expand('%:p')
    local dir

    if buf_path ~= '' and vim.fn.expand('%:e') == 'scad' then
        dir  = vim.fn.expand('%:p:h')
    else
        dir  = vim.fn.getcwd()
    end

    local stem = (buf_path ~= '' and vim.fn.expand('%:t:r') ~= '')
        and vim.fn.expand('%:t:r')
        or  'model'

    local dest = dir .. '/justfile'

    if vim.fn.filereadable(dest) == 1 and not force then
        vim.notify(
            ('openscad.nvim: %s already exists — use :OpenscadJustfile! to overwrite'):format(dest),
            vim.log.levels.WARN
        )
        return
    end

    local content = TEMPLATE:gsub('__STEM__', stem)
    -- strip the leading newline the template literal adds
    content = content:gsub('^\n', '')

    local ok, err = pcall(function()
        local fh = assert(io.open(dest, 'w'), 'cannot open ' .. dest)
        fh:write(content)
        fh:close()
    end)

    if not ok then
        vim.notify('openscad.nvim: failed to write justfile — ' .. tostring(err), vim.log.levels.ERROR)
        return
    end

    vim.notify(('openscad.nvim: justfile written to %s'):format(dest), vim.log.levels.INFO)
end

return M
