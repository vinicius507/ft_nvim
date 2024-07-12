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

return {
	---@type fun(opts: ft_nvim.HeaderConfig)
	setup = function(opts)
		if not opts.enabled then
			return
		end
	end,
	---@type fun(opts: unknown): boolean
	validate = function(opts)
		if type(opts) ~= "table" then
			return false
		end

		if opts.enabled ~= nil and type(opts.enabled) ~= "boolean" then
			return false
		end

		if opts.username ~= nil and type(opts.username) ~= "string" then
			return false
		end

		if opts.email ~= nil and type(opts.email) ~= "string" then
			return false
		end

		return true
	end,
}
