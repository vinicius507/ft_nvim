---@class ft_nvim.NorminetteConfig
---@field enabled boolean
---@field cmd? string
---@field condition? fun(): boolean
---
---Example:
---@code
---require("ft_nvim.norminette").setup({
---	enabled = true,
---	cmd = "norminette",
---	condition = function()
---		local filepath = vim.fn.expand("%:p")
---		if not filepath:match("42sp") then
---			return false
---		end
---		return vim.bo.filetype == "c"
---	end,
---})
---@endcode

return {
	---@type fun(opts: ft_nvim.NorminetteConfig)
	setup = function(opts)
		if not opts.enabled then
			return
		end

		if not pcall(require, "lint") then
			error("Missing required dependency: 'nvim-lint'")
		end

		require("ft_nvim.norminette.autocmds").setup(opts)
		require("ft_nvim.norminette.commands").setup()
	end,
	---@type fun(opts: unknown): boolean
	validate = function(opts)
		if type(opts) ~= "table" then
			return false
		end

		if opts.enabled ~= nil and type(opts.enabled) ~= "boolean" then
			return false
		end

		if opts.cmd ~= nil and type(opts.cmd) ~= "string" then
			return false
		end

		if opts.condition ~= nil and type(opts.condition) ~= "function" then
			return false
		end

		return true
	end,
}
