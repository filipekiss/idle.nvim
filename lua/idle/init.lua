local Config = require("idle.config")
local M = {}

M.version = "0.0.0"

function M.setup(opts)
	Config.setup(opts)
	-- check if we have the IDLE_COLORSCHEME env var set
	if vim.env.IDLE_COLORSCHEME then
		vim.cmd.colorscheme(vim.env.IDLE_COLORSCHEME)
		-- check if the colorscheme was set in the plugin config
	elseif Config.colorscheme then
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
