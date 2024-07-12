# 42 Nvim

Neovim plugin for [École 42](https://42.fr).

> [!NOTE]
> This plugin is still in early development. Breaking changes are expected.

## Features

- **Norminette Integration**: Use [norminette](https://github.com/42School/norminette) as a diagnostics source.

## Installation

**Requirements:**

- Neovim >= 0.6.0
- `nvim-lint` (Optional, used for norminette integration)

### lazy.nvim 💤

```lua
---@type LazySpec
return {
	"vinicius507/ft_nvim",
	ft = { "c", "cpp" }, -- Lazy load for .c and .h files.
	---@type ft_nvim.Config
	opts = {},
}
```

## Configuration

The plugin can be configured by calling the `setup` function and an optional
configuration object.

The following options are available:

```lua
require("ft_nvim").setup({
	-- Configures the norminette integration.
	norminette = {
		enable = true, -- Enable the norminette integration (default: true).
		cmd = "norminette", -- The command to run norminette (default: "norminette").
		-- A function to conditionally enable the norminette integration (default: nil)
		condition = function()
			return true
		end,
	},
})
```
