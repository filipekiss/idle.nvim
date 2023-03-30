# idle.nvim

> this is an experimental package, use at your own risk

idle.nvim is a minimal neovim configuration framework built on top of lazy.nvim.

### why I'm building this?

I migrated my old neovim configuration to a full lua setup a while ago, but I
was never quite happy with it. I started looking into pre-made configurations,
like [AstroNvim](https://astronvim.com/),
[CosmicNvim](https://github.com/CosmicNvim/CosmicNvim),
[NvChad](https://nvchad.com/) and so many others, but it was always hard for me
to "buy in" the whole setup. I have been using vim for a few years now, so I
have a lot of quirks that I'm used to. I don't think it's efficient to run a
full configuration and then disable a lot of stuff that I won't use, so I set
out to create a configuration framework. It didn't quite work out as I wanted,
so I kinda just stopped working on it.

A few weeks ago, I was introduced to
[lazy.nvim](https://github.com/folke/lazy.nvim/), a plugin manager for Neovim
which seemed to be a better alternative to what I was using at the time. With
that, I also got word of [LazyVim](https://github.com/LazyVim/LazyVim), which is
a pre-made setup built using lazy.nvim as a base. It seemed that I had found a
great place to start with my setup, but LazyVim comes with a lot of things
setup. It was really close, but not exactly what I wanted. So I gave up and went
back to my old configuration.

So, one day, my LSP configuration breaks and I decide that I will take this
chance to replace my plugin manager with lazy.nvim. And when I started doing
that, I realized that lazy.nvim was the perfect plugin manager to build my
configuration framework on top. That's when I came up with idle.nvim.

you can think of idle.nvim as a slimmed down version of LazyVim: all the quality
of life things that make LazyVim great, but you need to bring your own
configuration

### how it works

idle.nvim aims to be out of your way. most of the time, you won't even know that
idle is there. that's why it's called idle. but there are some nice things that
it will do that will make the experience of managing and customizing your neovim
setup a little more pleasant.

for example, it will autoload some files in `lua/user/` folder (the files will
  be loaded in this order):

 - lua/user/autocmds.lua
 - lua/user/keymaps.lua
 - lua/user/options.lua

### roadmap

 - [ ] watch lua/user/* files and reload them when they are saved
 - [ ] write usage guide
 - [ ] write proper docs
 - [ ] load shareable configurations
