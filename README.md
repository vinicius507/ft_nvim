# 42 Nvim

Neovim plugin for [École 42](https://42.fr).

> [!NOTE]
> This plugin is still in early development. Breaking changes are expected.

## Features

- **Norminette Integration**: Use [norminette](https://github.com/42School/norminette) as a diagnostics source.

## Installation

**Requirements:**

- [Neovim](https://github.com/neovim/neovim) >= 0.6.0
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) (Optional, used for
  norminette integration)

You can install the plugin using your favorite package manager:

- [lazy.nvim 💤](https://github.com/folke/lazy.nvim)

```lua
---@type LazySpec
return {
	"vinicius507/ft_nvim",
	ft = { "c", "cpp" }, -- Lazy load for .c and .h files.
	---@type ft_nvim.Config
	opts = {},
}
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
	"vinicius507/ft_nvim",
	ft = { "c", "cpp" }, -- Lazy load for .c and .h files.
	config = function()
		require("ft_nvim").setup()
	end,
})
```

- Neovim's built-in package manager

```sh
git clone --depth 1 https://github.com/vinicius507/ft_nvim \
	${XDG_DATA_HOME:-~/.local/share}/nvim/site/pack/packer/start/ft_nvim
```

## Configuration

The plugin can be configured by calling the `setup` function and passing an
optional configuration object.

The following options are available:

```lua
require("ft_nvim").setup({
	-- Configures the norminette integration.
	norminette = {
		-- Enable the norminette integration (default: true).
		enable = true,
		-- The command to run norminette (default: "norminette").
		cmd = "norminette",
		-- A function to conditionally enable the norminette integration (default: nil)
		condition = function()
			return true
		end,
	},
})
```
