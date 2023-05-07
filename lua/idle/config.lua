local M = {}

local defaults = {
	-- colorscheme can be a string with the colorscheme name or a function that
	-- will load the colorscheme use this after adding the coloscheme specs to
	-- your configuration
	colorscheme = "habamax",
	-- the name of the folder where your custom config files are located. Default
	-- value is `user` and will require modules from `lua/user`
	namespace = "user",
	-- the files that will be loaded from the namespace folder above. They will be
	-- loaded in this order
	source = {
		"options",
		"keymaps",
		"commands",
		"autocmds",
	},
	debug = vim.env.IDLE_DEBUG or false,
}

local function setup_global_idle(options)
	local readOnly = require("idle.util").readOnly

	_G.Idle = readOnly({
		namespace = options.namespace,
		options = readOnly(options.opts),
		load = function(name)
			local Util = require("idle.util")
			local mod = options.namespace .. "." .. name
			Util.debug("Looking for module " .. mod)
			local loaded_module = Util.safe_require(mod)
			if not loaded_module then
				return nil
			end
			Util.debug("Found module " .. mod)
			return loaded_module
		end,
		has_plugin = require("idle.helpers.plugin").is_installed,
		safe_require = require("idle.util").safe_require,
	})
end

M.setup = function(options)
	M.options = vim.tbl_deep_extend("force", defaults, options or {})
	M.options.opts = options or {}
	setup_global_idle(M.options)

	return M.options
end

setmetatable(M, {
	__index = function(_, key)
		if M.options == nil then
			return vim.deepcopy(defaults)[key]
		end
		return M.options[key]
	end,
})

return M
