local M = {}

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

	local opts = require("idle").opts
	if opts.namespace then
		message = (
			"Using custom config namespace ("
			.. options.namespace
			.. ")"
		)
	else
		local idle = require("idle")
		message = ("Using default config namespace (" .. idle.namespace .. ")")
	end
	vim.health.report_info(message)
end

return M
