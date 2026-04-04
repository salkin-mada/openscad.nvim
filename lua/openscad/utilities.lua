local U = {}
U.name = 'openscad.nvim'

---@param plugin_name? string defaults to 'openscad.nvim'
---@return string absolute path to the plugin root directory
function U.get_plugin_root_dir(plugin_name)
    plugin_name = plugin_name or 'openscad.nvim'
    for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
        if path:sub(-#plugin_name) == plugin_name then
            return path
        end
    end
    error(('openscad.nvim: could not find root dir for %s'):format(plugin_name))
end

U.openscad_nvim_root_dir = U.get_plugin_root_dir()

return U
