local M = {}

M.version = "0.0.0"

local defaults = {
	-- colorscheme can be a string with the colorscheme name or a function that
	-- will load the colorscheme use this after adding the coloscheme specs to
	-- your configuration
	colorscheme = nil,
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
	-- enable idle.nvim debug mode
	debug = false,
}

local function setup_global_idle()
	local readOnly = require("idle.util").readOnly
	_G.Idle = readOnly({
		namespace = M.options.namespace,
		load = function(name, opts)
			local defaults = {
				namespace = Idle.namespace,
			}
			local options = vim.tbl_deep_extend("force", defaults, opts or {})
			local namespace = options.namespace
			options.namespace = nil
			local Util = require("idle.util")
			local mod = namespace .. "." .. name
			Util.debug("Looking for module " .. mod)
			local loaded_module = Util.safe_require(mod, options or {})
			if not loaded_module then
				return nil
			end
			Util.debug("Found module " .. mod)
			return loaded_module
		end,
	})
end

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

	-- setup global Idle now so it can be used in the files that will be loaded
	-- after
	setup_global_idle()

	local load_options = { silent = true }
	for _, file in ipairs(M.options.source) do
		Idle.load(file, load_options)
	end

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
