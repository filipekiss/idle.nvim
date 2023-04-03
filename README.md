# idle.nvim

> this is an experimental package, use at your own risk

idle.nvim is a minimal neovim configuration framework built on top of lazy.nvim.

### why I'm building this?

I migrated my old neovim configuration to a full lua setup a while ago, but I
was never quite happy with it. I started looking into pre-made configurations,
like [AstroNvim](https://astronvim.com/), [CosmicNvim](https://github.com/CosmicNvim/CosmicNvim), [NvChad](https://nvchad.com/) and so many others, but it was always
hard for me to "buy in" the whole setup. I have been using vim for a few years
now, so I have a lot of quirks that I'm used to. I don't think it's efficient to
run a full configuration and then disable a lot of stuff that I won't use, so I
set out to create a configuration framework. It didn't quite work out as I
wanted, so I kinda just stopped working on it.

A few weeks ago, I was introduced to [lazy.nvim](https://github.com/folke/lazy.nvim/), a plugin manager for Neovim
which seemed to be a better alternative to what I was using at the time. With
that, I also got word of [LazyVim](https://github.com/LazyVim/LazyVim), which is a pre-made setup built using lazy.nvim
as a base. It seemed that I had found a great place to start with my setup, but
LazyVim comes with a lot of things setup. It was really close, but not exactly
what I wanted. So I gave up and went back to my old configuration.

So, one day, my LSP configuration breaks and I decide that I will take this
chance to replace my plugin manager with lazy.nvim. And when I started doing
that, I realized that lazy.nvim was the perfect plugin manager to build my
configuration framework on top.

### how it works

idle.nvim aims to be out of your way. most of the time, you won't even know that
idle is there. that's why it's called idle. but there are some nice things that
it will do that will make the experience of managing and customizing your neovim
setup a little more pleasant.

for example, it will autoload some files in `lua/user/` folder (the files will
  be loaded in this order):

 - lua/user/options.lua
 - lua/user/keymaps.lua
 - lua/user/autocmds.lua
 - lua/user/commands.lua

> ℹ️  You can use any folder other than `user` by using the `namespace` option when
configuring `idle.nvim`.

In these files (and any files loaded after), you can use the global `Idle`. It
has some properties and methods that can be used to configure neovim.

##### `Idle.namespace`

> default value: "user"

The namespace used to load configuration files. This can be set during
`idle.nvim` initialization.

##### `Idle.load()`

> Idle.load("module_name", { namespace = Idle.namepsace, silent = false })

This is a wrapper around Lua's default `require` used to load modules from the
default namespace. The main difference is that if the module does not exists you
won't see a huge error message. The second argument accepts a table with two options:
`namespace`, which by default is the namespace setup during `idle.nvim`
initialization. `silent` will control if the function should notify if the
module is not found or not. You can omit the second argument altogether if you
want to use the default values.

### Configuration

```lua
{
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
