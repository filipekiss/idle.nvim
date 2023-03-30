local M = {}

function M.safe_require(module_name)
	local package_exists, module = pcall(require, module_name)
	if not package_exists then
		vim.defer_fn(function()
			vim.schedule(function()
        M.error(
					"Could not load module: " .. module_name,
					{ title = "Module Not Found" }
				)
			end)
		end, 1000)
		return nil
	else
		return module
	end
end

function M.notify(msg, opts)
  local lazy_notify = require("lazy.core.util").notify
  opts.title = opts.title or "idle.nvim"
  lazy_notify(msg, opts)
end

function M.error(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

function M.info(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

function M.warn(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

function M.debug(msg, opts)
  if not require("idle").options.debug then
    return
  end
  opts = opts or {}
  if opts.title then
    opts.title = "idle.nvim: " .. opts.title
  end
  if type(msg) == "string" then
    M.notify(msg, opts)
  else
    opts.lang = "lua"
    M.notify(vim.inspect(msg), opts)
  end
end


return M
