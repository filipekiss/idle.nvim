---@type IdleConfig
local M = {}

---@type IdleConfigOptions
local defaults = {
	colorscheme = "habamax",
	namespace = "user",
	source = {
		"options",
		"keymaps",
		"commands",
		"autocmds",
	},
	debug = vim.env.IDLE_DEBUG or false,
}

---@param options IdleConfigOptions
local function setup_global_idle(options)
	local readOnly = require("idle.util").readOnly
	local recursive_table = require("idle.helpers.table").recursive_table

	_G.Idle = readOnly({
		namespace = options.namespace,
		options = recursive_table(options),
		load = function(name, ...)
			local Util = require("idle.util")
			local mod = options.namespace .. "." .. name
			Util.debug("Looking for module " .. mod)
			local loaded_module = Util.safe_require(mod, ...)
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
	M.custom_options = options or {}
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
