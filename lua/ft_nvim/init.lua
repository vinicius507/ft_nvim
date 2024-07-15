---@class ft_nvim.Config
---@field norminette? ft_nvim.NorminetteConfig
---@field header? ft_nvim.HeaderConfig

local header = require("ft_nvim.header")
local norminette = require("ft_nvim.norminette")

return {
	---@param opts ft_nvim.Config
	setup = function(opts)
		header.setup(opts.header)
		norminette.setup(opts.norminette)
	end,
}
