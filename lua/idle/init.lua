local M = {}

M.version = "0.0.0"

local defaults = {
	-- colorscheme can be a string like `habamax` or a function that will load the colorscheme
	colorscheme = nil,
	-- the name of the folder where your custom config files are located. Default
	-- value is `user` and will require modules from `lua/user`
	namespace = "user",
	-- enable idle.nvim debug mode
	debug = false,
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", defaults, opts or {})
	M.options.opts = opts
	-- load autocmds and keymaps

	-- apply the colorscheme if set
	if M.options.colorscheme then
		require("lazy.core.util").try(function()
			if type(M.options.colorscheme) == "function" then
				M.options.colorscheme()
			else
				vim.cmd.colorscheme(M.options.colorscheme)
			end
		end, {
			msg = "Could not load your colorscheme",
			on_error = function(msg)
				require("lazy.core.util").error(msg)
				vim.cmd.colorscheme(defaults.colorscheme)
			end,
		})
	end


	M.load(M.options.namespace, "autocmds")
	M.load(M.options.namespace, "keymaps")
	M.load(M.options.namespace, "options")
  M.load(M.options.namespace, "commands")

end

function M.load(namespace, name)
	local Lazy = require("lazy.core.util")
	local Util = require("idle.util")
	local function _load(mod)
		Lazy.try(function()
			Util.debug("Looking for module " .. mod)
			require(mod)
			Util.debug("Found module " .. mod)
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
