local M = {}

---Checks if a plugin is installed
---@param plugin string
---@return boolean
function M.is_installed(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

return M
