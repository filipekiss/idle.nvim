local M = {}

M.version = "0.0.0"

local defaults = {
	-- colorscheme can be a string like `habamax` or a function that will load the colorscheme
	colorscheme = nil,
	namespace = "config",
}

local options

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
	options.opts = opts
	-- load autocmds and keymaps

	-- apply the colorscheme if set
	if options.colorscheme then
		require("lazy.core.util").try(function()
			if type(options.colorscheme) == "function" then
				options.colorscheme()
			else
				vim.cmd.colorscheme(options.colorscheme)
			end
		end, {
			msg = "Could not load your colorscheme",
			on_error = function(msg)
				require("lazy.core.util").error(msg)
				vim.cmd.colorscheme(defaults.colorscheme)
			end,
		})
	end

	M.load(options.namespace, "autocmds")
	M.load(options.namespace, "keymaps")
	M.load(options.namespace, "options")
end

function M.load(namespace, name)
	local Util = require("lazy.core.util")
	local function _load(mod)
		Util.try(function()
			require(mod)
		end, {
			msg = "Failed loading " .. mod,
			on_error = function(msg)
				local info = require("lazy.core.cache").find(mod)
				if info == nil or (type(info) == "table" and #info == 0) then
					return
				end
				Util.error(msg)
			end,
		})
	end
	_load(namespace .. "." .. name)
end

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		return options[key]
	end,
})

return M
