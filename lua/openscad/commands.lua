local function cmd(name, fn, opts)
    vim.api.nvim_create_user_command(name, fn, opts or {})
end

-- :OpenscadHelp — fuzzy-search help files with fzf-lua
cmd('OpenscadHelp',       function() require('openscad').help() end)

-- :OpenscadExecFile — open current file in OpenSCAD
cmd('OpenscadExecFile',   function() require('openscad').exec_openscad() end)

-- :OpenscadCheatsheet — toggle the cheatsheet floating window
cmd('OpenscadCheatsheet', function() require('openscad').toggle() end)

-- :OpenscadManual — open the offline PDF manual
cmd('OpenscadManual',     function() require('openscad').manual() end)

-- :OpenscadJustfile[!] — deploy a justfile template with all export recipes
-- Use ! to overwrite an existing justfile
cmd('OpenscadJustfile',   function(args) require('openscad').deploy_justfile(args.bang) end, { bang = true })
