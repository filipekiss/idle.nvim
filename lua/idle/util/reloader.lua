-- when you want to invoke this, use the code below in lua/idle/init.lua
-- vim.api.nvim_create_autocmd("User", {
-- pattern = "VeryLazy",
-- once = true,
-- callback = function()
-- require("idle.util.reloader").enable()
-- end,
-- })
local Util = require("idle.util")
local Idle = require("idle")

local M = {}

---@type table<string, vim.loop.Stat>
M.files = {}

---@type vim.loop.Timer
M.timer = nil

function M.enable()
	if M.timer then
		M.timer:stop()
	end

	M.idle_settings_root = vim.fn.stdpath("config")
		.. "/lua/"
		.. Idle.options.namespace
	M.timer = vim.loop.new_timer()
	M.check(true)
	M.timer:start(2000, 2000, M.check)
end

function M.disable()
	if M.timer then
		M.timer:stop()
		M.timer = nil
	end
end

---@param h1 vim.loop.Stat
---@param h2 vim.loop.Stat
function M.eq(h1, h2)
	return h1
		and h2
		and h1.size == h2.size
		and h1.mtime.sec == h2.mtime.sec
		and h1.mtime.nsec == h2.mtime.nsec
end

function M.check(start)
	---@type table<string,true>
	local checked = {}
	---@type {file:string, what:string}[]
	local changes = {}

	function M.ls(path, fn)
		local handle = vim.loop.fs_scandir(path)
		while handle do
			local name, t = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end
			if fn(path .. "/" .. name, name, t) == false then
				break
			end
		end
	end

	function M.lsmod(root, fn)
		M.ls(root, function(path, name, type)
			if
				type == "file"
				and name:sub(-4) == ".lua"
				and name ~= "init.lua"
			then
				fn(name:sub(1, -5), path)
			elseif
				type == "directory" and vim.loop.fs_stat(path .. "/init.lua")
			then
				fn(name, path .. "/init.lua")
			end
		end)
	end

	-- spec is a module
	local function check(_, modpath)
		checked[modpath] = true
		local hash = vim.loop.fs_stat(modpath)
		if hash then
			if M.files[modpath] then
				if not M.eq(M.files[modpath], hash) then
					M.files[modpath] = hash
					table.insert(changes, { file = modpath, what = "changed" })
				end
			else
				M.files[modpath] = hash
				table.insert(changes, { file = modpath, what = "added" })
			end
		end
	end

	M.lsmod(M.idle_settings_root, check)

	for _, file in ipairs(Idle.options.source) do
		local namespace = Idle.options.namespace
		local file_location = M.idle_settings_root .. "/" .. file .. ".lua"
	end

	for file in pairs(M.files) do
		if not checked[file] then
			table.insert(changes, { file = file, what = "deleted" })
			M.files[file] = nil
		end
	end

	if not (start or #changes == 0) then
		vim.schedule(function()
			local lines = {
				"#Idle Config Change Detected. Reloading...",
				"",
			}
			for _, change in ipairs(changes) do
				table.insert(
					lines,
					"- **"
						.. change.what
						.. "**: `"
						.. vim.fn.fnamemodify(change.file, ":p:~:.")
						.. "`"
				)
			end
			Util.warn(lines)
		end)
	end
end

return M
