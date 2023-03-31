---@class IdleCommandSpec
---@field name string The command name. It should start with a capital letter
---@field command function | string It can either be another command or a lua function. See :h nvim_create_user_command for more info
---@field opts table<string, any> Options passed directly to nvim_create_user_command

---@alias IdleCommandSpecList table<string, IdleCommandSpec>
--
---Create a command from IdleCommandSpec
---@param spec IdleCommandSpec
local function create_command_from_spec(spec)
	spec.opts = spec.opts or {}
	if spec.desc then
		spec.opts.desc = spec.desc
		spec.desc = nil
	end
	vim.api.nvim_create_user_command(spec.name, spec.command, spec.opts)
end

local M = {}
---Creates multiple commands from a spec list
---@param commands IdleCommandSpecList
M.create_commands_from_spec_list = function(commands)
	for command, spec in pairs(commands) do
		spec.name = command
		create_command_from_spec(spec)
	end
end

---Create a new user command
---@param name string | IdleCommandSpec
---@param command string
---@param opts table<string, any>
---@return nil
M.create_command = function(name, command, opts)
	if type(name) == "table" then
		---@cast name IdleCommandSpec
		return create_command_from_spec(name)
	else
		---@cast name string
		return create_command_from_spec({
			name = name,
			command = command,
			opts = opts,
		})
	end
end

return M
