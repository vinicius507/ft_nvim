return {
	---@type fun(opts: ft_nvim.HeaderConfig)
	setup = function(opts)
		local upsert = function()
			local bufnr = vim.api.nvim_get_current_buf()

			require("ft_nvim.header.buffer").update(bufnr, opts, true)
		end

		vim.api.nvim_create_user_command("FtHeader", upsert, {
			desc = "Upsert École 42 header",
		})
	end,
}
