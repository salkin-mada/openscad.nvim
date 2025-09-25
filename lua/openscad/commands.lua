-- these could just aswell have been in a "plugin" folder just as a openscad.lua file..

-- COMMAND
-- :OpenscadHelp
-- Fuzzy search and open help files
vim.cmd("command! OpenscadHelp lua require('openscad').help()")

-- COMMAND
-- :OpenscadExecFile
-- Execute current file in openscad
vim.cmd("command! OpenscadExecFile lua require('openscad').exec_openscad()")

-- COMMAND
-- :OpenscadCheatsheet
-- Toggle cheatsheet
vim.cmd("command! OpenscadCheatsheet lua require('openscad').toggle()")

-- COMMAND
-- :OpenscadManual
-- Open manual using external pdf reader
vim.cmd("command! OpenscadManual lua require('openscad').manual()")
