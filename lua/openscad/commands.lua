-- these could just aswell have been in a "plugin" folder just as a openscad.lua file..
--
-- COMMAND
-- :OpenscadTopToggle
-- toggle a top looking at openscad
vim.cmd("command! OpenscadTopToggle lua require('openscad').topToggle()")
