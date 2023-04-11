local M = {}

function M.is_installed(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

return M
