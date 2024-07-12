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

local header = require("ft_nvim.header.header")

return {
	---@type fun(opts: ft_nvim.HeaderConfig)
	setup = function(opts)
		if not opts.enabled then
			return
		end

		vim.api.nvim_create_user_command("FtHeader", function()
			if header.buf_has_header(0) then
				header.update(0, opts)
				return
			end
			header.insert(0, opts)
		end, { desc = "Upsert École 42 header" })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("FtHeader", { clear = true }),
			callback = function(ctx)
				header.update(ctx.buf, opts)
			end,
		})
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
