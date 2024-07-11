return {
	---@type fun(opts: ft_nvim.NorminetteConfig)
	setup = function(opts)
		vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
			group = vim.api.nvim_create_augroup("Norminette", { clear = true }),
			desc = "Lint with Norminette",
			pattern = { "*.c", "*.h" },
			callback = function()
				-- Ignore windows with normeignore set
				if vim.w.normeignore then
					return
				end

				if opts.condition and opts.condition() then
					return
				end

				require("lint").try_lint(opts.cmd)
			end,
		})
	end,
}
