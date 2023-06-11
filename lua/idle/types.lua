---@class IdleConfigOptions
---@field colorscheme string|function #Either the colorscheme name or a function to activate the colorscheme
---@field debug boolean #Wether to enable debug notification messages or not
---@field namespace string #The name of the folder where your custom config files are located. Default value is `user` and will require modules from `lua/user`
---@field notifications_default_title string #Change the default titles for notifications sent using Idle wrappers
---@field source string[] #The files that will be loaded from the namespace folder above. They will be loaded in this order
---@field [string] any #You can add any other key so it will be added to the Idle.options global object.

---@class IdleConfig: IdleConfigOptions
---@field setup fun(opts: IdleConfigOptions): IdleConfigOptions #Sets up the Config object
---@field options IdleConfigOptions
---@field custom_options IdleConfigOptions

---@class IdleGlobal
---@field namespace string #The current namespace being used
---@field options IdleConfigOptions #The options passed during configuration
---@field load fun(mod: string, ...): nil|unknown # Safe load a module. Wrapper around `safe_require`
---@field has_plugin fun(plugin: string): boolean # Check if a plugin is installed
---@field safe_require fun(mod: string, opts?: IdleSafeRequireOpts): nil|unknown # Safely require a module that might not exists

---@class IdleSafeRequireOpts
---@field silent boolean #If true, do not alert if module can't be loaded. Defaults to false;
