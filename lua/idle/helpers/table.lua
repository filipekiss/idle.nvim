local Util = require("idle.util")

local M = {}

function M.get_table_keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

function M.table_has(haystack, needle)
	for _, value in ipairs(haystack) do
		if value == needle then
			return true
		end
	end
	return false
end

---@alias nvim_proxy_table table
---@alias nvim_var_types
---| "buffer" # Handle buffer (b:) variables
---| "window" # Handle window (w:) variables
---| "global" # Handle global (g:) variables

---Creates a table whose keys are actually tied to nvim variables
---This is very useful to handle buffer and window variables, for example:
---
---```lua
---local myplugin_buffer_options = nvim_var_table({
---  filetype = "myplugin_filetype",
---  enabled = "myplugin_enable"
---})
--
---myplugin_buffer_options.filetypes =  "lua"
---
---if
---  myplugin_buffer_options.enabled == true
---  and vim.bo.filetype == myplugin_buffer_options.filetype
---then
---  -- do something
---end
---```
---
---Line #5 will set a buffer var `b:myplugin_filetype` to the value of `lua`
---The variable can also be changed using `:lua vim.b.myplugin_enabled` or
---`let b:myplugin_enabled`. (I recommend using the lua variant)
--
---The function will never error, but will emit warnings when trying to
---manipulate variables that have not been set during initialization:
---
---```lua
---myplugin_buffer_options.has_setup = true
---```
---
---The code above will not update `has_setup` and will display a warning. If
---you are getting a value instead of setting, you will receive `nil` and a
---warning will be displayed.
---
---@param t table A table in the format `{ key = variable_name }`
---@param type nvim_var_types
---@return nvim_proxy_table #A proxy table that manipulates the variables in nvim
function M.nvim_var_table(t, type)
	local get_nvim_var_function = type == "buffer" and vim.api.nvim_buf_get_var
		or type == "window" and vim.api.nvim_win_get_var
		or vim.api.nvim_get_var
	local set_nvim_var_function = type == "buffer" and vim.api.nvim_buf_set_var
		or type == "window" and vim.api.nvim_win_set_var
		or vim.api.nvim_set_var
	return setmetatable({}, {
		__index = function(_, key)
			if t[key] == nil then
				Util.warn(
					"attempting to access non-existing key ["
						.. key
						.. "]. Valid keys are ["
						.. t.concat(M.get_table_keys(t), ", ")
						.. "]"
				)
				return nil
			end
			if type == "global" then
				local status_ok, var_value = pcall(
					get_nvim_var_function,
					t[key]
				)
				if status_ok then
					return var_value
				end
			else
				local status_ok, var_value = pcall(
					get_nvim_var_function,
					0,
					t[key]
				)
				if status_ok then
					return var_value
				end
			end
			return nil
		end,
		__newindex = function(_, key, value)
			-- if key is not set, we have no business acessing these variables
			if t[key] == nil then
				Util.warn(
					"attempting to write to non-existing key ["
						.. key
						.. "]. Valid keys are ["
						.. t.concat(M.get_table_keys(t), ", ")
						.. "]"
				)
				return nil
			end
			if type == "global" then
				set_nvim_var_function(t[key], value)
			else
				set_nvim_var_function(0, t[key], value)
			end
			return value
		end,
	})
end

---Wrapper around `M.nvim_var_table` for the buffer type
---@param it table
---@return nvim_proxy_table
function M.buffer_table(it)
	return M.nvim_var_table(it, "buffer")
end

---Wrapper around `M.nvim_var_table` for the window type
---@param it table
---@return nvim_proxy_table
function M.window_table(it)
	return M.nvim_var_table(it, "window")
end

---Wrapper around `M.nvim_var_table` for the global type
---@param it table
---@return nvim_proxy_table
function M.global_table(it)
	return M.nvim_var_table(it, "global")
end

function M.merge_tables(left, right)
	return vim.tbl_deep_extend("force", left, right)
end

local E = {}

E.recursive_mt = function(should_recurse)
	return {
		__index = function(t, key)
			local value = rawget(t, key)
			if value ~= nil then
				return value
			else
				if should_recurse then
					local new_table = {}
					setmetatable(new_table, E.recursive_mt(false))
					rawset(t, key, new_table)
					return new_table
				else
					return nil
				end
			end
		end,
	}
end

--- Make a table recursive, so you can access infinitely nested properties and
--- always get non-nil results
---@generic T: table
---@param table T The table that you want to make recursive
---@param max_recursion? number By default, the table will be infinitely recursive. You can pass a positive integer so it will be recursive only X levels deep
---@param level? number This is used to handle recursion, you shouldn't need to manually set this
---@return T
function M.recursive_table(table, max_recursion, level)
	level = level or 0
	max_recursion = max_recursion or -1
	local new_table = {}
	for key, value in pairs(table) do
		if
			type(table[key]) == "table"
			and (max_recursion == -1 or level < max_recursion)
		then
			new_table[key] = M.recursive_table(value, max_recursion, level + 1)
		else
			new_table[key] = value
		end
	end
	return setmetatable(
		new_table,
		E.recursive_mt(max_recursion == -1 or level < max_recursion)
	)
end

return M
