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

---@type fun(opts: ft_nvim.NorminetteConfig)
local function setup_autocmds(opts)
	vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
		group = vim.api.nvim_create_augroup("Norminette", { clear = true }),
		desc = "Lint with Norminette",
		pattern = { "*.c", "*.h" },
		callback = function()
			if vim.w.normeignore then
				return -- Ignore windows with normeignore set
			end
			if opts.condition and opts.condition() then
				return
			end

			require("lint").try_lint(opts.cmd)
		end,
	})
end

return {
	---@param opts ft_nvim.NorminetteConfig
	setup = function(opts)
		if not opts.enabled then
			return
		end

		if not pcall(require, "lint") then
			error("Missing required dependency: 'nvim-lint'")
		end

		setup_autocmds(opts)
	end,
}
