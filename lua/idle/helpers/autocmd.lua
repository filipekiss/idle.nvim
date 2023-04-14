local M = {}

M.autocmd = vim.api.nvim_create_autocmd

function M.augroup(name, clear)
	return vim.api.nvim_create_augroup(
		Idle.namespace .. name,
		{ clear = clear ~= false or false }
	)
end

function M.create_user_autocmd(pattern, opts)
	opts.pattern = pattern
	return vim.api.nvim_create_autocmd("User", opts)
end

function M.exec_user_autocmd(pattern, opts)
	opts.pattern = pattern
	return vim.api.nvim_exec_autocmds("User", opts)
end

return M
