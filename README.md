# idle.nvim

> this is an experimental package, built to suit my personal needs. use at your own discretion

idle.nvim is a minimal neovim configuration framework built on top of lazy.nvim.

### how it works

it adds some quality of life things to make customizing nvim a bit more
pleasant. this is mainly used to power my personal setup, just bundled as a
plugin for convenience.

* for example, with the default options, it will automatically require some
  files in `lua/user/` folder (the files will be loaded in this order):

 - lua/user/options.lua
 - lua/user/keymaps.lua
 - lua/user/autocmds.lua
 - lua/user/commands.lua

### global `Idle` object

After idle.nvim is initialized, it sets up a global `Idle` object with some
helper functions and some configuration properties

```lua
-- _G.Idle is read-only and has the following defaults
_G.Idle{
		namespace = "user", -- the folder where to load modules from
		options = {}, -- the options passed during Idle#setup
		load = function(name)
			--[[ 
            wrapper around Idle#safe_require that loads modules from the folder
            located at lua/<namespace>/<module>.
            e.g.: if `Idle.namespace` is `user`, calling `Idle.load("functions")` is
            the same as `Idle.safe_require("user.functions")`
            ]]--
		end,
		has_plugin = function(plugin_name)
        -- checks if `plugin_name` is installed
        end,
		safe_require = function(module, opts)
        -- wrapper around pcall to safely load modules that might not exist
        end
	} 
```

### Helpers

Besides the helpers in the global object, there are some other helpers that can
be `require`d to make things easier to write.

#### idle.helpers.autocmd

```lua
local M = {}

M.autocmd = vim.api.nvim_create_autocmd

function M.augroup(name, clear)
	-- used to create an augroup that you pass in the `group` options of
    -- `vim.api.nvim_create_autocmd`
    -- if you pass clear = true, the augroup will clear any previous autocmd in
    -- that group. default is false
end

function M.create_user_autocmd(pattern, opts)
    -- wrapper around vim.api.nvim_create_autocmd for User commands
end

function M.exec_user_autocmd(pattern, opts)
    -- wrapper around vim.api.nvim_exec_autocmd for User commands
end


return M
```

### Configuration

```lua
require("idle").setup {
	-- colorscheme can be a string with the colorscheme name or a function that
	-- will load the colorscheme use this after adding the coloscheme specs to
	-- your configuration
	colorscheme = "habamax",
	-- the name of the folder where your custom config files are located. Default
	-- value is `user` and will require modules from `lua/user`
	namespace = "user",
	-- the files that will be loaded from the namespace folder above. They will be
	-- loaded in this order.
	source = {
		"options",
		"keymaps",
		"commands",
		"autocmds",
	},
	-- enable idle.nvim debug mode
	debug = false, -- you can also use IDLE_DEBUG environment var
}
```


### Configuration
```lua
require("idle").setup {
	-- colorscheme can be a string with the colorscheme name or a function that
	-- will load the colorscheme use this after adding the coloscheme specs to
	-- your configuration
	colorscheme = "habamax",
	-- the name of the folder where your custom config files are located. Default
	-- value is `user` and will require modules from `lua/user`
	namespace = "user",
	-- the files that will be loaded from the namespace folder above. They will be
	-- loaded in this order.
	source = {
		"options",
		"keymaps",
		"commands",
		"autocmds",
	},
	-- enable idle.nvim debug mode
	debug = false,
}
```


### things i wanna do

 - [ ] watch lua/user/* files and reload and apply them when they are saved
