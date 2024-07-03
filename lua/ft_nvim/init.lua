---@class ft_nvim.Config
---@field norminette? ft_nvim.NorminetteConfig

local default_opts = {
	norminette = {
		enabled = true,
		cmd = "norminette",
	},
}
local norminette = require("ft_nvim.norminette")

return {
	---@param opts ft_nvim.Config
	setup = function(opts)
		opts = vim.tbl_deep_extend("force", default_opts, opts)

		if opts.norminette.enabled then
			norminette.setup(opts.norminette)
		end
	end,
}
