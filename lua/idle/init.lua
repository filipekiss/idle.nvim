local Config = require("idle.config")
local M = {}

M.version = "0.0.0"

function M.setup(opts)
	Config.setup(opts)
	-- load autocmds and keymaps

	-- apply the colorscheme if set
	if Config.colorscheme then
		if type(Config.colorscheme) == "function" then
			Config.colorscheme()
		else
			vim.cmd.colorscheme(Config.colorscheme)
		end
	end

	for _, file in ipairs(Config.source) do
		Idle.safe_require(Config.namespace .. "." .. file, { silent = true })
	end
end

return M
