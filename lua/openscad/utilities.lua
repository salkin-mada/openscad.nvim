U = {}
U.name = 'openscad.nvim'
U.path_sep = vim.loop.os_uname().sysname:match('Windows') and '\\' or '/'

function U.get_len(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

function U.get_plugin_root_dir()
	local package_path = debug.getinfo(1).source:gsub('@', '')
	package_path = vim.split(package_path, U.path_sep, true)
	-- find index of plugin root dir
	local index = 1
	for i, v in ipairs(package_path) do
		if v == U.name then
			index = i
			break
		end
	end
	local path_len = U.get_len(package_path)
	if index == 1 or index == path_len then
		error('['..U.name..'] could not find plugin root dir')
	end
	local path = {}
	for i, v in ipairs(package_path) do
		if i > index then
			break
		end
		path[i] = v
	end
	local dir = ''
	for _, v in ipairs(path) do
		-- first element is empty on unix
		if v == '' then
			dir = U.path_sep
		else
			dir = dir .. v .. U.path_sep
		end
	end
	assert(dir ~= '', '['..U.name..'] Could not get plugin root path')
	dir = dir:sub(1, -2) -- delete trailing slash
	return dir
end

function U.module_exists(mod)
  return pcall(_G.require, mod) == true
end

U.openscad_nvim_root_dir = U.get_plugin_root_dir()

return U
