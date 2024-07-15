---@class ft_nvim.HeaderConfig
---@field enabled boolean
---@field username string?
---@field email string?
---
---Example:
---@code
---require("ft_nvim.header").setup({
---	enabled = true,
---	username = "marvin",
---	email = "marvin@42.fr",
---})
---@endcode

---@type ft_nvim.HeaderConfig
local default_opts = {
	enabled = true,
	username = "marvin",
	email = "marvin@42.fr",
}

return {
	---@type fun(opts: ft_nvim.HeaderConfig)
	setup = function(opts)
		opts = vim.tbl_extend("force", opts or {}, default_opts)
		vim.validate({
			enabled = { opts.enabled, "boolean" },
			username = { opts.username, "string", true },
			email = { opts.email, "string", true },
		})

		if not opts.enabled then
			return
		end

		require("ft_nvim.header.autocmds").setup(opts)
		require("ft_nvim.header.commands").setup(opts)
	end,
}
