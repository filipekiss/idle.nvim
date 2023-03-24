local M = {}

function M.safe_require(module_name)
	local package_exists, module = pcall(require, module_name)
	if not package_exists then
		vim.defer_fn(function()
			vim.schedule(function()
				vim.notify(
					"Could not load module: " .. module_name,
					"error",
					{ title = "Module Not Found" }
				)
			end)
		end, 1000)
		return nil
	else
		return module
	end
end

return M
