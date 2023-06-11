local M = {}

function M.map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		-- if opts is a string, treat it as description
		opts = opts or {}
		if type(opts) == "string" then
			opts = { desc = opts }
		end
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

local mapping_commands = {
	["ma"] = { mode = { "n", "v", "o" }, remap = true },
	["nm"] = { mode = { "n" }, remap = true },
	["vm"] = { mode = { "v" }, remap = true },
	["xm"] = { mode = { "x" }, remap = true },
	["sm"] = { mode = { "s" }, remap = true },
	["om"] = { mode = { "o" }, remap = true },
	["im"] = { mode = { "i" }, remap = true },
	["lm"] = { mode = { "l" }, remap = true },
	["cm"] = { mode = { "c" }, remap = true },
	["tm"] = { mode = { "t" }, remap = true },
	["no"] = { mode = { "n", "v", "o" }, remap = false },
	["nn"] = { mode = { "n" }, remap = false },
	["vn"] = { mode = { "v" }, remap = false },
	["xn"] = { mode = { "x" }, remap = false },
	["sn"] = { mode = { "s" }, remap = false },
	["on"] = { mode = { "o" }, remap = false },
	["in"] = { mode = { "i" }, remap = false },
	["ln"] = { mode = { "l" }, remap = false },
	["cn"] = { mode = { "c" }, remap = false },
	["tn"] = { mode = { "t" }, remap = false },
	-- ic mappings
	["map!"] = { mode = { "i", "c" }, remap = true },
	["no!"] = { mode = { "i", "c" }, remap = false },
	["noremap!"] = { mode = { "i", "c" }, remap = false },
}

local function get_mode_and_remap(mode_str)
	local mode = nil
	local is_ic = string.sub(mode_str, -1) == "!"
	if is_ic then
		mode = mapping_commands[mode_str]
	end
	mode = mode or mapping_commands[string.sub(mode_str, 1, 2)]
	if not mode then
		return nil
	end
	return mode.mode, mode.remap
end

local function make_map(mode_str, lhs, rhs, opts)
	local mode, remap = get_mode_and_remap(mode_str)
	if not mode then
		error("Invalid mapping mode: " .. mode_str)
	end
	opts = opts or {}
	opts.remap = remap
	M.map(mode, lhs, rhs, opts)
end

setmetatable(M, {
	__index = function(_, key)
		return function(lhs, rhs, opts)
			return make_map(key, lhs, rhs, opts)
		end
	end,
})

return M
