local M = {}

M.version = "0.0.0"

local defaults = {
	-- colorscheme can be a string like `habamax` or a function that will load the colorscheme
	colorscheme = nil,
}

local options

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
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
end

return M
