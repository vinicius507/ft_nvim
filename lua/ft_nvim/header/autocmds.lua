return {
	---@type fun(opts: ft_nvim.HeaderConfig)
	setup = function(opts)
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("FtHeader", { clear = true }),
			desc = "Updates 42 header on save",
			callback = function(ctx)
				require("ft_nvim.header.api").update(ctx.buf, opts)
			end,
		})
	end,
}
