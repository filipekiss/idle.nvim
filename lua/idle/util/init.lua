local Config = require("idle.config")
local M = {}

function M.safe_require(module_name, opts)
	local defaults = {
		silent = false,
	}
	local options = vim.tbl_deep_extend("force", defaults, opts or {})
	local package_exists, module = pcall(require, module_name)
	if not package_exists then
		if options.silent == false then
			vim.defer_fn(function()
				vim.schedule(function()
					M.error(
						"Could not load module: " .. module_name,
						{ title = "Module Not Found" }
					)
				end)
			end, 1000)
		end
		return nil
	else
		return module
	end
end

function M.notify(msg, opts)
	local lazy_notify = require("lazy.core.util").notify
	opts.title = opts.title or "idle.nvim"
	lazy_notify(msg, opts)
end

function M.error(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.ERROR
	M.notify(msg, opts)
end

function M.info(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.INFO
	M.notify(msg, opts)
end

function M.warn(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.WARN
	M.notify(msg, opts)
end

function M.debug(msg, opts)
	if not Config.debug == true then
		return
	end
	opts = opts or {}
	opts.level = vim.log.levels.DEBUG
	if opts.title then
		opts.title = "idle.nvim: " .. opts.title
	end
	if type(msg) == "string" then
		M.notify(msg, opts)
	else
		opts.lang = "lua"
		M.notify(vim.inspect(msg), opts)
	end
end

-- used to create a read only table
-- see https://www.lua.org/pil/13.4.5.html
function M.readOnly(t)
	local proxy = {}
	local mt = { -- create metatable
		__index = t,
		__newindex = function(_, _, _)
			error("attempt to update a read-only table", 2)
		end,
	}
	setmetatable(proxy, mt)
	return proxy
end

return M
