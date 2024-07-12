---@class ft_nvim.Config
---@field norminette? ft_nvim.NorminetteConfig
---@field header? ft_nvim.HeaderConfig

---@type ft_nvim.Config
local default_opts = {
	header = {
		enabled = true,
		username = "marvin",
		email = "marvin@42.fr",
	},
	norminette = {
		enabled = true,
		cmd = "norminette",
	},
}
local header = require("ft_nvim.header")
local norminette = require("ft_nvim.norminette")

---@type fun(opts: ft_nvim.Config)
local function validate(opts)
	vim.validate({
		header = {
			opts.header,
			header.validate,
			"ft_nvim.HeaderConfig",
		},
		norminette = {
			opts.norminette,
			norminette.validate,
			"ft_nvim.NorminetteConfig",
		},
	})
end

return {
	---@param opts ft_nvim.Config
	setup = function(opts)
		opts = vim.tbl_deep_extend("force", default_opts, opts or {})
		validate(opts)

		if opts.norminette.enabled then
			norminette.setup(opts.norminette)
		end

		if opts.header.enabled then
			header.setup(opts.header)
		end
	end,
}
