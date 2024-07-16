---@class ft_nvim.Config
---@field norminette? ft_nvim.NorminetteConfig
---@field header? ft_nvim.HeaderConfig

local header = require("ft_nvim.header")
local norminette = require("ft_nvim.norminette")

---@type fun(opts: unknown): ft_nvim.Config
local function validate_config(opts)
	if not opts then
		return {}
	end

	vim.validate({
		header = { opts.header, "table", true },
		norminette = { opts.norminette, "table", true },
	})
	return {
		header = opts.header,
		norminette = opts.norminette,
	}
end

return {
	---@param opts? ft_nvim.Config
	setup = function(opts)
		opts = validate_config(opts)

		header.setup(opts.header)
		norminette.setup(opts.norminette)
	end,
}
