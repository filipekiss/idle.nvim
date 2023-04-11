# idle.nvim

> this is an experimental package, built to suit my personal needs. use at your own discretion

idle.nvim is a minimal neovim configuration framework built on top of lazy.nvim.

### how it works

it adds some quality of life things to make customizing nvim a bit more
pleasant. this is mainly used to power my personal setup, just bundled as a
plugin for convenience.

* for example, it will autoload some files in `lua/user/` folder (the files will
  be loaded in this order):

 - lua/user/options.lua
 - lua/user/keymaps.lua
 - lua/user/autocmds.lua
 - lua/user/commands.lua

* idle.nvim adds `Idle` to the global namespace:

```lua
-- _G.Idle is read-only and has the following defaults
_G.Idle {
	namespace = "user", -- where to load the files from
	options = {}, -- the options passed during configuration
	load = function (mod)
		-- load the module from the namespace above
		-- basically just a wrapper to idle.util#safe_require(M.options.namespace .. "mod")
	end,
	safe_require = function (mod, opts)
		-- see idle.util#safe_require
	end
}
__
```

### Configuration

```lua
require("idle").setup {
	-- colorscheme can be a string with the colorscheme name or a function that
	-- will load the colorscheme use this after adding the coloscheme specs to
	-- your configuration
	colorscheme = nil,
	-- the name of the folder where your custom config files are located. Default
	-- value is `user` and will require modules from `lua/user`
	namespace = "user",
	-- the files that will be loaded from the namespace folder above. They will be
	-- loaded in this order
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
