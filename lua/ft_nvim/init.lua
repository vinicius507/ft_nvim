---@class ft_nvim.Config
---@field norminette? ft_nvim.NorminetteConfig

---@class ft_nvim.NorminetteConfig
---@field enabled? boolean
---@field condition? fun(): boolean

return {
	---@param opts ft_nvim.Config
	setup = function(opts)
		local default_opts = {
			norminette = {
				enabled = vim.fn.executable("norminette") ~= 0,
			},
		}

		opts = vim.tbl_deep_extend("force", default_opts, opts)

		if opts.norminette.enabled then
			if not pcall(require, "lint") then
				error("Missing required dependency: 'nvim-lint'")
			end

			vim.api.nvim_create_augroup("Norminette", {
				clear = true,
			})
			vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
				desc = "Lint with Norminette",
				pattern = { "*.c", "*.h" },
				callback = function()
					if opts.norminette.condition and not opts.norminette.condition() then
						return
					end

					require("lint").try_lint("norminette")
				end,
			})
		end
	end,
}
