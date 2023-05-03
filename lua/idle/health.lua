local M = {}

local function nice_print(o, max_level, level)
	max_level = max_level or 1
	level = level or 0
	if type(o) == "table" then
		if level < max_level then
			local s = "{ "
			for k, v in pairs(o) do
				if type(k) ~= "number" then
					s = s .. '"' .. k .. '" = '
				end
				s = s .. nice_print(v, max_level, level + 1) .. ", "
			end
			return s .. "}"
		else
			return "{ … }"
		end
	else
		return '"' .. tostring(o) .. '"'
	end
end

M.required_lazy_version = ">=9.1.0"

function M.check_lazy_version(current, minimum)
	local Semver = require("lazy.manage.semver")
	return Semver.range(minimum):matches(current)
end

function M.check()
	vim.health.report_start("idle.nvim")

	if vim.fn.has("nvim-0.8.0") == 1 then
		vim.health.report_ok("Using Neovim >= 0.8.0")
	else
		vim.health.report_error("Neovim >= 0.8.0 is required")
	end

	local Util = require("idle.util")
	local lazy = Util.safe_require("lazy")

	if not lazy then
		vim.health.report_error("lazy.nvim is required")
		return
	end

	local lazy_version = require("lazy.core.config").version or "0.0.0"
	local message = "lazy.nvim version is "
		.. lazy_version
		.. ". (required "
		.. M.required_lazy_version
		.. ")"
	if M.check_lazy_version(lazy_version, M.required_lazy_version) then
		vim.health.report_ok(message)
	else
		vim.health.report_error(message)
	end

	local opts = require("idle.config").custom_options
	if opts.namespace then
		message = ("Using custom config namespace (" .. opts.namespace .. ")")
	else
		local idle = require("idle.config")
		message = (
			"Using default config namespace ("
			.. idle.options.namespace
			.. ")"
		)
	end
	vim.health.report_info(message)
	vim.health.report_info("Custom options:")
	local opts_count = 0
	for key, value in pairs(opts) do
		opts_count = opts_count + 1
		vim.health.report_info(
			"  " .. opts_count .. ". " .. key .. " = " .. nice_print(value)
		)
	end
end

return M
