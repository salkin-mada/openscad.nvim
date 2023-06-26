U = {}
U.name = 'openscad.nvim'
U.path_sep = '/' -- vim.os_uname().sysname:match('Windows') and '\\' or '/'

--- Get size (len) of table
---@param table The table to be counted.
---@return count
function U.get_len(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

--- Normalize a path to use Unix style separators: '/'.
function U.normalize(path)
  -- return (path:gsub('\\', '/'))
  return (string.gsub(path, '\\', '/'))
end

-- - Get the root dir of a plugin.
---@param plugin_name Optional plugin name, use nil to get openscad root dir.
---@return Absolute path to the plugin root dir.
function U.get_plugin_root_dir(plugin_name)
  plugin_name = plugin_name or 'openscad.nvim'
  local paths = vim.api.nvim_list_runtime_paths()
    -- for k,v in pairs(paths) do
    --     print(k,v)
    -- end
  for _, path in ipairs(paths) do
    local index = path:find(plugin_name)
    if index and path:sub(index, -1) == plugin_name then
      -- return U.normalize(path)
      return path
    end
  end
  error(string.format('Could not get root dir for %s', plugin_name))
end

--- Check if a module exists
---@param module The module name.
---@return bool true.
function U.module_exists(mod)
  return pcall(_G.require, mod) == true
end

U.openscad_nvim_root_dir = U.get_plugin_root_dir()

return U
